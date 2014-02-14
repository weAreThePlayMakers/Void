
mouse = {}

local pressedx = 0
local pressedy = 0

local lastKeycode = -1
local mouseKeyGroup = {}
local mousePressedThisUpdate = false

--We can use this function to add keys to the table of mousekeys.
function mouse.addKey(name, keycode)
	if(not mouseKeyGroup[name]) then
		local mouseKey = {}

		mouseKey.name = name
		mouseKey.keycode = keycode

		mouseKey.pressed = false

		mouseKeyGroup[mouseKey.name] = mouseKey
	else
		mouseKeyGroup[name].keycode[table.getn(mouseKeyGroup[name].keycode) + 1] = keycode
	end
end

--Same goes for this function with the difference that it removes keys from the mousekey table.
function mouse.popKey(name)
	if mouseKeyGroup[name] then
		mouseKeyGroup[name] = nil
	else
		print("The mouse key with the name of " ..name .." was not found.")
	end
end

--Mouse.press is used to register mouse presses. It should be called in the games main.lua/mousePress function.
function mouse.press(x, y, keycode)
	pressedx = x
	pressedy = y
	lastKeycode = keycode

	for i, mouseKey in pairs(mouseKeyGroup) do
		if(keycode == mouseKey.keycode) then
			mouseKey.pressed = true

			return
		end
	end
end

--Mouse.release releases all keys in the mouseKeys table if they aren't pressed any longer.
--This function should be called done every update.
function mouse.release()
	for i, mouseKey in pairs(mouseKeyGroup) do
		if not love.mouse.isDown(mouseKey.keycode) then
			mouseKey.pressed = false
		end
	end

	if not love.mouse.isDown(lastKeycode) then
		lastKeycode = -1
	end
end

--The core of the whole system. Calling this function returns a boolean value of true if the mousekey with the specified name is pressed.
function mouse.check(name)
	if mouseKeyGroup[name] then
		return mouseKeyGroup[name].pressed
	end
end

--This function checks if any of the registered keys are being pressed at the moment.
function mouse.checkAny()
	for i, mouseKey in pairs(mouseKeyGroup) do
		if mouseKey.pressed then
			return mouseKey.keycode
		end
	end

	return -1
end

--Use this function to check if a key was pressed even if it is not in the table of registered keys.
function mouse.checkKeycode()
	return lastKeycode
end

function mouse.getClickedPosition()
	return pressedx, pressedy
end

function mouse.getPosition()
	return love.mouse.getPosition()
end

function mouse.getRelativePosition()
	local cx, cy = camera.getPosition()
	local x, y = love.mouse.getPosition()
	return x + cx - _w / 2, y + cy - _h / 2
end

function mouse.getRelativeClickedPosition()
	local cx, cy = camera.getPosition()
	return mouse.x + cx - _w / 2, mouse.y + cy - _h / 2
end