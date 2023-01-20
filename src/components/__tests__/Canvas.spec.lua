local testWorkspace = script.Parent.Parent
local srcWorkspace = testWorkspace.Parent
local rootWorkspace = srcWorkspace.Parent

local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it

local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local useRef = Roact.useRef

local Canvas = require(testWorkspace.Canvas)(Roact)
local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)(Roact, ReactRoblox)

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
				ref = cameraRef,
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
				ref = cameraRef,
			})
		end)

		local viewPortFrame = rootInstance:findFirstChildWhichIsA("ViewportFrame")

		wait()

		jestExpect(viewPortFrame).toBeDefined()
		jestExpect(viewPortFrame.CurrentCamera).toBeDefined()
		jestExpect(viewPortFrame.CurrentCamera).toBe(cameraRef.current)
	end)
end)
