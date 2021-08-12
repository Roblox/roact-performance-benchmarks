export type Config = {
	verbose: boolean?,
	minSamples: number?,
}

return function(Roact, ReactRoblox, Scheduler)
	return function(config_: Config?)
		local defaultConfig = {
			verbose = false,
			minSamples = 100,
		}

		local rootWorkspace = script.Parent.Parent
		local Array = require(rootWorkspace.LuauPolyfill).Array
		local Object = require(rootWorkspace.LuauPolyfill).Object
		local Concurrent = require(rootWorkspace.PerformanceBenchmarks.concurrent)(Roact, Scheduler).Concurrent
		local bootstrap = require(script.Parent.bootstrap)(Roact, ReactRoblox)
		local calculateStats = require(script.Parent.calculateStats)

		local config = Object.assign({}, defaultConfig, config_)

		local rootInstance = Instance.new("Folder")
		rootInstance.Name = "GuiRoot"
		local last
		local index = 1
		local values = {}

		local function connect()
			local connection
			connection = rootInstance.ChildAdded:Connect(function(child)
				local deltaTime = os.clock() - last
				table.insert(values, deltaTime * 1000)

				if config.verbose then
					local benchmarkStats = calculateStats(values)
					print(Array.join({
						("#%04d"):format(#values),
						("TIME: %8.2f"):format(deltaTime * 1000),
						("AVG: %8.4f"):format(benchmarkStats.mean),
						("VAR: %8.4f"):format(benchmarkStats.variance),
						("MIN: %8.4f"):format(benchmarkStats.min),
						("MAX: %8.4f"):format(benchmarkStats.max),
					}, "\t|\t"))
				end
				index += 1
				if connection then
					connection:Disconnect()
				end
			end)
		end

		if config.verbose then
			print("---- First Render Benchmark ----")
			print("")
		end

		for i = 1, config.minSamples do
			connect()

			last = os.clock()
			local stop = bootstrap(rootInstance, Concurrent)

			rootInstance.ChildAdded:Wait()
			stop()
			wait()
			rootInstance:ClearAllChildren()
		end

		local benchmarkStats = calculateStats(values)

		print(
			("FirstRendert#\u{0394}t x %4.4f sec/op ±%3.2f%% (%d runs sampled)(roblox-cli version %s)"):format(
				benchmarkStats.mean,
				benchmarkStats.stdDev,
				benchmarkStats.count,
				version()
			)
		)
	end
end
