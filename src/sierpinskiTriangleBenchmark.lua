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
		local SierpinskiTriangle = require(srcWorkspace.benchmarks.cases.SierpinskiTriangle)(Roact, ReactRoblox)

		local defaultConfig = {
			sampleCount = 50,
			timeout = 20000,
			useLegacyRoot = false,
			disableRenderStep = false,
		}
		local config = Object.assign({}, defaultConfig, config_)

		return benchmark({
			benchmarkName = "SierpinskiTriangle",
			timeout = config.timeout,
			useLegacyRoot = config.useLegacyRoot,
			disableRenderStep = config.disableRenderStep,
			testBlock = Utils.createTestBlock(function(components)
				return {
					benchmarkType = "update",
					Component = SierpinskiTriangle.SierpinskiTriangle,
					getComponentProps = function(props)
						return {
							components = components,
							s = 200,
							renderCount = props.cycle,
							sampleCount = props.sampleCount,
							x = 0,
							y = 0,
						}
					end,
					Provider = components.Provider,
					sampleCount = config.sampleCount,
					anchorPoint = Vector2.new(0, 0),
				}
			end),
		})
	end
end
