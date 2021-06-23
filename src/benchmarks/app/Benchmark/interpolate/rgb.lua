-- TODO: Implement missing functions.

local gamma = nil
local nogamma = nil
local colorRgb = nil
local basis = nil
local basisClosed = nil

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

	-- ROBLOX deviation: we can't assign a property to a function in lua. Return
	-- a table with both the function and the properties instead.
	return { fn = rgb, gamma = rgbGamma }
end

local function rgbSpline(spline)
	return function(colors)
		local n, r, g, b = colors.length, {}, {}, {}
		local color

		for i = 1, n do
			color = colorRgb(colors[i])
			r[i] = color.r or 0
			g[i] = color.g or 0
			b[i] = color.b or 0
		end

		local rSpline, gSpline, bSpline = spline(r), spline(g), spline(b)
		color.opacity = 1

		return function(t)
			color.r = rSpline(t)
			color.g = gSpline(t)
			color.b = bSpline(t)
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
