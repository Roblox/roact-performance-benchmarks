local rootWorkspace = script.Parent.BenchmarkExamplesCI.Packages
local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local Scheduler = require(rootWorkspace.Dev.Scheduler)

require(rootWorkspace.PerformanceBenchmarks.firstRenderBenchmark)(Roact, ReactRoblox, Scheduler)({
	minSamples = 200,
})
