return function()
	local hooksWorkspace = script.Parent.Parent
	local srcWorkspace = hooksWorkspace.Parent
	local rootWorkspace = srcWorkspace.Parent
	local packagesWorkspace = rootWorkspace.Packages

	local JestRoblox = require(packagesWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect
	local jest = JestRoblox.Globals.jest

	-- ROBLOX TODO: replace deep import when Rotriever handles submodules
	local RobloxJest = require(packagesWorkspace._Index.roact.roact.RobloxJest)

	-- ROBLOX FIX: unskip when mocking works correctly
	xdescribe("useFrame expected", function()
		local Roact
		local bootstrapSync
		local useFrame
		local RunService
		local _stop

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
			Roact = require(packagesWorkspace.Roact)
			bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)
			useFrame = require(hooksWorkspace.useFrame)
			RunService = require(srcWorkspace.utils.RunService)
		end)

		afterEach(function()
			RobloxJest.unmock(srcWorkspace.utils.RunService)
		end)

		it("should call BindToRenderStep", function()
			local rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"

			local stop = bootstrapSync(rootInstance, function()
				useFrame(function()
				end)
				return Roact.createElement("Folder")
			end)

			wait()
			jestExpect(RunService.BindToRenderStep).toHaveBeenCalledTimes(1)
		end)
	end)
end
