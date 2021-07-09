return function()
	local hooksWorkspace = script.Parent.Parent
	local srcWorkspace = hooksWorkspace.Parent
	local rootWorkspace = srcWorkspace.Parent

	local JestRoblox = require(rootWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect
	local jest = JestRoblox.Globals.jest

	-- ROBLOX TODO: replace this functionality; roact-alignment should probably
	-- not actually allow this to be consumed by external users
	local RobloxJest = require(rootWorkspace.Dev.RobloxJest)

	-- ROBLOX FIX: unskip when mocking works correctly
	xdescribe("useFrame expected", function()
		local Roact
		local ReactRoblox
		local bootstrapSync
		local useFrame
		local RunService

		beforeEach(function()
			RobloxJest.resetModules()

			RobloxJest.mock(srcWorkspace.utils.RunService, function()
				return {
					BindToRenderStep = jest:fn(),
					UnbindFromRenderStep = jest:fn(),
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
			RunService = require(srcWorkspace.utils.RunService)
		end)

		afterEach(function()
			RobloxJest.unmock(srcWorkspace.utils.RunService)
		end)

		it("should call BindToRenderStep", function()
			local rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"

			local _stop = bootstrapSync(rootInstance, function()
				useFrame(function() end)
				return Roact.createElement("Folder")
			end)

			wait()
			jestExpect(RunService.BindToRenderStep).toHaveBeenCalledTimes(1)
		end)
	end)
end
