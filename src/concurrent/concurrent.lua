-- upstream: https://github.com/pmndrs/react-three-fiber/blob/v5.3.19/examples/src/demos/dev/Concurrent.js

local srcWorkspace = script.Parent.Parent
local rootWorkspace = srcWorkspace.Parent
local Packages = rootWorkspace.Packages
local componentsWorkspace = srcWorkspace.components
local hooksWorkspace = srcWorkspace.hooks

local Roact = require(Packages.Roact)
local useState = Roact.useState
local useEffect = Roact.useEffect
local useRef = Roact.useRef
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout
local luaUtils = require(script.Parent.Parent.luaUtils)
local Array, setInterval, clearInterval = luaUtils.Array, luaUtils.setInterval, luaUtils.clearInterval
-- ROBLOX TODO: replace deep import when Rotriever handles submodules
local Scheduler = require(Packages._Index.roact.roact.Scheduler)
local low, run = Scheduler.unstable_LowPriority, Scheduler.unstable_runWithPriority

local useFrame = require(hooksWorkspace.useFrame)
local DivLike = require(componentsWorkspace.DivLike)
local Canvas = require(componentsWorkspace.Canvas)

-- ROBLOX deviation: because os.clock() returns a nr in seconds it's easier to
-- use slowdown in seconds as well
local SLOWDOWN = 1 / 1000
local ROW = 20
local BLOCK_AMOUNT = 600
local SPIKE_AMOUNT = 1000

local _geom = {} -- new BoxBufferGeometry(1, 1, 1)
local _matr = {} -- new MeshNormalMaterial()

local rpi = function()
	return math.random() * math.pi
end

local function Block(props)
	local change, _restProps = props.change or false, Object.assign({}, props, { change = Object.None })
	-- ROBLOX deviation: we need to use 3 numbers to represent a color in Roblox
	local color, set = useState(Color3.new(0, 0, 0))

	-- Artificial slowdown ...
	-- ROBLOX deviation: whole color is equal 0 if sum of all color parts is equal to 0
	if color.R + color.G + color.B > 0 then
		local e = os.clock() + SLOWDOWN
		repeat
		until not (os.clock() < e)
	end

	local mounted = useRef(false)

	useEffect(function()
		mounted.current = true
		return function()
			mounted.current = false
		end
	end)

	useEffect(function()
		if change then
			setTimeout(function()
				run(low, function()
					return mounted.current and set(Color3.new(math.random(), math.random(), math.random()))
				end)
			end, math.random() * 1000)
		end
	end, {
		change,
	})

	return Roact.createElement("Part", {
		Name = "Block",
		Material = Enum.Material.Plastic,
		Color = color,
		Position = Vector3.new(table.unpack(props.position)),
		Size = Vector3.new(table.unpack(props.scale)),
	})
end

local function Blocks()
	local changeBlocks, set = useState(false)
	useEffect(function()
		local handler = setInterval(function()
			set(function(state)
				return not state
			end)
		end, 2000)
		return function()
			clearInterval(handler)
		end
	end)

	-- const { viewport } = useThree()
	-- const { width, height } = viewport().factor
	local width, height = 800, 600 -- TODO implement viewport
	local size = width / 100 / ROW
	return Array.map(Array.create(BLOCK_AMOUNT, 0), function(_, i_)
		local i = i_ - 1
		local left = -width / 100 / 2 + size / 2
		local top = height / 100 / 2 - size / 2
		local x = (i % ROW) * size
		local y = math.floor(i / ROW) * -size

		return Roact.createElement(Block, {
			key = i,
			change = changeBlocks,
			scale = { size, size, size },
			position = { left + x, top + y, 0 },
		})
	end)
end

local function FPS()
	local ref = useRef()
	local last = os.clock()
	local qty = 0
	local currentAvg = 0

	useFrame(function()
		local now = os.clock()
		local fps = 1 / (now - last)

		qty += 1
		--[[
			ROBLOX deviation:
			if we round the avg delta in here and don't update currentAvg each time it becomes basically impossible for the fps avg to be updated when qty value becomes larger
		]]
		local avg = (fps - currentAvg) / qty
		local lastAvg = currentAvg
		currentAvg += avg
		if math.round(currentAvg) ~= math.round(lastAvg) then
			ref.current.Text = SPIKE_AMOUNT
				.. " spikes\n"
				.. BLOCK_AMOUNT
				.. " blocks\n"
				.. (BLOCK_AMOUNT * SLOWDOWN)
				.. "ms potential load\nfps avg "
				.. math.round(currentAvg)
		end
		last = now
	end)

	return Roact.createElement("TextLabel", {
		Size = UDim2.new(0, 150, 0, 100),
		Position = UDim2.new(1, -10, 1, -10),
		AnchorPoint = Vector2.new(1, 1),
		Text = "...",
		[Roact.Ref] = ref,
	})
end

local function Box()
	local t = 0
	local mesh = useRef()
	local coords = useState(function()
		return { rpi(), rpi(), rpi() }
	end)
	useFrame(function()
		-- ROBLOX deviation: increase t before calculating rotation matrix
		t += 0.01
		local rotationFrame = CFrame.Angles(coords[1] + t, coords[2] + t, coords[3] + t)
		if mesh.current then
			mesh.current.CFrame = rotationFrame
		end
	end)
	return Roact.createElement("Part", {
		Name = "Box",
		[Roact.Ref] = mesh,
		Material = Enum.Material.Rock,
		Size = Vector3.new(2, 2, 2),
		Color = Color3.new(math.random(), math.random(), math.random()),
		Reflectance = 0.3,
	})
end

local function AnimatedSpikes()
	return Array.map(Array.create(SPIKE_AMOUNT, 0), function(_, i)
		return Roact.createElement(Box, { key = i })
	end)
end

local function Dolly(props)
	-- const { clock, camera } = useThree()
	local t = os.clock()
	local function elapsedTime()
		return os.clock() - t
	end
	useFrame(function()
		if props.canvasRef.current then
			props.canvasRef.current.CFrame = CFrame.new(
				Vector3.new(0, 0, 6 + math.sin(elapsedTime() * 3) * 2),
				Vector3.new(0, 0, 0)
			)
		end
	end)
	return Roact.createElement(DivLike)
end

local App = function()
	local canvasRef = useRef()
	return Roact.createElement(
		"ScreenGui",
		nil,
		Roact.createElement(DivLike, nil, {
			Roact.createElement(Canvas, {
				ref = canvasRef,
			}, {
				Roact.createElement(Blocks),
				Roact.createElement(AnimatedSpikes),
				Roact.createElement(Dolly, { canvasRef = canvasRef }),
			}),
			Roact.createElement(FPS),
		})
	)
end

return {
	Concurrent = App,

	Block = Block,
	Blocks = Blocks,
	FPS = FPS,
	Box = Box,
	AnimatedSpikes = AnimatedSpikes,
	Dolly = Dolly,
}
