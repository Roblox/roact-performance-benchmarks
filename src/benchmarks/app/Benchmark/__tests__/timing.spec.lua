return function()
	local testWorkspace = script.Parent.Parent
	local srcWorkspace = testWorkspace.Parent.Parent.Parent
	local rootWorkspace = srcWorkspace.Parent

	local JestRoblox = require(rootWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	local Timing = require(testWorkspace.timing)

	describe("timing tests", function()
		it("should always return a higher value for each invocation", function()
			local lastNow = 0
			for i = 0, 1000 do
				local currentNow = Timing.now()
				jestExpect(currentNow).toBeGreaterThan(lastNow)
				lastNow = currentNow
			end
		end)
	end)
end
