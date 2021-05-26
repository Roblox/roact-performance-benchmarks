local srcWorkspace = script.Parent.Parent
local rootWorkspace = srcWorkspace.Parent
local Packages = rootWorkspace.Packages
local Roact = require(Packages.Roact)
local useRef = Roact.useRef
local useEffect = Roact.useEffect
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

-- ROBLOX TODO: replace deep import when Rotriever handles submodules
local forwardRef = require(Packages._Index.roact.roact.React.ReactForwardRef).forwardRef

local Canvas = forwardRef(function (props, ref)
	local viewportRef = useRef()
	local cameraRef_ = useRef()
	local cameraRef = ref or cameraRef_
	local camera = Roact.createElement("Camera", {
		CFrame = CFrame.new(Vector3.new(0, 0, 6), Vector3.new(0, 0, 0)),
		ref = cameraRef,
	})

	useEffect(function()
		viewportRef.current.CurrentCamera = cameraRef.current
	end)

	return Roact.createElement("ViewportFrame", {
		Size = UDim2.new(0.8, 0, 0.8, 0),
        Position = UDim2.new(0.1, 0, 0.1, 0),
		BackgroundColor3 = Color3.fromRGB(0x27, 0x27, 0x37),
		ref = viewportRef,
	}, Array.concat({
		camera,
	}, props.children))
end)

return Canvas
