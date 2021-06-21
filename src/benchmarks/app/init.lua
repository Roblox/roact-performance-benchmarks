local rootWorkspace = script.Parent.Parent
local Packages = rootWorkspace.Packages
local Benchmarks = rootWorkspace.Benchmarks

local Workspace = game:GetService("Workspace")
local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)
local ReactRoblox = require(Packages.ReactRoblox)
local useState = Roact.useState
local useRef = Roact.useRef
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local Button = require(Benchmarks.app.Button)
local Benchmark = require(Benchmarks.app.Benchmark)

-- TODO: This might need to be something else that sinks input.
local Overlay = function()
	return Roact.createElement("Frame", { Name = "Overlay" })
end

-- ROBLOX deviation: no context object available, use props.
local App = function(props)
	local currentBenchmarkName, setCurrentBenchmarkName = useState(Object.keys(props.tests)[1])
	local currentLibraryName, setCurrentLibraryName = useState("roact")
	local status, setStatus = useState("idle")
	local results, setResults = useState({})
	local benchRef = useRef(false)

	local tests = props.tests
	local currentImplementation = tests[currentBenchmarkName][currentLibraryName]
	local Component, Provider, getComponentProps, sampleCount = currentImplementation.Component,
		currentImplementation.Provider,
		currentImplementation.getComponentProps,
		currentImplementation.sampleCount

	local handleStart = function()
		setStatus("running")

		print(
			"handleStart invoked, starting benchmark '"
				.. currentBenchmarkName
				.. "' for library'"
				.. currentLibraryName
				.. "'"
		)

		-- local benchmark = benchRef:getValue()
		local benchmark = benchRef.current
		benchmark:start()

		-- TODO: Add scroll to end after report card is implemented.
	end

	local handleClear = function()
		print("handleClear invoked, clearing results")
		setResults({})
	end

	local createHandleComplete = function(props)
		return function(new_results)
			local benchmarkName, libraryName = props.benchmarkName, props.libraryName

			-- TODO: Format these numbers into something readable.
			print("Got results = " .. tostring(new_results))
			print("    Run Time: " .. new_results.runTime)
			print("    Sample Count: " .. new_results.sampleCount)
			print("    Max: " .. new_results.max)
			print("    Min: " .. new_results.min)
			print("    Median: " .. new_results.median)
			print("    Mean: " .. new_results.mean)
			print("    SD: " .. new_results.stdDev)
			print("    MeanLayout: " .. new_results.meanLayout)
			print("    MeanScripting: " .. new_results.meanScripting)

			setResults(Array.concat(
				results,
				Object.assign({}, new_results, {
					benchmarkName = benchmarkName,
					libraryName = libraryName,
					libraryVersion = tests[benchmarkName][libraryName].version,
				})
			))
			setStatus("idle")
		end
	end

	-- ROBLOX deviation: ternary operators aren't supported.

	local statusText
	local overlay

	local benchmark = Roact.createElement(Benchmark, {
		component = Component,
		forceLayout = true,
		getComponentProps = getComponentProps,
		onComplete = createHandleComplete({
			sampleCount = sampleCount,
			benchmarkName = currentBenchmarkName,
			libraryName = currentLibraryName,
		}),
		ref = benchRef,
		sampleCount = sampleCount,
		timeout = 20000,
		type = Component.benchmarkType,
	})

	if status == "running" then
		statusText = "Running…"
		overlay = Roact.createElement(Overlay, nil)
	else
		statusText = "Run"
		overlay = nil
	end

	local disableButtons = status == "running"

	return Roact.createElement("Frame", { Name = "Container" }, {
		ActionPanel = Roact.createElement("Frame", nil, {
			-- Pickers
			Roact.createElement("Frame", {
				Name = "InputContainer",
				Position = UDim2.new(1, 0, 1, 400),
			}, {
				Roact.createElement("TextLabel", {
					Name = "LibraryLabel",
					Size = UDim2.new(0, 100, 0, 50),
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(0, 0),
					Text = "Library",
				}),
				Roact.createElement("TextLabel", {
					Name = "CurrentLibraryNameLabel",
					Size = UDim2.new(0, 100, 0, 50),
					Position = UDim2.new(1, 0, 0, 60),
					AnchorPoint = Vector2.new(0, 0),
					Text = currentLibraryName,
				}),
				-- Roact.createElement(Picker, {
				-- 	Size = UDim2.new(0, 100, 0, 50),
				-- 	Position = UDim2.new(1, 0, 0, 0),
				-- 	AnchorPoint = Vector2.new(1, 0),
				-- }, {
				-- 	-- Picker choices
				-- }),
			}),
			-- Status
			Roact.createElement("Frame", { Name = "ControlsContainer" }, {
				Roact.createElement(Button, {
					Name = "StartButton",
					Size = UDim2.new(0, 100, 0, 50),
					Position = UDim2.new(1, 0, 1, 240),
					AnchorPoint = Vector2.new(0, 0),
					Text = statusText,
					BackgroundColor3 = Color3.new(0, 1, 0),
					Active = not disableButtons,
					[ReactRoblox.Event.Activated] = handleStart,
				}),
			}),
		}),
		ListPanel = Roact.createElement("Frame", nil, {
			Roact.createElement(Button, {
				Name = "ClearButton",
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 0, 1, 180),
				AnchorPoint = Vector2.new(0, 0),
				Text = "Clear", -- TODO: replace with icon
				BackgroundColor3 = Color3.new(1, 0, 0),
				Active = not disableButtons,
				[ReactRoblox.Event.Activated] = handleClear,
			}),
			Roact.createElement("ScrollingFrame", {
				-- TODO: styles
			}, {
				-- Array.map(results, function(r, i)
				-- 	return Roact.createElement(ReportCard, {
				-- 		benchmarkName = r.benchmarkName,
				-- 		key = i,
				-- 		libraryName = r.libraryName,
				-- 		libraryVersion = r.libraryVersion,
				-- 		mean = r.mean,
				-- 		meanLayout = r.meanLayout,
				-- 		meanScripting = r.meanScripting,
				-- 		runTime = r.runTime,
				-- 		sampleCount = r.sampleCount,
				-- 		stdDev = r.stdDev,
				-- 	})
				-- end),
			}),
			overlay,
		}),
		ViewPanel = Roact.createElement("Frame", {
			Position = UDim2.new(
				0,
				Workspace.CurrentCamera.ViewportSize.X / 2,
				0,
				Workspace.CurrentCamera.ViewportSize.Y / 2
			),
		}, {
			-- TODO: Add hide benchmark button
			Roact.createElement(Provider, nil, {
				BenchWrapper = Roact.createElement("Frame", {
					Name = "BenchWrapper",
					Position = UDim2.new(0, 320, 0, 240),
				}, {
					benchmark,
				}),
			}),
		}),
	})
end

return App
