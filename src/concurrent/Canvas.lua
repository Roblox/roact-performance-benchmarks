local srcWorkspace = script.Parent.Parent
local rootWorkspace = srcWorkspace.Parent
local Packages = rootWorkspace.Packages
local Roact = require(Packages.Roact)
local useRef = Roact.useRef
local useEffect = Roact.useEffect
local LuauPolyfill = require(Packages.LuauPolyfill)
local Array = LuauPolyfill.Array

function Canvas(props)
	local viewportRef = useRef()
	local cameraRef = useRef()
	local camera = Roact.createElement("Camera", {
		CFrame = CFrame.new(Vector3.new(0, 2, 12), Vector3.new(0, 0, 0)),
		ref = cameraRef,
	})

	useEffect(function()
		viewportRef.current.CurrentCamera = cameraRef.current
	end)

	return Roact.createElement("ViewportFrame", {
		Size = UDim2.new(0, 800, 0, 600),
		BackgroundColor3 = Color3.fromRGB(0x27, 0x27, 0x37),
		ZIndex = 2,
		ref = viewportRef,
	}, Array.concat({
		camera,
	}, props.children))
end

return Canvas
