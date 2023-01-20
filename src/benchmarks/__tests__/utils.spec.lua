local testWorkspace = script.Parent.Parent
local srcWorkspace = testWorkspace.Parent
local rootWorkspace = srcWorkspace.Parent

local Roact = require(rootWorkspace.Dev.Roact)
local ReactRoblox = require(rootWorkspace.Dev.ReactRoblox)
local JestGlobals = require(rootWorkspace.Dev.JestGlobals)
local jestExpect = JestGlobals.expect
local describe = JestGlobals.describe
local it = JestGlobals.it
local LuauPolyfill = require(rootWorkspace.LuauPolyfill)
local Object = LuauPolyfill.Object

local Utils = require(testWorkspace.utils)(Roact, ReactRoblox)

describe("utils tests", function()
	it("should construct a test block for roact", function()
		local mockComponent = { mockComponent = "mockComponent" }
		local anchorPoint = Vector2.new(0.5, 0.5)

		local testBlock = Utils.createTestBlock(function(components)
			return {
				benchmarkType = "mount",
				Component = mockComponent,
				getComponentProps = function()
					return { breadth = 2, components = components, depth = 7, id = 0, wrap = 1 }
				end,
				Provider = components.Provider,
				sampleCount = 50,
				anchorPoint = anchorPoint,
			}
		end)

		jestExpect(#Object.keys(testBlock)).toBe(1)

		local roact = testBlock.roact
		jestExpect(roact).toBeDefined()
		jestExpect(roact.Component).toBe(mockComponent)
		jestExpect(roact.Provider).toBeDefined()
		jestExpect(roact.sampleCount).toBe(50)
		jestExpect(roact.anchorPoint).toBe(anchorPoint)
		jestExpect(roact.benchmarkType).toBe("mount")
		jestExpect(roact.version).toBe("?")
		jestExpect(roact.name).toBe("roact")

		local props = roact.getComponentProps()
		jestExpect(props.breadth).toBe(2)
		jestExpect(props.components).toBeDefined()
		jestExpect(props.depth).toBe(7)
		jestExpect(props.id).toBe(0)
		jestExpect(props.wrap).toBe(1)
	end)
end)
