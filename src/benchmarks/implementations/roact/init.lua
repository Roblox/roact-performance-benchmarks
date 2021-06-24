local rootWorkspace = script.Parent.Parent.Parent
local roact = rootWorkspace.benchmarks.implementations.roact

local Box = require(roact.Box)
local Dot = require(roact.Dot)
local Provider = require(roact.Provider)
local TextBox = require(roact.TextBox)

return {
	Box = Box,
	Dot = Dot,
	Provider = Provider,
	TextBox = TextBox,
}
