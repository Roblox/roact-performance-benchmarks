local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)

local function Frame(props)
	return Roact.createElement("Frame", props, props.children)
end

return Frame
