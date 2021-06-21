local root = script.Parent.Parent
local PackagesWorkspace = root.Parent.Packages
local LuauPolyfill = require(PackagesWorkspace.LuauPolyfill)
local Array = LuauPolyfill.Array
local Object = LuauPolyfill.Object

return Object.assign({}, Array, {
	create = require(script.create),
})
