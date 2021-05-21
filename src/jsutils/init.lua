local rootWorkspace = script.Parent.Parent
local Packages = rootWorkspace.Packages
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object

local makeIntervalImpl = require(script.makeIntervalImpl)


return Object.assign(
    {},
    makeIntervalImpl(delay)
)