local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Cryo = require(Packages.Cryo)
local Roact = require(Packages.Roact)
local ReactRoblox = require(Packages.ReactRoblox)

local Button = function(props)
	local color
	if not props.Active then
		color = Color3.new(0.286274, 0.286274, 0.286274)
	end

	return Roact.createElement(
		"TextButton",
		Cryo.Dictionary.join(props, {
			BackgroundColor3 = color,
			[ReactRoblox.Event.Activated] = props.onPress,
		})
	)
end

return Button
