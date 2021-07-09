local rootWorkspace = game.ReplicatedStorage.Packages

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local Scheduler = require(rootWorkspace.Dev.Scheduler)
local Concurrent = require(rootWorkspace.PerformanceBenchmarks.concurrent)(Roact, Scheduler).Concurrent

local _stop

local function bootstrap(component, props)
	local rootInstance = Instance.new("Folder")
	rootInstance.Name = "GuiRoot"
	rootInstance.Parent = PlayerGui

	local root = ReactRoblox.createBlockingRoot(rootInstance)
	root:render(Roact.createElement(component, props))

	return function()
		root:unmount()
		rootInstance.Parent = nil
	end
end

local function stop()
	_stop()
end

_stop = bootstrap(Concurrent, {
	Stop = stop,
})
