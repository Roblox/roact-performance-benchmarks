return function()
	local rootWorkspace = script.Parent.Parent
	local srcWorkspace = rootWorkspace.Src
	local PackagesWorkspace = rootWorkspace.Packages
	local Roact = require(PackagesWorkspace.Roact)
	local Array = require(PackagesWorkspace.LuauPolyfill).Array
	local Concurrent = require(srcWorkspace.concurrent)
	local useFrame = require(srcWorkspace.hooks.useFrame)
	local bootstrap = require(script.Parent.bootstrap)
	local calculateStats = require(script.Parent.calculateStats)

	local rootInstance = Instance.new("Folder")
	rootInstance.Name = "GuiRoot"

	local fpsValue = {}
	local values = {}

	local function CalcFPS()
		local last = os.clock()
		useFrame(function()
			local now = os.clock()
			local deltaTime = (now - last)
			local fps = 1 / deltaTime
			last = now
			table.insert(values, deltaTime * 1000)
			table.insert(fpsValue, fps)
			local stats = calculateStats(values)
			local fpsStats = calculateStats(fpsValue)
			print(Array.join({
				("#%04d"):format(#values),
				("\u{0394}t: %8.4f"):format(deltaTime * 1000),
				("FPS: %8.4f"):format(fps),
				("AVG(\u{0394}t/FPS): %8.4f / %8.4f"):format(1 / (stats.mean / 1000), fpsStats.mean),
				("VAR(\u{0394}t/FPS): %8.4f / %8.4f"):format(stats.variance, fpsStats.variance),
				("MIN(\u{0394}t/FPS): %8.4f / %8.4f"):format(stats.min, fpsStats.min),
				("MAX(\u{0394}t/FPS): %8.4f / %8.4f"):format(stats.max, fpsStats.max),
			}, "\t|\t"))
		end)

		return nil
	end

	local function Benchmark(props)
		return Roact.createElement("Folder", {}, {
			Roact.createElement(Concurrent, props),
			Roact.createElement(CalcFPS),
		})
	end

	local stop = bootstrap(rootInstance, Benchmark)

	wait(10)

	stop()
end
