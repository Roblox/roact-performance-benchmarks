return function()
	local testWorkspace = script.Parent.Parent
	local srcWorkspace = testWorkspace.Parent
	local rootWorkspace = srcWorkspace.Parent
	local PackagesWorkspace = rootWorkspace.Packages

	local JestRoblox = require(PackagesWorkspace.Dev.JestRoblox)
	local expect = JestRoblox.Globals.expect

	local LuauPolyfill = require(PackagesWorkspace.LuauPolyfill)
	local Array = LuauPolyfill.Array

	local Roact = require(PackagesWorkspace.Roact)
	local useRef = Roact.useRef

	local Canvas = require(testWorkspace.Canvas)
	local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)

	describe("Concurrent example tests", function()
		local rootInstance
		local stop

		it("should pass ref to Canvas", function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
			local cameraRef

			stop = bootstrapSync(rootInstance, function()
				cameraRef = useRef()
				return Roact.createElement(Canvas, {
					ref = cameraRef,
				})
			end)

			expect(cameraRef.current).toBeDefined()
			expect(cameraRef.current:isA("Camera")).toBe(true)
		end)

		it("should attach Camera to ViewportFrame", function()
			rootInstance = Instance.new("Folder")
			rootInstance.Name = "GuiRoot"
			local cameraRef

			stop = bootstrapSync(rootInstance, function()
				cameraRef = useRef()
				return Roact.createElement(Canvas, {
					ref = cameraRef,
				})
			end)

			local viewPortFrame = rootInstance:findFirstChildWhichIsA("ViewportFrame")

			wait()

			expect(viewPortFrame).toBeDefined()
			expect(viewPortFrame.CurrentCamera).toBeDefined()
			expect(viewPortFrame.CurrentCamera).toBe(cameraRef.current)
		end)
	end)
end
