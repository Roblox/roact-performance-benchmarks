local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array
local Boolean = LuauPolyfill.Boolean

local Timing = require(script.Parent.Benchmark.timing)
local Math = require(script.Parent.Benchmark.math)

local RunService = game:GetService("RunService")

local BenchmarkType: BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local function shouldRender(cycle: number, benchmarkType: string): boolean
	if benchmarkType == BenchmarkType.MOUNT or benchmarkType == BenchmarkType.UNMOUNT then
		-- Render every odd iteration (first, third, etc)
		-- Mounts and unmounts the component
		return ((cycle + 1) % 2) == 0
	elseif benchmarkType == BenchmarkType.UPDATE then
		-- Render every iteration (updates previously rendered module)
		return true
	else
		return false
	end
end

local function shouldRecord(cycle: number, benchmarkType: string): boolean
	if benchmarkType == BenchmarkType.MOUNT then
		-- Record every odd iteration (when mounted: first, third, etc)
		return ((cycle + 1) % 2) == 0
	elseif benchmarkType == BenchmarkType.UPDATE then
		-- Record every iteration
		return true
	elseif benchmarkType == BenchmarkType.UNMOUNT then
		-- Record every even iteration (when unmounted)
		return (cycle % 2) == 0
	else
		return false
	end
end

-- ROBLOX deviation: new function is needed as we need to know the amount of
-- samples we're going to have for constructing the table.
local function getCycleCount(sampleCount: number, benchmarkType: string): number
	if benchmarkType == BenchmarkType.MOUNT then
		return sampleCount * 2
	elseif benchmarkType == BenchmarkType.UPDATE then
		return sampleCount
	elseif benchmarkType == BenchmarkType.UNMOUNT then
		return sampleCount * 2 + 1
	else
		return 0
	end
end

-- ROBLOX deviation: re-use cycle count code.
local function isDone(cycle: number, sampleCount: number, benchmarkType: string): boolean
	if
		benchmarkType == BenchmarkType.MOUNT
		or benchmarkType == BenchmarkType.UPDATE
		or benchmarkType == BenchmarkType.UNMOUNT
	then
		return cycle >= getCycleCount(sampleCount, benchmarkType)
	else
		return true
	end
end

local function sortNumbers(a: number, b: number): number
	return a - b
end

type BenchmarkPropsType = {
	component: any, -- Should be a Roact component
	forceLayout: boolean?,
	getComponentProps: ({ [any]: any }) -> { [any]: any },
	onComplete: (BenchResultsType) -> (),
	sampleCount: number,
	timeout: number,
	type: string,
}

type BenchmarkStateType = {
	componentProps: { [any]: any },
	cycle: number,
	running: boolean,
}

local Benchmark = Roact.Component:extend("Benchmark")

Benchmark.displayName = "Benchmark"

Benchmark.defaultProps = {
	sampleCount = 50,
	timeout = 10000, -- 10 seconds
	type = BenchmarkType.MOUNT,
}

function Benchmark:init(props)
	self._render_step = nil
	self._startTime = nil
	self._samples = nil

	local cycle = 1
	local componentProps = props.getComponentProps({ cycle = cycle })

	self.state = {
		componentProps = componentProps,
		cycle = cycle,
		running = false,
	}

	self._startTime = 0
	self._timeout = 0
	self._samples = {}
end

function Benchmark.getDerivedStateFromProps(nextProps, prevState)
	if nextProps ~= nil then
		return {
			componentProps = nextProps.getComponentProps({ cycle = prevState.cycle }),
		}
	end
	return nil
end

function Benchmark:componentDidUpdate()
	local forceLayout, sampleCount, benchmarkType = self.props.forceLayout, self.props.sampleCount, self.props.type
	local cycle, running = self.state.cycle, self.state.running

	if running and shouldRecord(cycle, benchmarkType) then
		self._samples[cycle].scriptingEnd = Timing.now()

		-- TODO: Original source forces a re-calc here. Is there a way to force
		-- the Roblox UI to do something similar? Is that even needed here?
		if forceLayout then
			self._samples[cycle].layoutStart = Timing.now()
			-- FORCE RECALC
			self._samples[cycle].layoutEnd = Timing.now()
		end
	end

	if running then
		local now = Timing.now()

		if not isDone(cycle, sampleCount, benchmarkType) and (now < self._timeout or self._timeout <= 0) then
			self:_handleCycleComplete()
		else
			self:_handleComplete(now)
		end
	end
end

function Benchmark:componentWillUnmount()
	self:stop()
end

function Benchmark:render()
	local component, benchmarkType = self.props.component, self.props.type
	local componentProps, cycle, running = self.state.componentProps, self.state.cycle, self.state.running

	if running and shouldRecord(cycle, benchmarkType) then
		self._samples[cycle] = { scriptingStart = Timing.now() }
	end

	local props = Cryo.Dictionary.join(componentProps, { anchorPoint = Vector2.new(0.5, 0.5) })

	if running and shouldRender(cycle, benchmarkType) then
		return Roact.createElement(component, props)
	elseif not running then
		return Roact.createElement(component, props)
	else
		return nil
	end
