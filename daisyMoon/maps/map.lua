
local function load()
	local map = {}

	map.players = {}
	map.platforms = {}

	map.state = {}
	map.state.render 		= true
	map.state.update 		= true
	map.state.fixedUpdate 	= true

	local playerId = 1
	local platformId = 1

	local function createPlayer(x, y)
		local player = entities.create("player", {x = x, y = y})

		player.id = playerId

		map.players[playerId] = player

		playerId = playerId + 1
	end

	local function createPlatform(x, y, w, h)
		local platform = entities.create("platform", {x = x, y = y, w = w, h = h})

		platform.id = platformId

		map.platforms[platformId] = platform

		platformId = platformId + 1
	end

	function map.load()
		createPlayer(25, 25)

		for i=0, 4, 1 do
			createPlatform(-128 * 1.5 - 256 + 64 * i, 64 * i, 128, 10)
			createPlatform(128 * 1.5 - 64, 86 * i, 128, 10)
		end

		for i=0, 3, 1 do
			createPlatform(-64, 64 * i * 2, 128, 10)
		end

		createPlatform(-1680 / 2, 1050 / 2 - 64, 1680, 24)

		createPlatform(750, 0 / 2, 24, 1050 / 2 - 128)
		createPlatform(-750, 0 / 2, 24, 1050 / 2 - 128)
	end

	function map.update(dt)

	end

	return map
end

mapsystem.add("map", load)