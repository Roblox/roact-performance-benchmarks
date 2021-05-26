return function(length, init)
	local arr = {}
	for _ = 1, length do
		table.insert(arr, init)
	end
	return arr
end
