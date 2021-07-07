local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)

local function Header(props)
	return Roact.createElement("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = props.LayoutOrder,
		Text = props.Text,
		BackgroundTransparency = 0.0,
		BackgroundColor3 = Color3.fromRGB(235, 235, 220),
		BorderSizePixel = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		Font = Enum.Font.SourceSans,
		TextSize = 18,
	})
end

return Header
