local interpolateRgbBasis

return function(scheme)
	return interpolateRgbBasis(scheme[scheme.length - 1])
end
