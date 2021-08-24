local Benchmarks = script.Parent.benchmarks

-- ROBLOX deviation: return an element instead of rendering here so bootstrap
-- code needed to connect to engine can reside elsewhere.
return function(Roact, ReactRoblox)
	local Utils = require(Benchmarks.utils)(Roact, ReactRoblox)
	local App = require(Benchmarks.app)(Roact, ReactRoblox)
	local Tree = require(Benchmarks.cases.Tree)(Roact, ReactRoblox)
	local SierpinskiTriangle = require(Benchmarks.cases.SierpinskiTriangle)(Roact, ReactRoblox)

	local tests = {
		["Mount deep tree"] = Utils.createTestBlock(function(components)
			return {
				benchmarkType = "mount",
				Component = Tree.Tree,
				getComponentProps = function()
					return { breadth = 2, components = components, depth = 7, id = 0, wrap = 1 }
				end,
				Provider = components.Provider,
				sampleCount = 50,
				anchorPoint = Vector2.new(0.5, 0.5),
			}
		end),
		["Mount wide tree"] = Utils.createTestBlock(function(components)
			return {
				benchmarkType = "mount",
				Component = Tree.Tree,
				getComponentProps = function()
					return { breadth = 6, components = components, depth = 3, id = 0, wrap = 2 }
				end,
				Provider = components.Provider,
				sampleCount = 50,
				anchorPoint = Vector2.new(0.5, 0.5),
			}
		end),
		["Update dynamic styles"] = Utils.createTestBlock(function(components)
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
		-- ["Mount text tree"] = Utils.createTestBlock(function(components)
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
