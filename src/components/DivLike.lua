return function(Roact)
	local DivLike = function(props)
		return Roact.createElement("Folder", { Name = "Div" }, props.children)
	end

	return DivLike
end
