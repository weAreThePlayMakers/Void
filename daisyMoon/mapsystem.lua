
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

function mapsystem.load(name, overlay)
	if database[name] then
		if loaded.name ~= name then
			local startTime = os.time()

			map = database[name]()
			
			if not map then
				if settings.debug == true then
					print("Mapsystem: Error loading the map with the name of '" ..name .."' due to the map not being returned after loading it.")

					return
				end
			end

			if not map.name then
				map.name = name
			end

			--Yes, amazing if statements - I am well aware of this crap.

			if map.load then
				if overlay then
					if overlay == false then
						current = map
					end
				else
					current = map
				end

				loaded[map.name] = map
						
				map.load()
			else
				if settings.debug == true then
					print("Mapsystem: The map with the name of '" ..name .."' does not contain a load function and will be ignored.")
				end
			end

			if settings.debug == true then
				print("Mapsystem: Successfully loaded the map with the name of " ..name .."'")
				print("Mapsystem: The map took '" ..os.time() - startTime .."' seconds to load.")
			end

			return true
		else
			return false
		end
	else
		--print("Mapsystem: The map with the name of '" ..name .."' was not found. Make sure that it has been correctly added to the map database.")

		return false
	end
end

function mapsystem.unload(name, unloadAssets)
	if loaded[name] then
		if loaded[name].unload then
			loaded[name].unload()
		end

		if unloadAssets == true then
			if loaded[name].data then
				gamedata.unloadSet(loaded[name].data)
			end
		end

		entities.removeByMap(name)

		loaded[name] = nil

		if settings.debug == true then
			print("Mapsystem: Successfully unloaded the map with the name of '" ..name .."'")
		end
	else
		if current.name then
			if current.unload then
				current.unload()
			end

			if unloadAssets == true then
				if current.data then
					gamedata.unloadSet(current.data)
				end
			end

			entities.removeByMap(current.name)

			loaded[current.name] = nil
		end
	end
end

function mapsystem.update(dt)
	for i, map in pairs(loaded) do
		if map.state.update ~= nil then
			if map.state.update == true then
				if map.update then
					map.update(dt)
				end
			end
		else
			if map.update then
				map.update(dt)
			end
		end
	end
end

function mapsystem.fixedUpdate(timestep)
	for i, map in pairs(loaded) do
		if map.state.fixedUpdate ~= nil then
			if map.state.fixedUpdate == true then
				if map.fixedUpdate then
					map.fixedUpdate(timestep)
				end
			end
		else
			if map.fixedUpdate then
				map.fixedUpdate(timestep)
			end
		end
	end
end

function mapsystem.render(layerID, layerName)
	for i, map in pairs(loaded) do
		if map.state.render ~= nil then
			if map.state.render == true then
				if map.render then
					map.render(layerName)
				end
			end
		else
			if map.render then
				map.render(layerName)
			end
		end
	end
end

function mapsystem.getCurrent()
	return current
end

function mapsystem.getAll()
	return loaded
end

function mapsystem.getByName(name)
	if loaded[name] then
		return loaded[name]
	else
		if settings.debug == true then
			print("Mapsystem: The map with the name of " ..name .." was not found in the loaded maps table.")
		end
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