
math.randomseed(os.time())

dofile("lib/lib.lua")
dofile("gamestate.lua")
dofile("settings.lua")
dofile("gamedata.lua")
dofile("mapsystem.lua")
dofile("entities.lua")

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


local function mainInit()
	video.enablePostProcessing(2)

	daisy.setWindowTitle("Strikewatch - Catlinman")

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

	gamestate.addRenderState("render", renderLayers)

	--After all of this is done, set the games gamestate to the start state which we created before
	gamestate.setState("launch")

	--Setup the garbage collection cycles
	collectgarbage("setstepmul", 200)
	collectgarbage("setpause", 105)	
end
hook.add("gameInit", mainInit)


local function mainUpdate(dt)
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
end
hook.add("frameUpdate", mainUpdate)


local function mainRender()
	gamestate.render()
end
hook.add("frameRender", mainRender)


local function keyPressed(keycode)
	keys.press(keycode)
end
hook.add("keyPress", keyPressed)


local function mousePress(x, y, button, clickAmount)
	mouse.press(x, y, button, clickAmount)
end
hook.add("mouseButton", mousePress)


--This should be done in a better way but as for now it works just fine.
function renderLayers()
	mapsystem.render("bg")
	entities.render("bg")

	mapsystem.render("mg")
	entities.render("mg")

	mapsystem.render("fg")
	entities.render("fg")

	mapsystem.render("gui")
end


local function joystickButtonHasBeenPressed(joy, btn)
	print("joystick "..joy.. " button "..btn.. " pressed.")
end
hook.add("joystickButtonPressed", joystickButtonHasBeenPressed)