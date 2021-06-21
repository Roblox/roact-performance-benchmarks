local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)

local COLORS = {
	Color3.new(0.078, 0.09, 0.102),
	Color3.new(0.667, 0.722, 0.761),
	Color3.new(0.902, 0.925, 0.941),
	Color3.new(1, 0.678, 0.122),
	Color3.new(0.957, 0.365, 0.133),
	Color3.new(0.878, 0.141, 0.369),
}

local BASE_SIZE = UDim2.new(0, 6, 0, 6)

local function Box(props)
	local index, depth, color, layout, outer, fixed =
		(props.index or 1), props.depth, props.color, props.layout, props.outer, props.fixed

	local results = {}

	local frameProps = {
		Name = props.Name or "Box",
		AutomaticSize = 3,
		BackgroundColor3 = COLORS[(color or 0) + 1],
		BorderSizePixel = 0,
		Size = UDim2.new(
			BASE_SIZE.X.Scale,
			BASE_SIZE.X.Offset * (depth + 1),
			BASE_SIZE.Y.Scale,
			BASE_SIZE.Y.Offset * (depth + 1)
		),
	}

	local fillDirection
	if layout == "row" then
		fillDirection = 0 -- Horizontal
	else
		fillDirection = 1 -- Vertical
	end

	local childCount = #(props.children or {})
	local grid = Roact.createElement("UIGridLayout", {
		CellPadding = UDim2.new(1, 6, 1, 6),
		CellSize = UDim2.new(
			BASE_SIZE.X.Scale,
			BASE_SIZE.X.Offset * (depth + 1),
			BASE_SIZE.Y.Scale,
			BASE_SIZE.Y.Offset * (depth + 1)
		),
		FillDirection = fillDirection,
		FillDirectionMaxCells = childCount,
		StartCorner = 0, -- Top Left
	})
	table.insert(results, grid)

	local frame = Roact.createElement("Frame", frameProps, props.children)
	table.insert(results, frame)

	return results
end

return Box
