return function()
	local testWorkspace = script.Parent.Parent
	local srcWorkspace = testWorkspace.Parent.Parent
	local rootWorkspace = srcWorkspace.Parent

	local Roact = require(rootWorkspace.Dev.Roact)
	local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)

	local App = require(testWorkspace)(Roact, ReactRoblox)
	local Utils = require(srcWorkspace.benchmarks.utils)(Roact, ReactRoblox)
	local Tree = require(srcWorkspace.benchmarks.cases.Tree)(Roact, ReactRoblox)
	local SierpinskiTriangle = require(srcWorkspace.benchmarks.cases.SierpinskiTriangle)(Roact, ReactRoblox)
	local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)(Roact, ReactRoblox)

	describe("benchmark app tests", function()
		local stop

		afterEach(function()
			if stop then
				stop()
				stop = nil
			end
		end)

		it("should render", function()
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
			}

			local rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
			stop = bootstrapSync(rootInstance, App, { tests = tests })
		end)
	end)
end
