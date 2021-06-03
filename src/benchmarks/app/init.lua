local rootWorkspace = script.Parent.Parent
local Packages = rootWorkspace.Packages
local Benchmarks = rootWorkspace.Benchmarks

local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)
local useState = Roact.useState
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local Button = require(Benchmarks.app.Button)

-- TODO: Pull from somewhere else.
local DivLike = function(props)
	return Roact.createElement("Frame", Cryo.Dictionary.join({ Name = "Div" }, props), props.children)
end

local Overlay = function()
	return Roact.createElement("Frame", { Name = "Overlay" })
end

-- ROBLOX deviation: no context object available, use props.
local App = function(props)
	local currentBenchmarkName, setCurrentBenchmarkName = useState(Object.keys(props.tests)[1])
	local currentLibraryName, setCurrentLibraryName = useState("roact-benchmarks")
	local status, setStatus = useState("idle")
	local results, setResults = useState({})

	local handleStart = function()
		print("TODO: Start benchmarks")
	end

	local handleClear = function()
		print("TODO: Clear results")
	end

	-- ROBLOX deviation: ternary operators aren't supported.

	local statusText
	local overlay
	if status == "running" then
		statusText = "Running…"
		overlay = Roact.createElement(Overlay, nil)
	else
		statusText = "Run"
		overlay = nil
	end

	return Roact.createElement(DivLike, { Name = "Container" }, {
		actionPanel = Roact.createElement(DivLike, { Name = "ActionPanel" }, {
			-- Pickers
			Roact.createElement(DivLike, {
				Name = "InputContainer",
				Position = UDim2.new(1, 100, 1, 520),
			}, {
				Roact.createElement("TextLabel", {
					Name = "LibraryLabel",
					Size = UDim2.new(0, 100, 0, 50),
					Position = UDim2.new(1, 0, 1, -60),
					AnchorPoint = Vector2.new(1, 0),
					Text = "Library",
				}),
				Roact.createElement("TextLabel", {
					Name = "CurrentLibraryNameLabel",
					Size = UDim2.new(0, 100, 0, 50),
					Position = UDim2.new(1, 0, 0, 0),
					AnchorPoint = Vector2.new(1, 0),
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
			Roact.createElement(DivLike, { Name = "ControlsContainer" }, {
				Roact.createElement(Button, {
					Name = "StartButton",
					Size = UDim2.new(0, 100, 0, 50),
					Position = UDim2.new(1, 1150, 1, 120),
					AnchorPoint = Vector2.new(1, 0),
					Text = statusText,
					BackgroundColor3 = Color3.new(0, 1, 0),
					[Roact.Event.Activated] = handleStart,
				}),
			}),
		}),
		listPanel = Roact.createElement(DivLike, { Name = "ListPanel" }, {
			Roact.createElement(Button, {
				Name = "ClearButton",
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 1150, 1, 60),
				AnchorPoint = Vector2.new(1, 0),
				Text = "Clear", -- TODO: replace with icon
				BackgroundColor3 = Color3.new(1, 0, 0),
				[Roact.Event.Activated] = handleClear,
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
		viewPanel = nil,
	})
end

return App
