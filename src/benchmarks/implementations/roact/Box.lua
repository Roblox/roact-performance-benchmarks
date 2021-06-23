local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent
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
local BASE_PADDING = UDim2.new(0, 8, 0, 8)

local Box = Roact.Component:extend("Box")

function Box:init()
	self.state = {
		contentSize = UDim2.new(BASE_SIZE.X.Scale, 0, BASE_SIZE.Y.Scale, 0),
	}
	self:recalculateSize()
end

function Box:render()
	local size = self.state.size
	local anchorPoint, name, color, layout, useGrid =
		self.props.anchorPoint, self.props.name, self.props.color, self.props.layout, self.props.useGrid

	local fragments = {}

	local fillDirection
	if layout == "row" then
		fillDirection = 0 -- Horizontal
	else
		fillDirection = 1 -- Vertical
	end

	self:recalculateSize()

	if useGrid then
		local grid = Roact.createElement("UIGridLayout", {
			CellPadding = UDim2.new(0, 0, 0, 0),
			CellSize = size,
			FillDirection = fillDirection,
			FillDirectionMaxCells = #(self.props.children or {}),
			StartCorner = Enum.StartCorner.TopLeft,
			VerticalAlignment = 0,
			HorizontalAlignment = 0,
		})
		table.insert(fragments, grid)
	end

	local frame = Roact.createElement("Frame", {
		Name = name or "Box",
		AutomaticSize = 3,
		BackgroundColor3 = COLORS[(color or 0) + 1],
		BorderSizePixel = 0,
		Size = size,
		AnchorPoint = anchorPoint,
	}, self.props.children)
	table.insert(fragments, frame)

	return fragments
end

function Box:recalculateSize()
	local prevContentSize = self.state.contentSize
	local inheritedContentSize, onSizeUpdate = self.props.contentSize, self.props.onSizeUpdate

	local padding = UDim2.new(BASE_PADDING.X.Scale, BASE_PADDING.X.Offset, BASE_PADDING.Y.Scale, BASE_PADDING.Y.Offset)

	local inheritedContentSizeX
	local inheritedContentSizeY
	if inheritedContentSize ~= nil then
		inheritedContentSizeX = inheritedContentSize.X.Offset
		inheritedContentSizeY = inheritedContentSize.Y.Offset
	else
		inheritedContentSizeX = BASE_SIZE.X.Offset
		inheritedContentSizeY = BASE_SIZE.Y.Offset
	end

	local size = UDim2.new(BASE_SIZE.X.Scale, inheritedContentSizeX, BASE_SIZE.Y.Scale, inheritedContentSizeY)
	local contentSize = UDim2.new(
		BASE_SIZE.X.Scale,
		size.X.Offset + padding.X.Offset,
		BASE_SIZE.Y.Scale,
		size.Y.Offset + padding.Y.Offset
	)

	if
		onSizeUpdate ~= nil
		and (prevContentSize.X.Offset ~= contentSize.X.Offset or prevContentSize.Y.Offset ~= contentSize.Y.Offset)
	then
		self:setState(function()
			return {
				contentSize = contentSize,
				size = size,
			}
		end)
		onSizeUpdate(contentSize)
	end
end

return Box
