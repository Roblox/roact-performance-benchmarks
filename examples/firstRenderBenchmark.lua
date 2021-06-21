return function()
	local PackagesWorkspace = script.Parent.Parent.Packages
	local Array = require(PackagesWorkspace.LuauPolyfill).Array
	local Concurrent = require(script.Parent.Parent.Src.concurrent)
	local bootstrap = require(script.Parent.bootstrap)
	local calculateStats = require(script.Parent.calculateStats)

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

			local stats = calculateStats(values)

			print(Array.join({
				("#%04d"):format(#values),
				("TIME: %8.2f"):format(deltaTime * 1000),
				("AVG: %8.4f"):format(stats.mean),
				("VAR: %8.4f"):format(stats.variance),
				("MIN: %8.4f"):format(stats.min),
				("MAX: %8.4f"):format(stats.max),
			}, "\t|\t"))
			index += 1
			if connection then
				connection:Disconnect()
			end
		end)
	end
	local N = 100
	for i = 1, N do
		connect()

		last = os.clock()
		local stop = bootstrap(rootInstance, Concurrent)

		rootInstance.ChildAdded:Wait()
		stop()
		wait()
		rootInstance:ClearAllChildren()
	end
end
