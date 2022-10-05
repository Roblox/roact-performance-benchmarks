local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent

local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Object = LuauPolyfill.Object

local COLORS = {
	Color3.new(0.078, 0.09, 0.102),
	Color3.new(0.667, 0.722, 0.761),
	Color3.new(0.902, 0.925, 0.941),
	Color3.new(1, 0.678, 0.122),
	Color3.new(0.957, 0.365, 0.133),
	Color3.new(0.878, 0.141, 0.369),
}

local INVALID_COLOR = Color3.new(1, 0, 1)

local BASE_SIZE = UDim2.new(0, 6, 0, 6)
local BASE_PADDING = UDim2.new(0, 4, 0, 4)

return function(Roact, ReactRoblox)
	local Box = Roact.Component:extend("Box")

	function Box:render()
		local children, name, color, layout, automaticSize, usePadding =
			self.props.children,
			self.props.name,
			self.props.color,
			self.props.layout,
			self.props.automaticSize,
			self.props.usePadding

		local fillDirection
		if layout == "row" then
			fillDirection = Enum.FillDirection.Horizontal
		else
			fillDirection = Enum.FillDirection.Vertical
		end

		local frameAutomaticSize, size = nil, nil
		if automaticSize then
			frameAutomaticSize = Enum.AutomaticSize.XY
		else
			size = BASE_SIZE
		end

		local siblings = {}

		if usePadding then
			local padding = Roact.createElement("UIPadding", {
				PaddingBottom = UDim.new(BASE_PADDING.Y.Scale, BASE_PADDING.Y.Offset),
				PaddingLeft = UDim.new(BASE_PADDING.X.Scale, BASE_PADDING.X.Offset),
				PaddingRight = UDim.new(BASE_PADDING.X.Scale, BASE_PADDING.X.Offset),
				PaddingTop = UDim.new(BASE_PADDING.Y.Scale, BASE_PADDING.Y.Offset),
			})
			siblings.padding = padding

			local listLayout = Roact.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				FillDirection = fillDirection,
				VerticalAlignment = 0,
				HorizontalAlignment = 0,
			})
			siblings.listLayout = listLayout
		end

		local backgroundColor
		local colorIndex = (color or 0) + 1
		if colorIndex > 0 then
			backgroundColor = COLORS[colorIndex]
		else
			backgroundColor = INVALID_COLOR
		end

		return Roact.createElement("Frame", {
			Name = name or "Box",
			AutomaticSize = frameAutomaticSize,
			BackgroundColor3 = backgroundColor,
			BorderSizePixel = 0,
			Size = size,
		}, Object.assign({}, children, siblings))
	end

	return Box
end
