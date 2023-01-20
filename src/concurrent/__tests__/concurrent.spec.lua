local testWorkspace = script.Parent.Parent
local srcWorkspace = testWorkspace.Parent
local rootWorkspace = srcWorkspace.Parent

local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local Scheduler = require(rootWorkspace.Dev.Scheduler)

local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local beforeEach = JestGlobals.beforeEach
local afterEach = JestGlobals.afterEach

local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Array = LuauPolyfill.Array

local Concurrent = require(testWorkspace.concurrent)(Roact, Scheduler).Concurrent
local bootstrapSync = require(srcWorkspace.testUtils.bootstrapSync)(Roact, ReactRoblox)

describe("Concurrent example tests", function()
	local rootInstance
	local stop

	beforeEach(function()
		rootInstance = Instance.new("Folder")
		rootInstance.Name = "GuiRoot"

		stop = bootstrapSync(rootInstance, Concurrent)
	end)

	afterEach(function()
		stop()
	end)

	it("should render Blocks", function()
		local descendants = rootInstance:GetDescendants()
		local count = #Array.filter(descendants, function(item)
			return item.Name == "Block"
		end)

		jestExpect(count).toBe(600)
	end)

	it("should render Boxes", function()
		local descendants = rootInstance:GetDescendants()
		local count = #Array.filter(descendants, function(item)
			return item.Name == "Box"
		end)

		jestExpect(count).toBe(1000)
	end)
end)
