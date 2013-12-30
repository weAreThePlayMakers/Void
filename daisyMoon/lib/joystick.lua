
joystick = {}

local lastButton = 0
local buttongroup = {}

--We can use this function to add buttons to the table of buttons.
function joystick.addButton(name, button, controller)
	if(not buttongroup[name]) then
		button = {}

		button.name = name
		button.button = {}
		button.button[1] = button

		button.pressed = false

		buttongroup[button.name] = button
	else
		buttongroup[name].button[table.getn(buttongroup[name].button) + 1] = button
	end
end

--Does the same as the function above but instead removes buttons from the buttons table.
function joystick.popKey(name)
	if(buttongroup[name]) then
		buttongroup[name] = nil
	end
end

--This function should be called from the main.lua/keyPressed hook function.
function joystick.press(button)
	lastButton = button

	for i, button in pairs(buttongroup) do
		for k, code in pairs(button.button) do
			if(code == button) then
				button.pressed = true

				return
			end
		end
	end
end

--The most important function. When it is called it checks if any of the buttons in the table of registered buttons is being pressed.
--If they are not being pressed any longer it will change their pressed state to false.
--This function should be called done every update.
function joystick.release()
	for i, button in pairs(buttongroup) do
		stillpressed = false

		for k, code in pairs(button.keycode) do
			if daisy.isKeyPressed(code) then
				stillpressed = true
				break
			end
		end

		if stillpressed then
			button.pressed = true 
		else
			button.pressed = false
		end
	end

	if lastButton then
		if not daisy.isKeyPressed(lastButton) then
			lastButton = 0
		end
	end
end

--Calling this function returns a boolean value of true if the button with the specified name is pressed.
function joystick.check(name, controller)
	if(buttongroup[name]) then
		if controller then
			if buttongroup[name].controller == controller then
				return buttongroup[name].pressed
			end
		end

		return buttongroup[name].pressed
	end
end

--This function checks if there is any button being pressed at the moment.
function joystick.checkAny()
	for i, button in pairs(buttongroup) do
		if button.pressed then
			return true
		end
	end

	return false
end

--Use this function to check if a button was pressed even if it is not in the table of registered buttons.
function joystick.checkKeycode()
	return lastButton
end

--This function checks the amount of buttons pressed.
function joystick.getPressedNum()
	count = 0
	for i, button in pairs(buttongroup) do
		if(button.pressed) then count = count + 1 end
	end

	return count
end	