
math.randomseed(os.time())

dofile("lib/lib.lua")

dofile("settings.lua")
dofile("gamestate.lua")
dofile("gamedata.lua")
dofile("entities.lua")
dofile("mapsystem.lua")

dofile("files.lua")

--These values should not be changed at any point
_time = 0
_timescale = 1
_dt = 0.01
_cachedTime = 0
_timestep = 0.015

--These value can be changed from inside the game. For user based audio changing use the settings file.
_audio = {}
_audio.pitch = 1
_audio.volume = 1

_running = true

_w, _h = video.getScreenSize()

local function mainInit()
	video.enablePostProcessing(2)

	daisy.setWindowTitle("VOID - Version 0.01")

	--Register all required keys and assign the different keycode combinations
	keys.addKey("up", 38)
	keys.addKey("down", 40)
	keys.addKey("left", 37)
	keys.addKey("right", 39)

	--Register all required mouse buttons
	mouse.addKey("fire", 0)

	--Create two base game states which will serve as entry and exit points inside the game.
	--We also give them some hooks to better handle game events.
	gamestate.addState("launch")
	gamestate.addStartHook("launch", mapsystem.load, "map")

	gamestate.addState("quit")
	gamestate.addStartHook("quit", mapsystem.unload, "map")

	--Finally add the update and render functions to the gamestate stacks
	gamestate.addUpdateState("entities", entities.update)
	gamestate.addUpdateState("mapsystem", mapsystem.update)

	gamestate.addFixedUpdateState("entities", entities.fixedUpdate)
	gamestate.addFixedUpdateState("mapsystem", mapsystem.fixedUpdate)

	gamestate.addRenderState(1, 1, "background", entities.render)
	gamestate.addRenderState(2, 1, "background", mapsystem.render)

	gamestate.addRenderState(3, 2, "midground", entities.render)
	gamestate.addRenderState(4, 2, "midground", mapsystem.render)

	gamestate.addRenderState(5, 3, "foreground", entities.render)
	gamestate.addRenderState(6, 3, "foreground", mapsystem.render)

	gamestate.addRenderState(7, 4, "gui", entities.render)
	gamestate.addRenderState(8, 4, "gui", mapsystem.render)

	gamestate.addRenderState(9, 5, "gui2", entities.render)
	gamestate.addRenderState(10, 5, "gui2", mapsystem.render)

	--After all of this is done, set the games gamestate to the start state which we created before
	gamestate.setState("launch")

	--Setup the garbage collection cycles
	collectgarbage("setstepmul", 200)
	collectgarbage("setpause", 105)	
end
hook.add("gameInit", mainInit)


local function mainUpdate(dt)
	if dt < 0.05 then
		if _running then
			_dt = dt

			_time = _time + dt

			audio.setGlobalPitch(_audio.pitch)

			gamestate.update(dt)

			_cachedTime = _cachedTime + dt

			while _cachedTime >= _timestep do
				
				_cachedTime = _cachedTime - _timestep
				gamestate.fixedUpdate(_timestep)
			end

			keys.release()
			mouse.release()

			collectgarbage()
		else
			daisy.exitGame()
		end
	end
end
hook.add("frameUpdate", mainUpdate)


local function mainRender()
	gamestate.render()
end
hook.add("frameRender", mainRender)


local function keyPressed(keycode)
	if settings.debug == true then
		if keycode == 46 then
			daisy.clearPrint()
		end
	end

	keys.press(keycode)
end
hook.add("keyPress", keyPressed)


local function mousePress(x, y, button, clickAmount)
	mouse.press(x, y, button, clickAmount)
end
hook.add("mouseButton", mousePress)


local function joystickButtonHasBeenPressed(joy, btn)
	print("joystick "..joy.. " button "..btn.. " pressed.")
end
hook.add("joystickButtonPressed", joystickButtonHasBeenPressed)