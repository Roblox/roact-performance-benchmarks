export type Config = {
	sampleCount: number?,
	timeout: number?,
	useLegacyRoot: boolean?,
	disableRenderStep: boolean?,
}

return function(Roact, ReactRoblox)
	return function(config_: Config?)
		local srcWorkspace = script.Parent
		local rootWorkspace = srcWorkspace.Parent

		local Object = require(rootWorkspace.LuauPolyfill).Object
		local Utils = require(srcWorkspace.benchmarks.utils)(Roact, ReactRoblox)
		local benchmark = require(srcWorkspace.benchmark)(Roact, ReactRoblox)
		local Tree = require(srcWorkspace.benchmarks.cases.Tree)(Roact, ReactRoblox)

		local defaultConfig = {
			sampleCount = 50,
			timeout = 20000,
			useLegacyRoot = false,
			disableRenderStep = false,
		}
		local config = Object.assign({}, defaultConfig, config_)

		return benchmark({
			benchmarkName = "MountWideTree",
			timeout = config.timeout,
			useLegacyRoot = config.useLegacyRoot,
			disableRenderStep = config.disableRenderStep,
			testBlock = Utils.createTestBlock(function(components)
				return {
					benchmarkType = "mount",
					Component = Tree.Tree,
					getComponentProps = function()
						return { breadth = 6, components = components, depth = 3, id = 0, wrap = 2 }
					end,
					Provider = components.Provider,
					sampleCount = config.sampleCount,
				}
			end),
		})
	end
end
