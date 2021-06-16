local rootWorkspace = script.Parent.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Benchmarks = rootWorkspace.Src.Benchmarks

local Roact = require(Packages.Roact)

local Chromatic = require(Benchmarks.App.Benchmark.Chromatic)
local interpolatePurples
local interpolateBuPu
local interpolateRdPu

-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local targetSize = 10

local function SierpinskiTriangle(props)
	local components, x, y, depth, renderCount, s =
		props.components, props.x, props.y, props.depth, props.renderCount, props.s
	local Dot = components.Dot

	-- ROBLOX deviation: assume Dot is available as we have only one
	-- implementation and it will be present.

	if s <= targetSize then
		local fn
		if depth == 1 then
			fn = interpolatePurples
		elseif depth == 2 then
			fn = interpolateBuPu
		else
			fn = interpolateRdPu
		end

		-- ROBLOX deviation: Re-seed just in-case as Lua doesn't do this for us.
		math.randomseed(os.time())

		local color = fn((renderCount * math.random()) / 20)
		return Roact.createElement(
			Dot,
			{ color = color, size = targetSize, x = x - targetSize / 2, y = y - targetSize / 2 }
		)
	end

	s /= 2

	return Roact.createFragment({
		Roact.createElement(SierpinskiTriangle, {
			components = components,
			depth = 1,
			renderCount = renderCount,
			s = s,
			x = x,
			y = y - s / 2,
		}),
		Roact.createElement(SierpinskiTriangle, {
			components = components,
			depth = 2,
			renderCount = renderCount,
			s = s,
			x = x - s,
			y = y + s / 2,
		}),
		Roact.createElement(SierpinskiTriangle, {
			components = components,
			depth = 3,
			renderCount = renderCount,
			s = s,
			x = x + s,
			y = y + s / 2,
		}),
	})
end

-- ROBLOX deviation: we use function components and move static props to
-- exports so they're accessible.
return {
	SierpinskiTriangle = SierpinskiTriangle,
	displayName = "SierpinskiTriangle",
	benchmarkType = BenchmarkType.UPDATE,
	defaultProps = {
		depth = 0,
		renderCount = 0,
	},
}
