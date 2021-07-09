local srcWorkspace = script.Parent.Parent

local RunService = require(srcWorkspace.utils.RunService)
local HttpService = game:GetService("HttpService")

return function(Roact)
	local useEffect = Roact.useEffect

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
end
