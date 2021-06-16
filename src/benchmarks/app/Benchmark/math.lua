local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

type ValuesType = Array<number>

local getMean = function(values: ValuesType): number
	local sum = Array.reduce(values, function(sum: number, value: number)
		return sum + value
	end, 0)
	return sum / #values
end

local getStdDev = function(values: ValuesType): number
	local avg = getMean(values)

	local squareDiffs = Array.map(values, function(value: number)
		local diff = value - avg
		return diff * diff
	end)

	return math.sqrt(getMean(squareDiffs))
end

local getMedian = function(values: ValuesType): number
	if #values == 1 then
		return values[1]
	end

	local numbers = Array.sort(values, function(a: number, b: number)
		return a - b
	end)
	return (numbers[bit32.rshift(#numbers - 1, 1) + 1] + numbers[bit32.rshift(#numbers, 1) + 1]) / 2
end

return {
	getStdDev = getStdDev,
	getMean = getMean,
	getMedian = getMedian,
}
