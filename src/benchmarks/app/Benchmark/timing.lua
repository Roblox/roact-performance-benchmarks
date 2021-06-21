local function now(): number
	-- ROBLOX deviation: os.clock returns seconds with microsecond precision
	-- and upstream uses window.performance.now() which returns milliseconds.
	return os.clock() * 1000
end

return { now = now }
