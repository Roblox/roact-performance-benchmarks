return function(Roact, ReactRoblox)
	return function()
		local srcWorkspace = script.Parent

		local Utils = require(srcWorkspace.benchmarks.utils)(Roact, ReactRoblox)
		local benchmark = require(srcWorkspace.benchmark)(Roact, ReactRoblox)
		local SierpinskiTriangle = require(srcWorkspace.benchmarks.cases.SierpinskiTriangle)(Roact, ReactRoblox)

		benchmark({
			benchmarkName = "SierpinskiTriangle",
			timeout = 20000,
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
					sampleCount = 50,
					anchorPoint = Vector2.new(0, 0),
				}
			end),
		})
	end
end
