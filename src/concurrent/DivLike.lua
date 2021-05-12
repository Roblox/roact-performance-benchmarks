local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Roact = require(Packages.Roact)

local DivLike = function(props)
	return Roact.createElement("Folder", { Name = "Div" }, props.children)
end

return {
	DivLike = DivLike,
}
