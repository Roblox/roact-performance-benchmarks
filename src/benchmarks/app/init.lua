local rootWorkspace = script.Parent.Parent.Parent
local Benchmarks = rootWorkspace.PerformanceBenchmarks.benchmarks

local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local Types = require(script.Benchmark.types)

-- ROBLOX deviation: no context object available, use props.
return function(Roact, ReactRoblox)
	local useState = Roact.useState
	local useRef = Roact.useRef

	local Benchmark = require(Benchmarks.app.Benchmark)(Roact, ReactRoblox)
	local Button = require(Benchmarks.app.Button)(Roact, ReactRoblox)
	local Entry = require(Benchmarks.app.Picker.Entry)(Roact, ReactRoblox)
	local Header = require(Benchmarks.app.Picker.Header)(Roact, ReactRoblox)
	local Picker = require(Benchmarks.app.Picker)(Roact, ReactRoblox)

	local App = function(props)
		local currentBenchmarkName, setCurrentBenchmarkName = useState(Object.keys(props.tests)[1])
		local currentLibraryName = useState("roact")
		local status, setStatus = useState("idle")
		local results, setResults = useState({})
		local benchRef = useRef(false)

		local tests = props.tests
		local currentImplementation = tests[currentBenchmarkName][currentLibraryName]
		local Component, Provider, getComponentProps, sampleCount, benchmarkType, providerAnchorPoint =
			currentImplementation.Component,
			currentImplementation.Provider,
			currentImplementation.getComponentProps,
			currentImplementation.sampleCount,
			currentImplementation.benchmarkType,
			currentImplementation.anchorPoint

		local handleStart = function()
			setStatus("running")

			local benchmark = benchRef.current
			benchmark:start()
		end

		local createHandleComplete = function(parentProps)
			return function(new_results: Types.BenchResultsType)
				local benchmarkName, libraryName = parentProps.benchmarkName, parentProps.libraryName

				print("Results for " .. currentBenchmarkName .. " using " .. currentLibraryName)
				print(("├─ Run Time: %.3f ms"):format(new_results.runTime))
				print(("├─ Sample Count: %d"):format(new_results.sampleCount))
				print(("├─ Max: %.3f ms"):format(new_results.max))
				print(("├─ Min: %.3f ms"):format(new_results.min))
				print(("├─ Median: %.3f ms"):format(new_results.median))
				print(("├─ Mean: %.3f ms"):format(new_results.mean))
				print(("└─ Standard Deviation: %3.2f%%"):format(new_results.stdDev))

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
			type = benchmarkType,
		})

		local pickerEntries = {}
		pickerEntries[#pickerEntries + 1] = Roact.createElement(Header, {
			Text = "Benchmark Choices",
			LayoutOrder = #pickerEntries,
		})
		for k, _ in pairs(props.tests) do
			pickerEntries[#pickerEntries + 1] = Roact.createElement(Entry, {
				Text = k,
				LayoutOrder = #pickerEntries,
				OnSelect = function(rbx)
					setCurrentBenchmarkName(k)
				end,
			})
		end

		if status == "running" then
			statusText = "Running…"
		else
			statusText = "Run"
		end

		local disableButtons = status == "running"

		return Roact.createElement("Frame", { Name = "Container", Size = UDim2.new(1, 0, 1, 0) }, {
			ActionPanel = Roact.createElement("Frame", { ZIndex = 10 }, {
				Roact.createElement("Frame", {
					Name = "InputContainer",
					Position = UDim2.new(0, 0, 0, 200),
				}, {
					Roact.createElement("TextLabel", {
						Name = "BenchmarkLabel",
						Size = UDim2.new(0, 100, 0, 50),
						Position = UDim2.new(0, 0, 0, 0),
						AnchorPoint = Vector2.new(0, 0),
						Text = "Benchmark",
					}),
					Roact.createElement("TextLabel", {
						Name = "CurrentBenchmarkNameLabel",
						Size = UDim2.new(0, 100, 0, 50),
						Position = UDim2.new(0, 0, 0, 60),
						AnchorPoint = Vector2.new(0, 0),
						Text = currentBenchmarkName,
					}),
					Roact.createElement(Picker, {
						Size = UDim2.new(0, 100, 0, 50),
						Position = UDim2.new(0, 250, 0, -16),
						AnchorPoint = Vector2.new(0, 0),
					}, pickerEntries),
					Roact.createElement("Frame", { Name = "ControlsContainer" }, {
						Roact.createElement(Button, {
							Name = "StartButton",
							Size = UDim2.new(0, 100, 0, 50),
							Position = UDim2.new(1, 0, 1, 120),
							AnchorPoint = Vector2.new(0, 0),
							Text = statusText,
							BackgroundColor3 = Color3.new(0, 1, 0),
							Active = not disableButtons,
							[ReactRoblox.Event.Activated] = handleStart,
						}),
					}),
				}),
			}),
			ViewPanel = Roact.createElement("Frame", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = Color3.new(0, 0, 0),
				Name = "ProviderWrapper",
			}, {
				Roact.createElement(Provider, { Name = "Provider", AnchorPoint = providerAnchorPoint }, { benchmark }),
			}),
		})
	end

	return App
end
