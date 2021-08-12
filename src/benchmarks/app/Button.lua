local rootWorkspace = script.Parent.Parent.Parent.Parent

local Cryo = require(rootWorkspace.Cryo)

return function(Roact, ReactRoblox)
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
end
