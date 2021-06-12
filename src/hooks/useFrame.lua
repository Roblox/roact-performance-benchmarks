local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)
local useEffect = Roact.useEffect
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local function useFrame(onFrame)
	useEffect(function()
		local name = HttpService:GenerateGUID()
		RunService:BindToRenderStep(name, Enum.RenderPriority.First.Value, onFrame)

		return function()
			local success, message = pcall(function()
				RunService:UnbindFromRenderStep(name)
			end)
			if not success then
				print("An error occurred: " .. message)
			end
		end
	end)
end

return useFrame
