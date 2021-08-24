export type FormatBenchmarkOptions = {
	group: string,
	name: string,
	unit: string,
	mean: number,
	stdDev: number,
	samples: number,
}

return {
	formatBenchmark = function(options: FormatBenchmarkOptions)
		return ("%s#%s x %4.4f %s ±%3.2f%% (%d runs sampled)(roblox-cli version %s)"):format(
			options.group,
			options.name,
			options.mean,
			options.unit,
			options.stdDev,
			options.samples,
			version()
		)
	end,
}
