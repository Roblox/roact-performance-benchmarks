local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Dev.Roact)
local ReactRoblox = require(Packages.Dev.ReactRoblox)

local Picker = Roact.Component:extend("Picker")

function Picker:render()
	local props = self.props

	local children = {}
	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 1),
	})
	for i = 1, #(props.children or {}) do
		children[#children + 1] = props.children[i]
	end

	local borderColor = Color3.fromRGB(200, 200, 200)
	return Roact.createElement("ImageButton", {
		AnchorPoint = props.AnchorPoint,
		Position = props.Position,
		BackgroundTransparency = 1.0,
		Size = UDim2.new(0, 16, 0, 16),
		Image = "http://www.roblox.com/asset/?id=1083248618",

		[ReactRoblox.Event.Activated] = function(rbx)
			self:setState({
				open = not self.state.open,
			})
		end,
	}, {
		InputCapture = Roact.createElement("ImageButton", {
			Position = UDim2.new(0, -5000, 0, -5000),
			Size = UDim2.new(1, 10000, 1, 10000),
			BackgroundTransparency = 1.0,
			Visible = self.state.open,

			[ReactRoblox.Event.Activated] = function(rbx)
				self:setState({
					open = false,
				})
			end,
		}, {
			UIPadding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 5000),
				PaddingRight = UDim.new(0, 5000),
				PaddingTop = UDim.new(0, 5000),
				PaddingBottom = UDim.new(0, 5000),
			}),
			Menu = Roact.createElement("Frame", {
				Position = UDim2.new(1, 0, 1, 0),
				AnchorPoint = Vector2.new(1, 0),
				Size = UDim2.new(0, 150, 0, #children * 21 - 1),
				BackgroundColor3 = borderColor,
				BorderColor3 = borderColor,
				ClipsDescendants = true,
			}, children),
		}),
	})
end

function Picker:init()
	self.state = {
		open = false,
	}
end

return Picker
