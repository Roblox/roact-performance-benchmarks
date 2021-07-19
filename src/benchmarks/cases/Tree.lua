-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

return function(Roact, ReactRoblox)
	local Tree = Roact.Component:extend("Tree")

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

		local children
		if depth == 0 then
			local fixedBox = Roact.createElement(Box, {
				name = "id = " .. id .. ", depth = " .. depth .. ", #children = 0",
				color = (id % 3) + 3,
				automaticSize = false,
				usePadding = false,
			})
			children = { fixedBox }
		else
			-- ROBLOX deviation: can't use Array.from() as upstream relies on
			-- duck typing of "length" property to expand an object into an
			-- array the size of "length". Lua doesn't use the "length" property
			-- for obtaining array length so this can't be mimicked.

			children = {}
			for i = 1, breadth do
				local tree = Roact.createElement(Tree, {
					breadth = breadth,
					components = components,
					depth = depth - 1,
					wrap = wrap,
					id = i - 1,
				})
				table.insert(children, tree)
			end
		end

		local result = Roact.createElement(Box, {
			name = "id = " .. id .. ", depth = " .. depth .. ", #children = " .. #children,
			color = id % 3,
			automaticSize = true,
			usePadding = true,
			layout = layout,
		}, children)

		for i = 1, wrap do
			result = Roact.createElement(Box, {
				name = "wrap = " .. i,
				automaticSize = true,
				usePadding = false,
				color = -1,
			}, {
				result,
			})
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
end
