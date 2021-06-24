return function()
	local testWorkspace = script.Parent.Parent
	local srcWorkspace = testWorkspace.Parent
	local rootWorkspace = srcWorkspace.Parent
	local PackagesWorkspace = rootWorkspace.Packages

	local JestRoblox = require(PackagesWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	local LuauPolyfill = require(PackagesWorkspace.LuauPolyfill)
	local Array = LuauPolyfill.Array

	local Concurrent = require(testWorkspace.concurrent).Concurrent
	local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)

	describe("Concurrent example tests", function()
		local rootInstance
		local stop

		beforeEach(function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"

			stop = bootstrapSync(rootInstance, Concurrent)
		end)

		afterEach(function()
			stop()
		end)

		it("should render Blocks", function()
			local descendants = rootInstance:GetDescendants()
			local count = #Array.filter(descendants, function(item)
				return item.Name == "Block"
			end)

			jestExpect(count).toBe(600)
		end)

		it("should render Boxes", function()
			local descendants = rootInstance:GetDescendants()
			local count = #Array.filter(descendants, function(item)
				return item.Name == "Box"
			end)

			jestExpect(count).toBe(1000)
		end)
	end)
end
