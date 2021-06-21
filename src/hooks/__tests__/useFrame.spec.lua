return function()
	local hooksWorkspace = script.Parent.Parent
	local srcWorkspace = hooksWorkspace.Parent
	local rootWorkspace = srcWorkspace.Parent
	local PackagesWorkspace = rootWorkspace.Packages

	local JestRoblox = require(PackagesWorkspace.Dev.JestRoblox)
	local expect = JestRoblox.Globals.expect
	local jest = JestRoblox.Globals.jest

	-- ROBLOX TODO: replace this functionality; roact-alignment should probably
	-- not actually allow this to be consumed by external users
	local RobloxJest = require(PackagesWorkspace.Dev.RobloxJest)

	describe("useFrame", function()
		local Roact
		local bootstrapSync
		local useFrame
		local RunService
		local stop

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
			Roact = require(PackagesWorkspace.Roact)
			bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)
			useFrame = require(hooksWorkspace.useFrame)
			RunService = require(srcWorkspace.utils.RunService)
		end)

		afterEach(function() 
			RobloxJest.unmock(srcWorkspace.utils.RunService)
		end)

		it("should call BindToRenderStep", function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"

			local stop = bootstrapSync(rootInstance, function()
                useFrame(function() 
                end)
				return Roact.createElement("Folder")
			end)

			-- ROBLOX FIX: this is necessary for useEffect callback to be executed
            stop()

			wait()
			expect(RunService.BindToRenderStep).toHaveBeenCalledTimes(1)
		end)
	end)
end
