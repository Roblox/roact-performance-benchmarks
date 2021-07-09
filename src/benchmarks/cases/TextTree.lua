local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Dev.Roact)

-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local function TextTree(props)
	local breadth, components, depth, id, wrap = props.breadth, props.components, props.depth, props.id, props.wrap
	local TextBox = components.TextBox

	local content
	if depth == 0 then
		content = { Roact.createElement(TextBox, { children = "Depth 0", color = (id % 3) + 3 }) }
	else
		-- ROBLOX deviation: can't use Array.from() as upstream relies on duck
		-- typing of "length" property to expand an object into an array the
		-- size of "length". Lua doesn't use the "length" property for
		-- obtaining array length so this can't be mimicked.
		content = {}
		for i = 1, breadth, 1 do
			table.insert(
				content,
				Roact.createElement(TextTree, {
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

	local result = Roact.createElement(
		TextBox,
		{ children = "TextBox " .. id % 3, color = id % 3, outer = true },
		content
	)
	for i = 1, wrap, 1 do
		result = Roact.createElement(TextBox, nil, { result })
	end
	return result
end

-- ROBLOX deviation: we use function components and move static props to
-- exports so they're accessible.
return {
	TextTree = TextTree,
	displayName = "TextTree",
	benchmarkType = BenchmarkType.MOUNT,
}
