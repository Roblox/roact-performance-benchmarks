local testWorkspace = script.Parent.Parent
local srcWorkspace = testWorkspace.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

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
