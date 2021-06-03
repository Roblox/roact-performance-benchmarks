local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)

-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local function Tree(props)
	local breadth, components, depth, id, wrap = props.breadth, props.components, props.depth, props.id, props.wrap
	local Box = components.Box

	-- ROBLOX deviation: ternary isn't supported.
	local layout
	if depth % 2 == 0 then
		layout = "column"
	else
		layout = "row"
	end

	local content
	if depth == 0 then
		content = { Roact.createElement(Box, { color = (id % 3) + 3, fixed = true }) }
	else
		-- ROBLOX deviation: can't use Array.from() as upstream relies on duck
		-- typing of "length" property to expand an object into an array the
		-- size of "length". Lua doesn't use the "length" property for
		-- obtaining array length so this can't be mimicked.
		content = {}
		for i = 1, breadth do
			table.insert(
				content,
				Roact.createElement(Tree, {
					breadth = breadth,
					components = components,
					depth = depth - 1,
					id = i,
					key = i,
					wrap = wrap,
				})
			)
		end
	end

	local result = Roact.createElement(Box, { color = id % 3, layout = layout, outer = true }, content)
	for i = 1, wrap do
		result = Roact.createElement(Box, nil, { result })
	end
	return result
end

-- ROBLOX deviation: we use function components and move static props to
-- exports so they're accessible.
return {
	Tree = Tree,
	displayName = "Tree",
	benchmarkType = BenchmarkType.MOUNT,
}
