local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Benchmarks = Packages.PerformanceBenchmarks.benchmarks

-- ROBLOX deviation: return an element instead of rendering here so bootstrap
-- code needed to connect to engine can reside elsewhere.
return function(Roact, ReactRoblox)
	local TestUtils = require(Benchmarks.testUtils)(Roact, ReactRoblox)
	local App = require(Benchmarks.app)(Roact, ReactRoblox)
	local Tree = require(Benchmarks.cases.Tree)(Roact, ReactRoblox)

	local tests = {
		["Mount deep tree"] = TestUtils.createTestBlock(function(components)
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
		["Mount wide tree"] = TestUtils.createTestBlock(function(components)
			return {
				benchmarkType = "mount",
				Component = Tree.Tree,
				getComponentProps = function()
					return { breadth = 6, components = components, depth = 3, id = 0, wrap = 2 }
				end,
				Provider = components.Provider,
				sampleCount = 50,
			}
		end),
		-- ["Update dynamic styles"] = TestUtils.createTestBlock(function(components)
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
		-- ["Mount text tree"] = TestUtils.createTestBlock(function(components)
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

	return function(props)
		return Roact.createElement(
			"ScreenGui",
			{ IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling },
			Roact.createElement(App, { tests = tests })
		)
	end
end
