return function(Roact, ReactRoblox)
	local function Dot(props)
		local children, color, size, x, y = props.children, props.color, props.size, props.x, props.y

		return Roact.createElement("ImageLabel", {
			Image = "rbxassetid://7092148155",
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0, x, 0, y),
			Size = UDim2.new(0, size, 0, size / 2),
			BorderColor3 = nil,
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			ImageColor3 = color,
		}, children)
	end

	return Dot
end
