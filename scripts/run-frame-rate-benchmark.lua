local rootWorkspace = script.Parent.BenchmarksExamplesCI.Packages
local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local Scheduler = require(rootWorkspace.Dev.Scheduler)

require(rootWorkspace.PerformanceBenchmarks.frameRateBenchmark)(Roact, ReactRoblox, Scheduler)({
	minSamples = 600,
})
