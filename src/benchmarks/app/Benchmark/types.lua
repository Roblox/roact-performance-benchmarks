export type BenchResultsType = {
	startTime: number,
	endTime: number,
	runTime: number,
	sampleCount: number,
	samples: { FullSampleTimingType? },
	max: number,
	min: number,
	median: number,
	mean: number,
	stdDev: number,
	maxFPS: number,
	minFPS: number,
	medianFPS: number,
	meanFPS: number,
	stdDevFPS: number,
	meanLayout: number,
	meanScripting: number,
}

export type SampleTimingType = {
	scriptingStart: number,
	scriptingEnd: number?,
	layoutStart: number?,
	layoutEnd: number?,
}

export type FullSampleTimingType = {
	start: number,
	stop: number, -- ROBLOX deviation: end is a reserved word
	scriptingStart: number,
	scriptingEnd: number,
	layoutStart: number?,
	layoutEnd: number?,
}

export type BenchmarkType = { [string]: string }

return {}
