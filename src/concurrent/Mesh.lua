local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Roact = require(Packages.Roact)
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

function Mesh(props)
	return Roact.createElement("TextLabel", Object.assign({}, props, { Text = "Mesh mock" }))
end

return Mesh
