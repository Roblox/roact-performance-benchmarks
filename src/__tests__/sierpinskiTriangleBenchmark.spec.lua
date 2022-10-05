return function()
	local testWorkspace = script.Parent.Parent
	local rootWorkspace = testWorkspace.Parent

	local Roact = require(rootWorkspace.Dev.Roact)
	local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
	local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local sierpinskiTriangleBenchmark = require(testWorkspace.sierpinskiTriangleBenchmark)(Roact, ReactRoblox)

	describe("sierpinski triangle benchmark tests", function()
		it("should run the benchmark and return calculated stats", function()
			local sampleCount = 2
			local benchmarkStats = sierpinskiTriangleBenchmark({
				sampleCount = sampleCount,
				useLegacyRoot = true,
				disableRenderStep = true,
			}).results

			jestExpect(benchmarkStats).toBeDefined()
			jestExpect(benchmarkStats.min).toBeGreaterThan(0)
			jestExpect(benchmarkStats.min).toBeLessThan(math.huge)
			jestExpect(benchmarkStats.max).toBeGreaterThan(0)
			jestExpect(benchmarkStats.stdDev).toBeGreaterThanOrEqual(0)
			jestExpect(#benchmarkStats.samples).toBe(sampleCount)
		end)
	end)
end
