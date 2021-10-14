local srcWorkspace = script.Parent.Parent

local RunService = require(srcWorkspace.utils.RunService)

return function(Roact)
	local useEffect = Roact.useEffect

	local function useFrame(onFrame)
		useEffect(function()
			local connection = RunService.RenderStepped:Connect(onFrame)

			return function()
				local success, message = pcall(function()
					connection:Disconnect()
				end)
				if not success then
					print("An error occurred: " .. message)
				end
			end
		end)
	end

	return useFrame
end
