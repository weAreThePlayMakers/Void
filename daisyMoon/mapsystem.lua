
mapsystem = {}

local mapPath = settings.paths.maps
local database = {}
local loaded = {}
local current = {}

function mapsystem.add(name, func)
	if not database[name] then
		database[name] = func
	end
end

function mapsystem.load(name)
	if database[name] then
		local startTime = os.time()

		map = database[name]()

		if not map then
			print("Mapsystem: Error loading the map with the name of '" ..name .."' due to the map not being returned after loading it.")
			return
		end

		if not map.name then
			map.name = name
		end

		if map.load then
			current = map

			loaded[map.name] = map
			
			map.load()
		else
			print("Mapsystem: The map with the name of '" ..name .."' does not contain a load function and will be ignored.")
		end

		return true

		--print("Mapsystem: Successfully loaded the map with the name of " ..name .."'")
		--print("Mapsystem: The map took '" ..os.time() - startTime .."' seconds to load.")
	else
		print("Mapsystem: The map with the name of '" ..name .."' was not found. Make sure that it has been correctly added to the map database.")

		return false
	end
end

function mapsystem.unload(name, unloadAssets)
	if loaded[name] then
		if unloadAssets == true then
			if loaded[name].data then
				gamedata.unloadSet(loaded[name].data)
			end
		end

		entities.removeByMap(name)

		loaded[name] = nil

		print("Mapsystem: Successfully unloaded the map with the name of '" ..name .."'")
	else
		print("Mapsystem: The map with the name of '" ..name "' is not in the list of loaded maps.")
	end
end

function mapsystem.update(dt)
	for i, map in pairs(loaded) do
		if map.update then
			map.update(dt)
		end
	end
end

function mapsystem.fixedUpdate(timestep)
	for i, map in pairs(loaded) do
		if map.fixedUpdate then
			map.fixedUpdate(timestep)
		end
	end
end

function mapsystem.render(layer)
	for i, map in pairs(loaded) do
		if map.render then
			map.render(layer)
		end
	end
end

function mapsystem.getCurrent()
	return current
end

function mapsystem.getAll()
	local maps = {}

	for i, map in pairs(loaded) do
		maps[map.name] = map
	end

	return maps
end

function mapsystem.getByName(name)
	if loaded[name] then
		return loaded[name]
	else
		print("Mapsystem: The map with the name of " ..name .." was not found in the loaded maps table.")
	end
end

--Returns the names of the loaded and cached maps.
function mapsystem.getLoadedNames()
	local nametable = {}

	for i, map in pairs(loaded) do
		nametable[i] = map.name
	end

	return nametable
end

function mapsystem.getCachedNames()
	local nametable = {}

	for i, map in pairs(database) do
		map.name = nametable[i]
	end

	return nametable
end