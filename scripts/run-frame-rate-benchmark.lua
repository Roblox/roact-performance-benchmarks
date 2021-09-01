local rootWorkspace = script.Parent.BenchmarksExamplesCI.Packages
local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local Scheduler = require(rootWorkspace.Dev.Scheduler)

local config = {
	minSamples = 600,
}
if _G.minSamples ~= nil then
	config.minSamples = tonumber(_G.minSamples)
end

require(rootWorkspace.PerformanceBenchmarks.frameRateBenchmark)(Roact, ReactRoblox, Scheduler)(config)
