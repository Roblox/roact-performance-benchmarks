local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local Button = function(props)
	local color
	if props.disabled then
		color = Color3.new(0.101, 0.101, 0.003)
	else
		color = Color3.new(0.098, 0.435, 0.011)
	end

	return Roact.createElement(
		"TextButton",
		Object.assign({}, {
			Active = not props.disabled,
			BackgroundColor3 = color,
			[Roact.Event.Activated] = props.onPress,
		}, props)
	)
end

return Button
