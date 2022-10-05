return function()
	local rootWorkspace = script.Parent.Parent.Parent.Parent

	local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local formatBenchmark = require(script.Parent.Parent.formatBenchmark).formatBenchmark

	describe("formatBenchmark", function()
		it("should format simple benchmark", function()
			jestExpect(formatBenchmark({
				group = "TestGroup",
				name = "TestName",
				unit = "op/s",
				mean = 123.4567,
				stdDev = 5.67,
				samples = 345,
			})).toBe(
				"TestGroup#TestName x 123.4567 op/s ±5.67% (345 runs sampled)(roblox-cli version " .. version() .. ")"
			)
		end)

		it("should format numbers with correct precision", function()
			jestExpect(formatBenchmark({
				group = "TestGroup",
				name = "TestName",
				unit = "op/s",
				mean = 0.1,
				stdDev = 0.1,
				samples = 1,
			})).toBe(
				"TestGroup#TestName x 0.1000 op/s ±0.10% (1 runs sampled)(roblox-cli version " .. version() .. ")"
			)

			jestExpect(formatBenchmark({
				group = "TestGroup",
				name = "TestName",
				unit = "op/s",
				mean = 12.1,
				stdDev = 12.1,
				samples = 123,
			})).toBe(
				"TestGroup#TestName x 12.1000 op/s ±12.10% (123 runs sampled)(roblox-cli version " .. version() .. ")"
			)

			jestExpect(formatBenchmark({
				group = "TestGroup",
				name = "TestName",
				unit = "op/s",
				mean = 1234.1,
				stdDev = 1234.1,
				samples = 123456,
			})).toBe(
				"TestGroup#TestName x 1234.1000 op/s ±1234.10% (123456 runs sampled)(roblox-cli version "
					.. version()
					.. ")"
			)

			jestExpect(formatBenchmark({
				group = "TestGroup",
				name = "TestName",
				unit = "op/s",
				mean = 1234.123456,
				stdDev = 1234.123456,
				samples = 123456.123456,
			})).toBe(
				"TestGroup#TestName x 1234.1235 op/s ±1234.12% (123456 runs sampled)(roblox-cli version "
					.. version()
					.. ")"
			)
		end)
	end)
end
