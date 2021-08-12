local rootWorkspace = script.Parent.BenchmarksExamplesCI
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Dev.Roact)
local ReactRoblox = require(Packages.Dev.ReactRoblox)

local SierpinskiTriangle = require(Packages.PerformanceBenchmarks.benchmarks.cases.SierpinskiTriangle)(
	Roact,
	ReactRoblox
)
local TestUtils = require(Packages.PerformanceBenchmarks.benchmarks.testUtils)(Roact, ReactRoblox)
local benchmark = require(Packages.PerformanceBenchmarks.benchmark)(Roact, ReactRoblox)

benchmark({
	benchmarkName = "Update dynamic styles",
	timeout = 20000,
	testBlock = TestUtils.createTestBlock(function(components)
		return {
			benchmarkType = "update",
			Component = SierpinskiTriangle.SierpinskiTriangle,
			getComponentProps = function(props)
				return {
					components = components,
					s = 200,
					renderCount = props.cycle,
					sampleCount = props.sampleCount,
					x = 0,
					y = 0,
				}
			end,
			Provider = components.Provider,
			sampleCount = 50,
			anchorPoint = Vector2.new(0, 0),
		}
	end),
})
