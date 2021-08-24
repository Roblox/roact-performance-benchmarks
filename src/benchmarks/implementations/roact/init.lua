return function(Roact, ReactRoblox)
	local Box = require(script.Box)(Roact, ReactRoblox)
	local Dot = require(script.Dot)(Roact, ReactRoblox)
	local Provider = require(script.Provider)(Roact, ReactRoblox)
	local TextBox = require(script.TextBox)(Roact, ReactRoblox)

	return {
		Box = Box,
		Dot = Dot,
		Provider = Provider,
		TextBox = TextBox,
	}
end
