local ProcessService = game:GetService("ProcessService")
local rootWorkspace = script.Parent.TestingModel.Packages

local TestEZ = require(rootWorkspace.Dev.JestGlobals).TestEZ

-- Run all tests, collect results, and report to stdout.
local result = TestEZ.TestBootstrap:run(
	{ rootWorkspace.PerformanceBenchmarks },
	TestEZ.Reporters.TextReporterQuiet
)

if result.failureCount == 0 and #result.errors == 0 then
	ProcessService:ExitAsync(0)
else
	ProcessService:ExitAsync(1)
end
