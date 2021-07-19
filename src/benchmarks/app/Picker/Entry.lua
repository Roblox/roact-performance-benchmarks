return function(Roact, ReactRoblox)
	local function Entry(props)
		return Roact.createElement("TextButton", {
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = props.LayoutOrder,
			Text = props.Text,
			BackgroundTransparency = 0.0,
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			Font = Enum.Font.SourceSans,
			TextSize = 18,

			[ReactRoblox.Event.MouseButton1Click] = function(rbx)
				if props.OnSelect ~= nil then
					props.OnSelect(rbx)
				end
			end,
		})
	end

	return Entry
end
