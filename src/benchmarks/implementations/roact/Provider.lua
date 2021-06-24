local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Workspace = game:GetService("Workspace")
local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)

local Provider = function(props)
	return Roact.createElement(
		"Frame",
		Cryo.Dictionary.join(props, {
			BackgroundColor3 = Color3.new(0, 0, 0),
			Position = UDim2.new(0, 0, 0, -35),
			Size = UDim2.new(0, Workspace.CurrentCamera.ViewportSize.X, 0, Workspace.CurrentCamera.ViewportSize.Y),
			AnchorPoint = Vector2.new(0.5, 0.5),
		}),
		props.children
	)
end

return Provider
