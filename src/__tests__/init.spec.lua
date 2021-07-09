return function()
	local rootWorkspace = script.Parent.Parent.Parent

	local JestRoblox = require(rootWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	describe("initial describe", function()
		it("empty test", function()
			jestExpect("").toBe("")
		end)
	end)
end
