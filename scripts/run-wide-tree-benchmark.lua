local rootWorkspace = script.Parent.BenchmarksExamplesCI
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Dev.Roact)
local ReactRoblox = require(Packages.Dev.ReactRoblox)

local Tree = require(Packages.PerformanceBenchmarks.benchmarks.cases.Tree)(Roact, ReactRoblox)
local Utils = require(Packages.PerformanceBenchmarks.benchmarks.utils)(Roact, ReactRoblox)
local benchmark = require(Packages.PerformanceBenchmarks.benchmark)(Roact, ReactRoblox)

benchmark({
	benchmarkName = "Mount wide tree",
	timeout = 20000,
	testBlock = Utils.createTestBlock(function(components)
		return {
			benchmarkType = "mount",
			Component = Tree.Tree,
			getComponentProps = function()
				return { breadth = 6, components = components, depth = 3, id = 0, wrap = 2 }
			end,
			Provider = components.Provider,
			sampleCount = 50,
		}
	end),
})
