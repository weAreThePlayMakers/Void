
math.randomseed(os.time())

require("lib/lib")
require("gamestate")
require("settings")
require("gamedata")
require("entities")
require("mapsystem")
require("files")

--These values should not be changed at any point
_time = 0
_timescale = 1
_dt = 0.01
_cachedTime = 0
_timestep = 0.015

_running = true

_w, _h = love.graphics.getDimensions()

function love.load()
	gamedata.insert("testimage", love.graphics.newImage(settings.paths.gamedata .."catlinman.jpg"))

	-- We load the settings from the settings.lua file.
	settings.load()

	-- Register all required keys and assign the different keycode combinations
	keys.add("up", 38)
	keys.add("down", 40)
	keys.add("left", 37)
	keys.add("right", 39)

	mouse.add("lpress", "l")

	-- Create three base game states which will serve as entry and exit points inside the game.
	-- We also give them some hooks to better handle game events.
	gamestate.addState("launch")
	--gamestate.addStartHook("launch", mapsystem.load, "testmap")

	-- Finally add the update and draw functions to the gamestate stacks
	gamestate.addUpdateState("entities", entities.update)
	gamestate.addUpdateState("mapsystem", mapsystem.update)

	gamestate.addFixedUpdateState("entities", entities.fixedUpdate)
	gamestate.addFixedUpdateState("mapsystem", mapsystem.fixedUpdate)

	gamestate.addDrawState(1, 1, "background", entities.draw)
	gamestate.addDrawState(2, 1, "background", mapsystem.draw)

	gamestate.addDrawState(3, 2, "midground", entities.draw)
	gamestate.addDrawState(4, 2, "midground", mapsystem.draw)

	gamestate.addDrawState(5, 3, "foreground", entities.draw)
	gamestate.addDrawState(6, 3, "foreground", mapsystem.draw)

	gamestate.addDrawState(7, 4, "gui", entities.draw)
	gamestate.addDrawState(8, 4, "gui", mapsystem.draw)

	gamestate.addDrawState(9, 5, "gui2", entities.draw)
	gamestate.addDrawState(10, 5, "gui2", mapsystem.draw)

	-- Since we just created all our future draw states we can now update the entity system's stack with that of the gamestate system.
	entities.updateDrawStack(gamestate.getDrawStack())

	-- After all of this is done, set the games gamestate to the start state which we created before
	gamestate.setState("launch")

	collectgarbage("setstepmul", 200)
	collectgarbage("setpause", 105)
end

function love.update(dt)
	-- If lag gets too high we halt the game. This is not the best idea but it keeps the game more stable.
	-- TODO: Add a lagcache to check if a player is lagging too much. If this is the case -> disable the lag check.

	if dt < 0.05 then
		if _running then
			_dt = dt

			_time = _time + dt

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
			
		end
	end
end

function love.draw()

	-- Translating the camera
	love.graphics.translate(-camera.get().x / camera.get().sx + _w / 2, -camera.get().y / camera.get().sy + _h / 2)
	love.graphics.scale(1 / camera.get().sx, 1 / camera.get().sy)

	-- We reset the color before going into any actual drawing
	love.graphics.setColor(255, 255, 255, 255)

	gamestate.draw()
	for i=0, 16 do
		love.graphics.draw(gamedata.get("testimage"), -512 + (256 * i - 1), -385 + (256 * i - 1))
	end

	love.graphics.setShader()
end

function love.keypressed(keycode)
	keys.press(keycode)
end

function love.mousepressed(x, y, button)
	mouse.press(x, y, button)
end

function love.joystickpressed(joy, btn)
	joystick.press(joy, btn)
end

function love.joystickreleased(joy, btn)
	joystick.release(joy, btn)
end