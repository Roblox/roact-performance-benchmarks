local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)
local LuauPolyfill = require(Packages.LuauPolyfill)

local fmt = function(time: number)
	-- const i = Number(Math.round(time + 'e2') + 'e-2').toFixed(2);
	-- return 10 / i > 1 ? `0${i}` : i;
end

-- TODO: Pull from somewhere else.
local DivLike = function(props)
	return Roact.createElement("Frame", { Name = "Div" }, props.children)
end

local ReportCard = function(props)
    local sampleCountText = ""
	if props.sampleCount ~= nil then
		sampleCountText = "(" .. props.sampleCount .. ")"
	end

	local libraryVersionText = ""
	if props.libraryVersion ~= nil then
		libraryVersionText = "@" .. props.libraryVersion
	end

	local meanElements
	if props.mean ~= nil then
		meanElements = {
			Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = fmt(props.mean) .. " ±" .. fmt(props.stdDev) .. " ms",
				-- Bold, monospace
			}),
			Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = "(S/L) " .. fmt(props.meanScripting) .. "/" .. fmt(props.meanLayout) .. " ms",
				-- Small, monospace
			}),
		}
	else
		meanElements = {
			Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = "In progress…",
				-- Bold
			}),
		}
	end

	return Roact.createElement(DivLike, nil, {
		Roact.createElement(DivLike, nil, {
			Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = props.libraryName .. libraryVersionText,
				-- Bold
			}),
			Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = props.benchmarkName .. " " .. sampleCountText,
			}),
		}),
		Roact.createElement(DivLike, nil, meanElements),
	})
end

return ReportCard
