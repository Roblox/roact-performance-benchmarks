export type Config = {
	verbose: Boolean?,
	minSamples: Number?,
}

return function(config_: Config?)
	local defaultConfig = {
		verbose = false,
		minSamples = 100,
	}

	local PackagesWorkspace = script.Parent.Parent.Packages
	local Array = require(PackagesWorkspace.LuauPolyfill).Array
	local Object = require(PackagesWorkspace.LuauPolyfill).Object
	local Concurrent = require(script.Parent.Parent.Src.concurrent)
	local bootstrap = require(script.Parent.bootstrap)
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
				local stats = calculateStats(values)
				print(Array.join({
					("#%04d"):format(#values),
					("TIME: %8.2f"):format(deltaTime * 1000),
					("AVG: %8.4f"):format(stats.mean),
					("VAR: %8.4f"):format(stats.variance),
					("MIN: %8.4f"):format(stats.min),
					("MAX: %8.4f"):format(stats.max),
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

	local stats = calculateStats(values)

	print(("FirstRendert#\u{0394}t x %4.4f sec/op ±%3.2f%% (%d runs sampled)"):format(
		stats.mean,
		stats.stdDev,
		stats.count
	))
end
