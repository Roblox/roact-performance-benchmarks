local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Benchmarks = require(game.ReplicatedStorage.Benchmarks)

local _stop

local function bootstrap(component, props)
	local rootInstance = Instance.new("Folder")
	rootInstance.Name = "GuiRoot"
	rootInstance.Parent = PlayerGui

	local root = Roact.createLegacyRoot(rootInstance)
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
