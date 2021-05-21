local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages

local Roact = require(Packages.Roact)
local useEffect = Roact.useEffect
local RunService = game:GetService("RunService")

local function useFrame(onFrame)
	useEffect(function()
		local name = "FPS Counter"
		RunService:BindToRenderStep(name, Enum.RenderPriority.First.Value, onFrame)

		return function()
			local success, message = pcall(function()
				RunService:UnbindFromRenderStep(name)
			end)
			if success then
				print("Success: Function unbound!")
			else
				print("An error occurred: " .. message)
			end
		end
	end)
end

return {
	useFrame = useFrame,
}
