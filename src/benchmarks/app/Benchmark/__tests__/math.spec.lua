local testWorkspace = script.Parent.Parent
local srcWorkspace = testWorkspace.Parent.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local Math = require(testWorkspace.math)

describe("math tests", function()
	local dataset = { 5, 6, 7, 8, 9, 10, 12, 13, 13, 13, 15, 15, 16, 16, 18, 22 }

	it("should calculate the mean of a list of values", function()
		jestExpect(Math.getMean(dataset)).toBe(12.375)
	end)

	it("should calculate the median of a list of values", function()
		jestExpect(Math.getMedian(dataset)).toBe(13)
	end)

	it("should find the median of a single value list", function()
		jestExpect(Math.getMedian({ 1 })).toBe(1)
	end)

	it("should find the standard deviation of a list of samples", function()
		local stdDev = tonumber(string.format("%.12f", Math.getStdDev(dataset)))
		jestExpect(stdDev).toBe(4.512136411945)
	end)
end)
