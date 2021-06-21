local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)

-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local Tree = Roact.Component:extend("Benchmark")

function Tree:render()
	local breadth, components, depth, id, wrap =
		self.props.breadth, self.props.components, self.props.depth, self.props.id, self.props.wrap
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
		content = {
			Roact.createElement(Box, {
				depth = depth,
				color = (id % 3) + 3,
				fixed = true,
			}),
		}
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
					id = i - 1,
					key = i - 1,
					wrap = wrap,
				})
			)
		end
	end

	local result = Roact.createElement(Box, {
		Name = "Outer",
		depth = depth,
		color = id % 3,
		layout = layout,
		outer = true,
	}, content)
	for i = 1, (wrap + 1) do
		result = Roact.createElement(Box, {
			Name = "Box",
			index = i,
			depth = depth,
		}, { result })
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
