local ProcessService = game:GetService("ProcessService")
local rootWorkspace = script.Parent.TestingModel.Packages

-- Load JestRoblox source into Packages folder so it's next to Roact as expected
local JestRoblox = require(rootWorkspace.Dev.JestRoblox)

-- Run all tests, collect results, and report to stdout.
local result = JestRoblox.TestBootstrap:run(
	{ rootWorkspace.PerformanceBenchmarks },
	JestRoblox.Reporters.TextReporterQuiet
)

if result.failureCount == 0 and #result.errors == 0 then
	ProcessService:ExitAsync(0)
else
	ProcessService:ExitAsync(1)
end