end

function Benchmark:stop()
	if self._render_step ~= nil then
		local success, message = pcall(function()
			RunService:UnbindFromRenderStep(self._render_step)
		end)
		if not success then
			print("An error occurred unbinding from render step: " .. message)
		end
	end

	self._render_step = nil

	self:setState(function()
		return {
			running = false,
			cycle = 1,
		}
	end)
end

function Benchmark:start()
	local benchmarkType, sampleCount = self.props.type, self.props.sampleCount

	-- Fill the samples table with how many samples we expect so length checks
	-- work as expected after the benchmark finishes.
	self._samples = {}
	for i = 1, getCycleCount(sampleCount, benchmarkType) do
		table.insert(self._samples, false)
	end

	self:setState(function()
		if not self.state.running then
			self._startTime = Timing.now()
			self._timeout = self._startTime + self.props.timeout
		end

		return {
			running = true,
			cycle = 1,
		}
	end)
end

function Benchmark:getSamples()
	return Array.reduce(self._samples, function(memo, props)
		-- ROBLOX deviation: skip unrecorded samples. In JavaScript the array
		-- iteration functions skip missing items. We substitute empty items
		-- with booleans to ensure that length checks still work.
		if not props then
			return memo
		end

		local scriptingStart, scriptingEnd, layoutStart, layoutEnd =
			props.scriptingStart, props.scriptingEnd, props.layoutStart, props.layoutEnd

		-- ROBLOX deviation: Use JS-style truthiness polyfill to mimic behavior
		-- of || chain for values going into the memo.
		local stop = 0
		if Boolean.toJSBoolean(layoutEnd) then
			stop = layoutEnd
		elseif Boolean.toJSBoolean(scriptingEnd) then
			stop = scriptingEnd
		end
		local memoScriptingEnd = 0
		if Boolean.toJSBoolean(scriptingEnd) then
			memoScriptingEnd = scriptingEnd
		end

		table.insert(memo, {
			start = scriptingStart,
			stop = stop,
			scriptingStart = scriptingStart,
			scriptingEnd = memoScriptingEnd,
			layoutStart = layoutStart,
			layoutEnd = layoutEnd,
		})
		return memo
	end)
end

function Benchmark:_handleCycleComplete()
	local getComponentProps, benchmarkType = self.props.getComponentProps, self.props.type
	local cycle = self.state.cycle

	local componentProps
	if getComponentProps ~= nil then
		componentProps = getComponentProps({ cycle = cycle })
		if benchmarkType == BenchmarkType.UPDATE then
			componentProps["data-test"] = cycle
		end
	end

	if self._render_step == nil then
		self._render_step = "BenchmarkRenderStep"
		RunService:BindToRenderStep(self._render_step, Enum.RenderPriority.First.Value, function()
			self:setState({
				cycle = self.state.cycle + 1,
				componentProps = componentProps,
			})
		end)
	end
end

function Benchmark:_handleComplete(endTime: number)
	local onComplete = self.props.onComplete
	local samples = self:getSamples()

	print("Got " .. #samples .. " samples")

	-- ROBLOX deviation: use stop function as we have to manage the render step
	-- binding in the port, and share cleanup code with the unmount function.
	-- In the JS version the animation frame has to be requested each time.
	self:stop()

	local runTime = endTime - self._startTime
	local sortedElapsedTimes = Array.sort(
		Array.map(samples, function(props)
			local start, stop = props.start, props.stop
			return stop - start
		end),
		sortNumbers
	)
	local sortedScriptingElapsedTimes = Array.sort(
		Array.map(samples, function(props)
			local scriptingStart, scriptingEnd = props.scriptingStart, props.scriptingEnd
			return scriptingEnd - scriptingStart
		end),
		sortNumbers
	)
	local sortedLayoutElapsedTimes = Array.sort(
		Array.map(samples, function(props)
			local layoutStart, layoutEnd = props.layoutStart, props.layoutEnd
			local rLayoutEnd = 0
			if Boolean.toJSBoolean(layoutEnd) then
				rLayoutEnd = layoutEnd
			end
			local rLayoutStart = 0
			if Boolean.toJSBoolean(layoutStart) then
				rLayoutStart = layoutStart
			end
			return rLayoutEnd - rLayoutStart
		end),
		sortNumbers
	)

	onComplete({
		startTime = self._startTime,
		endTime = endTime,
		runTime = runTime,
		sampleCount = #samples,
		samples = samples,
		max = sortedElapsedTimes[#sortedElapsedTimes],
		min = sortedElapsedTimes[1],
		median = Math.getMedian(sortedElapsedTimes),
		mean = Math.getMean(sortedElapsedTimes),
		stdDev = Math.getStdDev(sortedElapsedTimes),
		meanLayout = Math.getMean(sortedLayoutElapsedTimes),
		meanScripting = Math.getMean(sortedScriptingElapsedTimes),
	})
end

return Benchmark
