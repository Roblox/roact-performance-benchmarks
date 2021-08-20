local rootWorkspace = script.Parent.BenchmarksExamplesCI.Packages

local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)

require(rootWorkspace.PerformanceBenchmarks).sierpinskiTriangleBenchmark(Roact, ReactRoblox)()
