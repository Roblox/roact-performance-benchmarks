local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Roact = require(game.ReplicatedStorage.Roact)

local DivLike = function(props)
	return Roact.createElement("Folder", { Name = "Div" }, props.children)
end

local stop

local App = function()
	local count, setCount = Roact.useState(0)

	local buttonActivated = function()
		setCount(count + 1)
		print("activated")
	end

	return Roact.createElement(
		"ScreenGui",
		nil,
		Roact.createElement(DivLike, nil, {
			Roact.createElement("TextButton", {
				Size = UDim2.new(0, 200, 0, 100),
				Position = UDim2.new(1, 0, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = "Stop",
				[Roact.Event.Activated] = stop,
			}),
			Roact.createElement("TextButton", {
				Size = UDim2.new(0, 200, 0, 100),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Text = "Toggle " .. tostring(count),
				[Roact.Event.Activated] = buttonActivated,
			}),
			count % 2 == 0 and Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 400, 0, 300),
				Position = UDim2.new(0.25, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "Hello, Roact1!",
			}) or Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 400, 0, 300),
				Position = UDim2.new(0.75, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "Hello, Roact2!",
			}),
		})
	)
end

local function bootstrap(component)
	local rootInstance = Instance.new("Folder")
	rootInstance.Name = "GuiRoot"
	rootInstance.Parent = PlayerGui

	local root = Roact.createBlockingRoot(rootInstance)
	root:render(Roact.createElement(component))

	return function ()
		root:unmount()
		rootInstance.Parent = nil
	end
end

stop = bootstrap(App)
