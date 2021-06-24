local rootWorkspace = game:GetService("ReplicatedStorage")
local Packages = rootWorkspace.Packages
local Benchmarks = rootWorkspace.Src.benchmarks

local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local Array = LuauPolyfill.Array
local Roact = require(Packages.Roact)

local impl = require(Benchmarks.impl)
local App = require(Benchmarks.app)
local Tree = require(Benchmarks.cases.Tree)

local implementations = impl
local packageNames = Object.keys(implementations)

local function createTestBlock(fn)
	return Array.reduce(packageNames, function(testSetups, packageName)
		local implementation = implementations[packageName]
		local name, components, version = implementation.name, implementation.components, implementation.version

		local componentInfo = fn(components)
		local Component, getComponentProps, sampleCount, Provider, benchmarkType = componentInfo.Component,
			componentInfo.getComponentProps,
			componentInfo.sampleCount,
			componentInfo.Provider,
			componentInfo.benchmarkType

		testSetups[packageName] = {
			Component = Component,
			getComponentProps = getComponentProps,
			sampleCount = sampleCount,
			Provider = Provider,
			benchmarkType = benchmarkType,
			version = version,
			name = name,
		}
		return testSetups
	end, {})
end

local tests = {
	["Mount deep tree"] = createTestBlock(function(components)
		return {
			benchmarkType = "mount",
			Component = Tree.Tree,
			getComponentProps = function()
				return { breadth = 2, components = components, depth = 7, id = 0, wrap = 1 }
			end,
			Provider = components.Provider,
			sampleCount = 50,
		}
	end),
	-- ["Mount wide tree"] = createTestBlock(function(components)
	-- 	return {
	-- 		benchmarkType = "mount",
	-- 		Component = Tree.Tree,
	-- 		getComponentProps = function()
	-- 			return { breadth = 6, components = components, depth = 3, id = 0, wrap = 2 }
	-- 		end,
	-- 		Provider = components.Provider,
	-- 		sampleCount = 50,
	-- 	}
	-- end),
	-- ["Update dynamic styles"] = createTestBlock(function(components)
	-- 	return {
	-- 		benchmarkType = "update",
	-- 		Component = SierpinskiTriangle.SierpinskiTriangle,
	-- 		getComponentProps = function(props)
	-- 			return { components = components, s = 200, renderCount = props.cycle, x = 0, y = 0 }
	-- 		end,
	-- 		Provider = components.Provider,
	-- 		sampleCount = 50,
	-- 	}
	-- end),
	-- ["Mount text tree"] = createTestBlock(function(components)
	-- 	return {
	-- 		benchmarkType = "mount",
	-- 		Component = TextTree.TextTree,
	-- 		getComponentProps = function()
	-- 			return { breadth = 6, components = components, depth = 3, id = 0, wrap = 2 }
	-- 		end,
	-- 		Provider = components.Provider,
	-- 		sampleCount = 50,
	-- 	}
	-- end),
}

-- ROBLOX deviation: return an element instead of rendering here so bootstrap
-- code needed to connect to engine can reside elsewhere.
return function(props)
	return Roact.createElement("ScreenGui", nil, Roact.createElement(App, { tests = tests }))
end
