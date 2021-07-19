local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Cryo = require(Packages.Cryo)

return function(Roact, ReactRoblox)
	local Provider = function(props)
		return Roact.createElement(
			"Frame",
			Cryo.Dictionary.join(props, {
				Name = "Provider",
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
			}),
			props.children
		)
	end

	return Provider
end
