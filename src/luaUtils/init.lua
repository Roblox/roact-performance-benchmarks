local rootWorkspace = script.Parent.Parent
local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Object = LuauPolyfill.Object

local makeIntervalImpl = require(script.makeIntervalImpl)

return Object.assign({
	Array = require(script.Array),
}, makeIntervalImpl(delay))
