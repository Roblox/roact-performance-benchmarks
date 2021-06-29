local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local ReactRoblox = require(game.ReplicatedStorage.Packages.ReactRoblox)
local Benchmarks = require(game.ReplicatedStorage.Src.benchmarks)

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

_stop = bootstrap(Benchmarks, {
	Stop = stop,
})
