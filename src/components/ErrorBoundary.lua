return function(Roact, ReactRoblox)
	local ErrorBoundary = Roact.Component:extend("ErrorBoundary")

	ErrorBoundary.displayName = "ErrorBoundary"

	function ErrorBoundary:componentDidCatch(error, info)
		local onError = self.props.onError
		if onError then
			onError(error, info)
		end
	end

	function ErrorBoundary:render()
		return self.props.children
	end

	return ErrorBoundary
end
