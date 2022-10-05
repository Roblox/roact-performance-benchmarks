return function()
	local rootWorkspace = script.Parent.Parent.Parent

	local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
	local Array = LuauPolyfill.Array

	local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
	local jestExpect = JestGlobals.expect

	local calculateStats = require(script.Parent.Parent.calculateStats)

	describe("calculateStats", function()
		it("should calculate empty stats", function()
			jestExpect(calculateStats({})).toEqual({
				min = math.huge,
				max = -math.huge,
				mean = 0,
				variance = 0,
				stdDev = 0,
				count = 0,
			})
		end)

		it("should calculate one element stats", function()
			Array.map({ 0, 1, 10, 50 }, function(v)
				jestExpect(calculateStats({ v })).toEqual({
					min = v,
					max = v,
					mean = v,
					variance = 0,
					stdDev = 0,
					count = 1,
				})
			end)
		end)

		it("should calculate multiple same elements element stats", function()
			Array.map({ 0, 1, 10, 50 }, function(v)
				jestExpect(calculateStats({ v, v, v })).toEqual({
					min = v,
					max = v,
					mean = v,
					variance = 0,
					stdDev = 0,
					count = 3,
				})
			end)
		end)

		it("should calculate stats for {1, 2, 3}", function()
			jestExpect(calculateStats({ 1, 2, 3 })).toEqual({
				min = 1,
				max = 3,
				mean = 2,
				variance = 1,
				stdDev = 1,
				count = 3,
			})
		end)

		it("should calculate stats {1..48}", function()
			local data = {}
			for i = 1, 48 do
				table.insert(data, i)
			end
			jestExpect(calculateStats(data)).toEqual({
				min = 1,
				max = 48,
				mean = 24.5,
				variance = 196,
				stdDev = 14,
				count = 48,
			})
		end)
	end)
end
