-- upstream: https://github.com/pmndrs/react-three-fiber/blob/v5.3.19/examples/src/demos/dev/Concurrent.js

local rootWorkspace = script.Parent.Parent.Parent
local Packages = rootWorkspace.Packages
local Roact = require(Packages.Roact)
local useState = Roact.useState
local useEffect = Roact.useEffect
local useRef = Roact.useRef
local LuauPolyfill = require(Packages.LuauPolyfill)
local Object = LuauPolyfill.Object
local setTimeout = LuauPolyfill.setTimeout
local jsutils = require(script.Parent.Parent.jsutils)
local setInterval, clearInterval = jsutils.setInterval, jsutils.clearInterval
-- ROBLOX TODO: replace deep import when Rotriever handles submodules
local Scheduler = require(Packages._Index.roact.roact.Scheduler)
local low, run = Scheduler.unstable_LowPriority, Scheduler.unstable_runWithPriority

local useFrame = require(script.Parent.useFrame).useFrame
local DivLike = require(script.Parent.DivLike).DivLike
local Mesh = require(script.Parent.Mesh).Mesh

-- ROBLOX deviation: because os.clock() returns a nr in seconds it's easier to
-- use slowdown in seconds as well
local SLOWDOWN = 1 / 1000
local ROW = 20
local BLOCK_AMOUNT = 600
local SPIKE_AMOUNT = 1000

local geom = {} -- new BoxBufferGeometry(1, 1, 1)
local matr = {} -- new MeshNormalMaterial()

local rpi = function()
	return math.random() * math.pi
end

local function Block(props)
	local change, restProps = props.change, Object.assign({}, props, { change = Object.None })

	local color, set = useState(0)

	-- Artificial slowdown ...
	if color > 0 then
		local e = os.clock() + SLOWDOWN
		repeat
		until not os.clock() < e
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
				if mounted.current then
					set(math.round(math.random() * 0xffffff))
				end
			end, math.random() * 1000)
		end
	end, {
		change,
	})

	return Roact.createElement(Mesh, nil) -- TODO use Roblox components for mesh
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
end

local function FPS(props)
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

	return Roact.createElement("TextLabel", Object.assign({}, props, { Text = "...", ref = ref }))
end

local App = function(props)
	local count, setCount = useState(0)

	local buttonActivated = function()
		setCount(count + 1)
		print("activated")
		print(count)
	end

	return Roact.createElement(
		"ScreenGui",
		nil,
		Roact.createElement(DivLike, nil, {
			Roact.createElement(FPS, {
				Size = UDim2.new(0, 100, 0, 100),
				Position = UDim2.new(0, 200, 0, 0),
				AnchorPoint = Vector2.new(0, 0),
			}),
			Roact.createElement("TextButton", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(1, -200, 0, 0),
				AnchorPoint = Vector2.new(1, 0),
				Text = "Stop",
				[Roact.Event.Activated] = props.Stop,
			}),
			Roact.createElement("TextButton", {
				Size = UDim2.new(0, 100, 0, 50),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				Text = "Toggle " .. tostring(count),
				[Roact.Event.Activated] = buttonActivated,
			}),
			count % 2 == 0 and Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 400, 0, 300),
				Position = UDim2.new(0.25, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "Hello, Roact1!",
			}) or Roact.createElement("TextLabel", {
				Size = UDim2.new(0, 400, 0, 300),
				Position = UDim2.new(0.75, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Text = "Hello, Roact2!",
			}),
		})
	)
end

return App
