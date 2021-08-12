local rootWorkspace = script.Parent.Parent

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

	local bootstrap = require(rootWorkspace.PerformanceBenchmarks.bootstrap)(Roact, ReactRoblox)
	local Benchmark = require(rootWorkspace.PerformanceBenchmarks.benchmarks.app.Benchmark)(Roact, ReactRoblox)

	return function(config: TestConfig)
		local testBlock = config.testBlock[LIBRARY_NAME]
		local isComplete = false
		local stop = nil

		-- Unmount the benchmark when done and dump the results to the console.
		local onComplete = function(results: Types.BenchResultsType)
			stop()

			isComplete = true

			local avgFps = 1 / (results.mean / 1000)
			local stdDevPercent = results.stdDev / avgFps * 100

			print(
				("FrameRate#FPS1 x %4.4f ops/sec ±%3.2f%% (%d runs sampled)(roblox-cli version %s)"):format(
					avgFps,
					stdDevPercent,
					results.sampleCount,
					version()
				)
			)
			print(
				("FrameRate#FPS2 x %4.4f ops/sec ±%3.2f%% (%d runs sampled)(roblox-cli version %s)"):format(
					results.mean,
					results.stdDev / results.mean * 100,
					results.sampleCount,
					version()
				)
			)
			print(
				("FrameRate#\u{0394}t x %4.4f ms/op ±%3.2f%% (%d runs sampled)(roblox-cli version %s)"):format(
					results.mean,
					results.stdDev / results.mean * 100,
					results.sampleCount,
					version()
				)
			)
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
