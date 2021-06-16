local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)

local Provider = function(props)
	return Roact.createElement(
		"Frame",
		Cryo.Dictionary.join(props, {
			BackgroundColor3 = Color3.new(0.078, 0.09, 0.1),
			Size = UDim2.new(0, 640, 0, 480),
			AnchorPoint = Vector2.new(0.5, 0.5),
		}),
		props.children
	)
end

return Provider
