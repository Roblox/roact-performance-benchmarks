local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = require(LuauPolyfill.Array)

-- ROBLOX deviation: removed some javascript-isms like ORing a double to floor
-- it and pre-allocating arrays.
return function(specifier)
	local n = math.floor(#specifier / 6)
	local colors = {}
	local i = 0

	while i < n do
		colors[i + 1] = "#" + Array.slice(specifier, i * 6, (i + 1) * 6)
		i += 1
	end

	return colors
end
