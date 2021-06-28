local rootWorkspace = script.Parent.Parent.Parent
local PackagesWorkspace = rootWorkspace.Packages
local Roact = require(PackagesWorkspace.Roact)
local ReactRoblox = require(PackagesWorkspace.ReactRoblox)

local function bootstrap(rootInstance, component, props)
	local root = ReactRoblox.createLegacyRoot(rootInstance)
	root:render(Roact.createElement(component, props))

	return function()
		root:unmount()
		rootInstance.Parent = nil
	end
end

return bootstrap
