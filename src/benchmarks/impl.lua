local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

local roact = require(script.Parent.implementations.roact)

-- ROBLOX deviation: packages to test aren't pulled from a config file.
local dependencies = { roact = roact }

type ComponentsType = { [string]: any }

type ImplementationType = {
	components: ComponentsType,
	name: string,
	version: string,
}

return function(Roact, ReactRoblox)
	local toImplementations = function(deps): { ImplementationType }
		return Array.map(Object.keys(deps), function(dependency: string)
			local implementation = deps[dependency](Roact, ReactRoblox)
			local components = {
				Box = implementation.Box,
				Dot = implementation.Dot,
				Provider = implementation.Provider,
				TextBox = implementation.TextBox,
			}
			local name = dependency
			local libraryVersion = "?"
			return { components = components, name = name, version = libraryVersion }
		end)
	end

	local toObject = function(impls)
		return Array.reduce(impls, function(acc, impl)
			acc[impl.name] = impl
			return acc
		end, {})
	end

	-- ROBLOX deviation: require.context doesn't exist to my knowledge. We just
	-- hardcode the implementations for the benchmark.
	return toObject(toImplementations(dependencies))
end
