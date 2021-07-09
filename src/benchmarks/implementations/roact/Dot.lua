local rootWorkspace = script.Parent.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Dev.Roact)

local function Dot(props)
	return Roact.createElement("Frame", {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 0, 0, 0),
		BorderColor3 = nil,
		BorderSizePixel = props.size / 2,
	}, props.children)
end

return Dot
