local PackagesWorkspace = script.Parent.Parent.Packages
local Array = require(PackagesWorkspace.LuauPolyfill).Array

function calculateStats(data: Array<number>)
	local mean = Array.reduce(data, function(sum, a) 
        return sum + a
    end, 0) / #data

    local variance = math.sqrt(Array.reduce(data, function(sum, x)
        local d = x - mean
        local d2 = d * d
        return sum + d2
    end, 0) / #data)

	return {
		min = math.min(math.huge, table.unpack(data)),
		max = math.max(0, table.unpack(data)),
		mean = mean,
		variance = variance,
	}
end

return calculateStats
