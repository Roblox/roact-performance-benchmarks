local rootWorkspace = script.Parent.Parent.Parent.Parent
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

local function TextBox(props)
	return Roact.createElement("TextLabel", {
		TextColor3 = COLORS[props.color],
	})
end

return TextBox
