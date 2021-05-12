local Status = newproxy(false)

type TaskStatus = number
type Task = {
	[Status]: TaskStatus
}

local SCHEDULED = 1
-- local DONE = 2
local CANCELLED = 3

return function(delayImpl)
	local function setInterval(callback, intervalTime: number, ...): Task
		local args = {...}
		local task = {
			[Status] = SCHEDULED
		}
		
		-- delayTime is an optional parameter
		if intervalTime == nil then
			intervalTime = 0
		end

		-- To mimic the JS interface, we're expecting delayTime to be in ms
		local intervalTimeMs = intervalTime / 1000

		local delay
		delay = function ()
			delayImpl(intervalTimeMs, function()
				if task[Status] == SCHEDULED then
					callback(unpack(args))
					delay()
					-- task[Status] = DONE
				end
			end)
		end

		delay()

		-- delayImpl(intervalTimeMs, function()
		-- 	if task[Status] == SCHEDULED then
		-- 		callback(unpack(args))
		-- 		task[Status] = DONE
		-- 	end
		-- end)

		return task
	end

	local function clearInterval(task: Task)
		if task[Status] == SCHEDULED then
			task[Status] = CANCELLED
		end
	end

	return {
		setInterval = setInterval,
		clearInterval = clearInterval,
	}
end
