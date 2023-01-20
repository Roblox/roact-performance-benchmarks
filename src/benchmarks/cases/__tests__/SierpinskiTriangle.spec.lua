local testWorkspace = script.Parent.Parent
local srcWorkspace = testWorkspace.Parent.Parent
local rootWorkspace = srcWorkspace.Parent

local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local afterEach = JestGlobals.afterEach

local SierpinskiTriangle = require(testWorkspace.SierpinskiTriangle)(Roact, ReactRoblox).SierpinskiTriangle
local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)(Roact, ReactRoblox)
local components = require(srcWorkspace.benchmarks.implementations.roact)(Roact, ReactRoblox)

describe("sierpinski triangle benchmark case tests (roact)", function()
	local stop

	afterEach(function()
		if stop then
			stop()
			stop = nil
		end
	end)

	it("should render with children matching configured count", function()
		local props = {
			components = components,
			s = 200,
			sampleCount = 50,
			x = 0,
			y = 0,
		}

		local rootInstance = Instance.new("Folder")
		rootInstance.Name = "GuiRoot"
		stop = bootstrapSync(rootInstance, SierpinskiTriangle, props)

		local children = rootInstance:GetChildren()
		local count = #children

		jestExpect(count).toBe(243)
	end)
end)
