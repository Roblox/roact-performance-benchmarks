local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)

-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local Tree = Roact.Component:extend("Tree")

function Tree:init()
	self.state = { contentSize = UDim2.new(0, 0, 0, 0) }
end

function Tree:render()
	local anchorPoint, breadth, components, depth, id, wrap, onSizeUpdate = self.props.anchorPoint,
		self.props.breadth,
		self.props.components,
		self.props.depth,
		self.props.id,
		self.props.wrap,
		self.props.onSizeUpdate
	local Box = components.Box

	-- ROBLOX deviation: ternary isn't supported.
	local layout, xBreadth, yBreadth, xPaddingFudge, yPaddingFudge = nil, 1, 1, 0, 0
	if depth % 2 == 0 then
		layout = "column"
		if depth >= 1 then
			yBreadth = breadth
			yPaddingFudge = 4
		end
	else
		layout = "row"
		if depth >= 1 then
			xBreadth = breadth
			xPaddingFudge = 4
		end
	end

	local children
	if depth == 0 then
		local fixedBox = Roact.createElement(Box, {
			breadth = 1,
			name = "id = " .. id .. ", depth = " .. depth .. ", #children = 0",
			depth = depth,
			color = (id % 3) + 3,
			fixed = true,
			useGrid = true,
			onSizeUpdate = function(contentSize)
				self:setState({ contentSize = contentSize })
				if onSizeUpdate ~= nil then
					onSizeUpdate(contentSize)
				end
			end,
		})
		children = { fixedBox }
	else
		-- ROBLOX deviation: can't use Array.from() as upstream relies on duck
		-- typing of "length" property to expand an object into an array the
		-- size of "length". Lua doesn't use the "length" property for
		-- obtaining array length so this can't be mimicked.

		children = {}
		for i = 1, breadth do
			local tree = Roact.createElement(Tree, {
				breadth = breadth,
				components = components,
				depth = depth - 1,
				wrap = wrap,
				id = i - 1,
				onSizeUpdate = function(contentSize)
					local newContentSize = UDim2.new(
						contentSize.X.Scale,
						contentSize.X.Offset * xBreadth - (xPaddingFudge * xBreadth),
						contentSize.Y.Scale,
						contentSize.Y.Offset * yBreadth - (yPaddingFudge * yBreadth)
					)
					self:setState({ contentSize = newContentSize })
					if onSizeUpdate ~= nil then
						onSizeUpdate(newContentSize)
					end
				end,
			})
			table.insert(children, tree)
		end
	end

	local box = Roact.createElement(Box, {
		name = "id = " .. id .. ", depth = " .. depth .. ", #children = " .. #children,
		contentSize = self.state.contentSize,
		breadth = breadth,
		depth = depth,
		color = id % 3,
		layout = layout,
		outer = true,
		useGrid = id == 1,
		anchorPoint = anchorPoint,
		onSizeUpdate = function(contentSize)
			if onSizeUpdate ~= nil then
				onSizeUpdate(contentSize)
			end
		end,
	}, children)

	return box
end

-- ROBLOX deviation: we use function components and move static props to
-- exports so they're accessible.
return {
	Tree = Tree,
	displayName = "Tree",
	benchmarkType = BenchmarkType.MOUNT,
}
