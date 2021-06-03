local rootWorkspace = script.Parent.Parent
local Packages = rootWorkspace.Packages
local Implementations = rootWorkspace.Benchmarks.implementations

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array

-- ROBLOX deviation: packages to test aren't pulled from a config file.
local dependencies = {
	roact = Implementations.roact,
}

type ComponentsType = { [string]: any }

type ImplementationType = {
	components: ComponentsType,
	name: String,
	version: String,
}

local toImplementations = function(dependencies): Array<ImplementationType>
	return Array.map(Object.keys(dependencies), function(dependency)
		local implementation = dependencies[dependency]
		local components = {
			require(implementation.Box),
			require(implementation.Dot),
			require(implementation.Provider),
			require(implementation.TextBox),
		}
		local name = dependency
		local version = "?"
		return { components = components, name = name, version = version }
	end)
end

local toObject = function(impls: Array<ImplementationType>)
	return Array.reduce(impls, function(acc, impl)
		acc[impl.name] = impl
		return acc
	end, {})
end

-- ROBLOX deviation: require.context doesn't exist to my knowledge. We just
-- hardcode the implementations for the benchmark.
return toObject(toImplementations(dependencies))
