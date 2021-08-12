local rootWorkspace = script.Parent.Parent.Parent.Parent

local roact = rootWorkspace.PerformanceBenchmarks.benchmarks.implementations.roact

return function(Roact, ReactRoblox)
	local Box = require(roact.Box)(Roact, ReactRoblox)
	local Dot = require(roact.Dot)(Roact, ReactRoblox)
	local Provider = require(roact.Provider)(Roact, ReactRoblox)
	local TextBox = require(roact.TextBox)(Roact, ReactRoblox)

	return {
		Box = Box,
		Dot = Dot,
		Provider = Provider,
		TextBox = TextBox,
	}
end
