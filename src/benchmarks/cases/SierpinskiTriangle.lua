-- TODO: Move to benchmark init.
local BenchmarkType = {
	MOUNT = "mount",
	UPDATE = "update",
	UNMOUNT = "unmount",
}

local TARGET_SIZE = 10

-- Lerps between a start and an end color. Additional noise is added that
-- doesn't deviate far from the target color so the triangles can be visually
-- differentiated from eachother as they approach the target.
local function interpolateColors(from: Color3, to: Color3, alpha: number): Color3
	local offset = (math.random() - 0.5)

	return from:Lerp(to, alpha + offset)
end

local function interpolatePurples(alpha: number)
	return interpolateColors(Color3.fromHSV(0.7, 0.1, 1), Color3.fromHSV(0.75, 0.6, 0.6), alpha)
end

local function interpolateBuPu(alpha: number)
	return interpolateColors(Color3.fromHSV(0.665, 0.1, 0.8), Color3.fromHSV(0.7, 0.8, 1), alpha)
end

local function interpolateRdPu(alpha: number)
	return interpolateColors(Color3.fromHSV(0.0, 0.1, 0.6), Color3.fromHSV(0.75, 0.6, 0.6), alpha)
end

return function(Roact, ReactRoblox)
	local function SierpinskiTriangle(props)
		local components, x, y, depth, renderCount, sampleCount, s =
			props.components, props.x, props.y, props.depth or 0, props.renderCount or 0, props.sampleCount, props.s
		local Dot = components.Dot

		-- ROBLOX deviation: assume Dot is available as we have only one
		-- implementation and it will be present.

		if s <= TARGET_SIZE then
			local interpolateFn
			if depth == 1 then
				interpolateFn = interpolatePurples
			elseif depth == 2 then
				interpolateFn = interpolateBuPu
			else
				interpolateFn = interpolateRdPu
			end

			-- ROBLOX deviation: use randomly generated colors based on just render
			-- count instead of relying on d3, for now at least. The way this works
			-- is the interpolation progress is increased as the current render
			-- count approaches total amount of samples we expect.
			local color = interpolateFn(renderCount / sampleCount)

			return Roact.createElement(Dot, {
				color = color,
				size = TARGET_SIZE,
				x = x - TARGET_SIZE / 2,
				y = y - TARGET_SIZE / 2,
			})
		end

		s /= 2

		return {
			Roact.createElement(SierpinskiTriangle, {
				components = components,
				depth = 1,
				renderCount = renderCount,
				sampleCount = sampleCount,
				s = s,
				x = x,
				y = y - s / 2,
			}),
			Roact.createElement(SierpinskiTriangle, {
				components = components,
				depth = 2,
				renderCount = renderCount,
				sampleCount = sampleCount,
				s = s,
				x = x - s,
				y = y + s / 2,
			}),
			Roact.createElement(SierpinskiTriangle, {
				components = components,
				depth = 3,
				renderCount = renderCount,
				sampleCount = sampleCount,
				s = s,
				x = x + s,
				y = y + s / 2,
			}),
		}
	end

	-- ROBLOX deviation: we use function components and move static props to
	-- exports so they're accessible.
	return {
		SierpinskiTriangle = SierpinskiTriangle,
		displayName = "SierpinskiTriangle",
		benchmarkType = BenchmarkType.UPDATE,
	}
end
