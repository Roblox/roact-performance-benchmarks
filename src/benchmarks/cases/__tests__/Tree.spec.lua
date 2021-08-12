return function()
	local testWorkspace = script.Parent.Parent
	local srcWorkspace = testWorkspace.Parent.Parent
	local rootWorkspace = srcWorkspace.Parent

	local Roact = require(rootWorkspace.Dev.Roact)
	local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
	local JestRoblox = require(rootWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect
	local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
	local Array = LuauPolyfill.Array
	local String = LuauPolyfill.String

	local Tree = require(testWorkspace.Tree)(Roact, ReactRoblox).Tree
	local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)(Roact, ReactRoblox)
	local components = require(srcWorkspace.benchmarks.implementations.roact)(Roact, ReactRoblox)

	describe("tree benchmark case tests (roact)", function()
		local stop

		afterEach(function()
			if stop then
				stop()
				stop = nil
			end
		end)

		it("should render with children matching configured breadth", function()
			local props = {
				breadth = 2,
				components = components,
				depth = 7,
				id = 0,
				wrap = 0,
			}

			local rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
			stop = bootstrapSync(rootInstance, Tree, props)

			local treeRoot = rootInstance:GetChildren()[1]
			local children = treeRoot:GetChildren()
			local count = #Array.filter(children, function(item)
				return String.startsWith(item.Name, "id = ")
			end)

			jestExpect(count).toBe(props.breadth)
		end)
	end)
end
