local rootWorkspace = script.Parent.BenchmarksExamplesCI.Packages

local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)

local config = {}
if _G.minSamples ~= nil then
	config.sampleCount = tonumber(_G.minSamples)
end

require(rootWorkspace.PerformanceBenchmarks).deepTreeBenchmark(Roact, ReactRoblox)(config)
