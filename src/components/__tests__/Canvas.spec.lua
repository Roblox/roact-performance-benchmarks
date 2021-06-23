return function()
	local testWorkspace = script.Parent.Parent
	local srcWorkspace = testWorkspace.Parent
	local rootWorkspace = srcWorkspace.Parent
	local PackagesWorkspace = rootWorkspace.Packages

	local JestRoblox = require(PackagesWorkspace.Dev.JestRoblox)
	local jestExpect = JestRoblox.Globals.expect

	local Roact = require(PackagesWorkspace.Roact)
	local useRef = Roact.useRef

	local Canvas = require(testWorkspace.Canvas)
	local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)

	describe("Concurrent example tests", function()
		local rootInstance
		local _stop

		it("should pass ref to Canvas", function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
			local cameraRef

			_stop = bootstrapSync(rootInstance, function()
				cameraRef = useRef()
				return Roact.createElement(Canvas, {
					[Roact.Ref] = cameraRef,
				})
			end)

			jestExpect(cameraRef.current).toBeDefined()
			jestExpect(cameraRef.current:isA("Camera")).toBe(true)
		end)

		it("should attach Camera to ViewportFrame", function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
			local cameraRef

			_stop = bootstrapSync(rootInstance, function()
				cameraRef = useRef()
				return Roact.createElement(Canvas, {
					[Roact.Ref] = cameraRef,
				})
			end)

			local viewPortFrame = rootInstance:findFirstChildWhichIsA("ViewportFrame")

			wait()

			jestExpect(viewPortFrame).toBeDefined()
			jestExpect(viewPortFrame.CurrentCamera).toBeDefined()
			jestExpect(viewPortFrame.CurrentCamera).toBe(cameraRef.current)
		end)
	end)
end
