local srcWorkspace = script.Parent

local Types = require(script.Parent.benchmarks.app.Benchmark.types)

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

type TestBlock = {
	Component: any, -- Should be a Roact component
	getComponentProps: ({ [any]: any }) -> { [any]: any },
	sampleCount: number,
	Provider: any, -- Should be a Roact component
	benchmarkType: string,
	version: string,
	name: string,
}

type TestConfig = {
	benchmarkName: string,
	timeout: number,
	testBlock: { [string]: TestBlock },
}

local LIBRARY_NAME = "roact"

return function(Roact, ReactRoblox)
	local useEffect = Roact.useEffect
	local useRef = Roact.useRef

	local bootstrap = require(srcWorkspace.bootstrap)(Roact, ReactRoblox)
	local Benchmark = require(srcWorkspace.benchmarks.app.Benchmark)(Roact, ReactRoblox)
	local formatBenchmark = require(srcWorkspace.utils.formatBenchmark).formatBenchmark

	return function(config: TestConfig)
		local testBlock = config.testBlock[LIBRARY_NAME]
		local isComplete = false
		local stop = nil

		-- Unmount the benchmark when done and dump the results to the console.
		local onComplete = function(results: Types.BenchResultsType)
			stop()

			isComplete = true

			print(formatBenchmark({
				group = "FrameRate",
				name = "FPS",
				mean = results.meanFPS,
				unit = "ops/sec",
				stdDev = results.stdDevFPS / results.meanFPS * 100,
				samples = results.sampleCount,
			}))
			print(formatBenchmark({
				group = "FrameRate",
				name = "Δt",
				mean = results.mean,
				unit = "ms/op",
				stdDev = results.stdDev / results.mean * 100,
				samples = results.sampleCount,
			}))
		end

		local BenchmarkWrapper = function()
			local benchmarkRef = useRef(false)

			-- Run the benchmark after the first render.
			useEffect(function()
				local benchmarkInstance = benchmarkRef.current
				benchmarkInstance:start()
			end, {})

			local benchmark = Roact.createElement(Benchmark, {
				component = testBlock.Component,
				forceLayout = true,
				getComponentProps = testBlock.getComponentProps,
				onComplete = onComplete,
				ref = benchmarkRef,
				sampleCount = testBlock.sampleCount,
				timeout = config.timeout,
				type = testBlock.benchmarkType,
			})

			return benchmark
		end

		-- Create and mount the benchmark component.
		local rootInstance = Instance.new("Folder")
		rootInstance.Name = "GuiRoot"
		rootInstance.Parent = PlayerGui
		stop = bootstrap(rootInstance, BenchmarkWrapper)

		-- Prevent the CLI from closing while the benchmark is in progress.
		while not isComplete do
			wait(1)
		end
	end
end
