export type Config = {
	verbose: boolean?,
	minSamples: number?,
	minTime: number?,
	maxTime: number?,
}

return function(Roact, ReactRoblox, Scheduler)
	return function(config_: Config?)
		local defaultConfig = {
			verbose = false,
			minSamples = 100,
			minTime = 0,
			maxTime = 20,
		}

		local srcWorkspace = script.Parent
		local rootWorkspace = srcWorkspace.Parent
		local Array = require(rootWorkspace.LuauPolyfill).Array
		local Object = require(rootWorkspace.LuauPolyfill).Object
		local Concurrent = require(srcWorkspace.concurrent)(Roact, Scheduler).Concurrent
		local useFrame = require(srcWorkspace.hooks.useFrame)(Roact)
		local formatBenchmark = require(srcWorkspace.utils.formatBenchmark).formatBenchmark
		local bootstrap = require(script.Parent.bootstrap)(Roact, ReactRoblox)
		local calculateStats = require(script.Parent.calculateStats)

		local config = Object.assign({}, defaultConfig, config_)

		local rootInstance = Instance.new("Folder")
		rootInstance.Name = "GuiRoot"

		local fpsValues = {}
		local values = {}

		local function CalcFPS()
			local last = os.clock()
			useFrame(function()
				local now = os.clock()
				local deltaTime = (now - last)
				local fps = 1 / deltaTime
				last = now
				table.insert(values, deltaTime * 1000)
				table.insert(fpsValues, fps)
				if config.verbose then
					local benchmarkStats = calculateStats(values)
					local fpsStats = calculateStats(fpsValues)
					print(Array.join({
						("#%04d"):format(#values),
						("\u{0394}t: %8.4f"):format(deltaTime * 1000),
						("FPS: %8.4f"):format(fps),
						("AVG(\u{0394}t/FPS): %8.4f / %8.4f"):format(1 / (benchmarkStats.mean / 1000), fpsStats.mean),
						("VAR(\u{0394}t/FPS): %8.4f / %8.4f"):format(benchmarkStats.variance, fpsStats.variance),
						("σ(\u{0394}t/FPS): %8.4f / %8.4f"):format(benchmarkStats.stdDev, fpsStats.stdDev),
						("MIN(\u{0394}t/FPS): %8.4f / %8.4f"):format(benchmarkStats.min, fpsStats.min),
						("MAX(\u{0394}t/FPS): %8.4f / %8.4f"):format(benchmarkStats.max, fpsStats.max),
					}, "\t|\t"))
				end
			end)

			return nil
		end

		local function Benchmark(props)
			return Roact.createElement("Folder", {}, {
				Roact.createElement(Concurrent, props),
				Roact.createElement(CalcFPS),
			})
		end

		if config.verbose then
			print("---- Frame Rate Benchmark ----")
			print("")
		end

		local stop = bootstrap(rootInstance, Benchmark)

		wait(config.minTime)

		local sampleDelta = 1 / 30
		while #values < config.minSamples do
			wait(sampleDelta)
		end

		stop()

		local benchmarkStats = calculateStats(values)
		local fpsStats = calculateStats(fpsValues)

		print(formatBenchmark({
			group = "FrameRate",
			name = "FPS",
			mean = fpsStats.mean,
			unit = "ops/sec",
			stdDev = fpsStats.stdDev / fpsStats.mean * 100,
			samples = fpsStats.count,
		}))
		print(formatBenchmark({
			group = "FrameRate",
			name = "Δt",
			mean = benchmarkStats.mean,
			unit = "ms/op",
			stdDev = benchmarkStats.stdDev / benchmarkStats.mean * 100,
			samples = benchmarkStats.count,
		}))
	end
end
