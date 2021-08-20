return function(Roact, ReactRoblox)
	return function()
		local srcWorkspace = script.Parent

		local Utils = require(srcWorkspace.benchmarks.utils)(Roact, ReactRoblox)
		local benchmark = require(srcWorkspace.benchmark)(Roact, ReactRoblox)
		local Tree = require(srcWorkspace.benchmarks.cases.Tree)(Roact, ReactRoblox)

		benchmark({
			benchmarkName = "MountWideTree",
			timeout = 20000,
			testBlock = Utils.createTestBlock(function(components)
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
		})
	end
end
