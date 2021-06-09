local Packages = script.Parent.Parent.Packages
local ReactRoblox = require(Packages.ReactRoblox)
local Roact = require(Packages.Roact)

local _stop

local function bootstrap(rootInstance, component, props)
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

return bootstrap
