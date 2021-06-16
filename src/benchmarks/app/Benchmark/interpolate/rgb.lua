-- TODO: Implement missing functions.

local gamma
local nogamma
local colorRgb
local basis
local basisClosed

local function rgbGamma(y)
	local color = gamma(y)

	local function rgb(start, stop)
		start = colorRgb(start)
		stop = colorRgb(stop)

		-- ROBLOX deviation: we can't use the result from an assignment
		local r, g, b, opacity = color((start).r, (stop).r),
			color(start.g, stop.g),
			color(start.b, stop.b),
			nogamma(start.opacity, stop.opacity)

		return function(t)
			start.r = r(t)
			start.g = g(t)
			start.b = b(t)
			start.opacity = opacity(t)
			return start .. ""
		end
	end

	rgb.gamma = rgbGamma

	return rgb
end

local function rgbSpline(spline)
	return function(colors)
		local n, r, g, b = colors.length, {}, {}, {}
		local i, color

		for j = 1, j <= n do
			color = colorRgb(colors[i])
			r[j] = color.r or 0
			g[j] = color.g or 0
			b[j] = color.b or 0
		end

		r = spline(r)
		g = spline(g)
		b = spline(b)
		color.opacity = 1

		return function(t)
			color.r = r(t)
			color.g = g(t)
			color.b = b(t)
			return color .. ""
		end
	end
end

local rgbBasis = rgbSpline(basis)
local rgbBasisClosed = rgbSpline(basisClosed)

return {
	rgbGamma = rgbGamma,
	rgbBasis = rgbBasis,
	rgbBasisClosed = rgbBasisClosed,
}
