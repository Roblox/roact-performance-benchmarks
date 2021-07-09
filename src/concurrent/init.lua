return function(Roact, Scheduler)
	local Concurrent = require(script.concurrent)(Roact, Scheduler)

	return Concurrent
end
