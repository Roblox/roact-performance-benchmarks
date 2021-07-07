local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)

local Provider = function(props)
	return Roact.createElement(
		"Frame",
		Cryo.Dictionary.join(props, {
			Name = "Provider",
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			AutomaticSize = Enum.AutomaticSize.XY,
		}),
		props.children
	)
end

return Provider
