return function()
	local rootWorkspace = script.Parent.Parent.Parent
	local PackagesWorkspace = rootWorkspace.Packages

	local JestRoblox = require(PackagesWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	describe("initial describe", function()
		it("empty test", function()
			jestExpect("").toBe("")
		end)
	end)
end
