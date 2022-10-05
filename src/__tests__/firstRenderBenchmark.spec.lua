return function()
	local testWorkspace = script.Parent.Parent
	local rootWorkspace = testWorkspace.Parent

	local Roact = require(rootWorkspace.Dev.Roact)
	local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
	local Scheduler = require(rootWorkspace.Dev.Scheduler)
	local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local firstRenderBenchmark = require(testWorkspace.firstRenderBenchmark)(Roact, ReactRoblox, Scheduler)

	describe("first render benchmark tests", function()
		-- FIXME: This test is super noisy in dev because it doesn't use `act`,
		-- but the scheduler isn't mocked so it shouldn't need to anyways
		if not _G.__DEV__ then
			it("should run the benchmark and return calculated stats (2 samples)", function()
				local minSamples = 2
				local benchmarkStats = firstRenderBenchmark({ minSamples = minSamples, verbose = true })
				jestExpect(benchmarkStats.min).toBeGreaterThan(0)
				jestExpect(benchmarkStats.min).toBeLessThan(math.huge)
				jestExpect(benchmarkStats.max).toBeGreaterThan(0)
				jestExpect(benchmarkStats.variance).toBeGreaterThanOrEqual(0)
				jestExpect(benchmarkStats.stdDev).toBe(math.sqrt(benchmarkStats.variance))
				jestExpect(benchmarkStats.count).toBe(minSamples)
			end)
		end
	end)
end
