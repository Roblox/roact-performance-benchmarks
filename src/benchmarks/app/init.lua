local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Benchmarks = rootWorkspace.Src.benchmarks

local Workspace = game:GetService("Workspace")
local Roact = require(Packages.Roact)
local ReactRoblox = require(Packages.ReactRoblox)
local useState = Roact.useState
local useRef = Roact.useRef
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local Benchmark = require(Benchmarks.app.Benchmark)
local Button = require(Benchmarks.app.Button)
local Entry = require(Benchmarks.app.Picker.Entry)
local Header = require(Benchmarks.app.Picker.Header)
local Picker = require(Benchmarks.app.Picker)

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

		local benchmark = benchRef.current
		benchmark:start()
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

	return Roact.createElement("Frame", { Name = "Container" }, {
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
					AutomaticSize = Enum.AutomaticSize.XY,
					AnchorPoint = Vector2.new(0.5, 0.5),
					Position = UDim2.new(
						0,
						Workspace.CurrentCamera.ViewportSize.X / 2,
						0,
						Workspace.CurrentCamera.ViewportSize.Y / 2
					),
				}, {
					benchmark,
				}),
			}),
		}),
	})
end

return App
