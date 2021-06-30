local srcWorkspace = script.Parent.Parent
local rootWorkspace = srcWorkspace.Parent
local Packages = rootWorkspace.Packages
local Roact = require(Packages.Roact)
local forwardRef = Roact.forwardRef
local useRef = Roact.useRef
local useEffect = Roact.useEffect
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

local Canvas = forwardRef(function(props, ref)
	local viewportRef = useRef()
	local cameraRef_ = useRef()
	local cameraRef = ref or cameraRef_

	useEffect(function()
		viewportRef.current.CurrentCamera = cameraRef.current
	end)

	return Roact.createElement(
		"ViewportFrame",
		{
			Size = UDim2.new(0.8, 0, 0.8, 0),
			Position = UDim2.new(0.1, 0, 0.1, 0),
			BackgroundColor3 = Color3.fromRGB(0x27, 0x27, 0x37),
			-- selene: allow(roblox_incorrect_roact_usage)
			ref = viewportRef,
		},
		Array.concat({
			Roact.createElement("Camera", {
				CFrame = CFrame.new(Vector3.new(0, 0, 6), Vector3.new(0, 0, 0)),
				-- selene: allow(roblox_incorrect_roact_usage)
				ref = cameraRef,
			}),
		}, props.children)
	)
end)

return Canvas
