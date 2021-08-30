return function()
	local testWorkspace = script.Parent.Parent
	local rootWorkspace = testWorkspace.Parent

	local Roact = require(rootWorkspace.Dev.Roact)
	local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
	local Scheduler = require(rootWorkspace.Dev.Scheduler)
	local JestRoblox = require(rootWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	local firstRenderBenchmark = require(testWorkspace.firstRenderBenchmark)(Roact, ReactRoblox, Scheduler)

	describe("first render benchmark tests", function()
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
	end)
end
