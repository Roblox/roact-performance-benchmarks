local hooksWorkspace = script.Parent.Parent
local srcWorkspace = hooksWorkspace.Parent
local rootWorkspace = srcWorkspace.Parent

local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local jest = JestGlobals.jest
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach

describe("useFrame", function()
	local Roact
	local ReactRoblox
	local bootstrapSync
	local useFrame
	local Connect
	local Disconnect

	beforeEach(function()
		jest.resetModules()

		Disconnect = jest.fn()
		Connect = jest.fn(function()
			return Disconnect
		end)

		jest.mock(srcWorkspace.utils.RunService, function()
			return {
				RenderStepped = {
					Connect = Connect,
				},
			}
		end)

		--[[
			because we reset modules for each test we need to reimport
			- Roact
			- bootstrapSync
			so that they use the same Roact instance as `useFrame`
		]]
		Roact = require(rootWorkspace.Dev.Roact)
		ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
		bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)(Roact, ReactRoblox)
		useFrame = require(hooksWorkspace.useFrame)(Roact)
	end)

	afterEach(function()
		jest.unmock(srcWorkspace.utils.RunService)
	end)

	it("should call BindToRenderStep", function()
		local rootInstance = Instance.new("Folder")
		rootInstance.Name = "GuiRoot"

		local _stop = bootstrapSync(rootInstance, function()
			useFrame(function() end)
			return Roact.createElement("Folder")
		end)

		wait()
		jestExpect(Connect).toHaveBeenCalledTimes(1)
	end)
end)
