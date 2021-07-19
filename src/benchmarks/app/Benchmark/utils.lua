-- ROBLOX deviation: there isn't a built-in way to create a prefilled array in
-- lua. This isn't an ideal and performant implementation but it maps best to
-- what the code expects.
local createTable = function(length)
	local newTable = {}
	for i = 1, length do
		table.insert(newTable, nil)
	end
	return newTable
end

return { createTable = createTable }
