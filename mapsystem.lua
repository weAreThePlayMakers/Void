
--[[

	WARNING: There are currently a ton of issues with the mapsystem.
	--> New maps are loaded on top of others making it hard for the system to handle entities bound to maps.
	--> The overlay argument needs more work.
	--> Maps are currently not handling collision for the entities
	--> Maps are currently saved and loaded in the form of a lua file. A complete rewrite is in order to fix this issue.


	Also, because this whole system is currently being rewritten there is no way that it will work in its current state.
	It is being rewritten to load compact byte based maps instead of lua files which means that a lot of functionality for this
	implementation is still missing. At the same time, traditional maps can no longer be loaded.
]]

mapsystem = {}

local mapPath = settings.paths.maps
local database = {}
local loaded = {}
local current = {}

function mapsystem.add(name, data)
	if not database[name] then
		database[name] = data
	end
end

function mapsystem.construct(data)
	local sortedData = {}

	-- Interpret the data here.

	return entities.create("world", sortedData)
end

function mapsystem.load(name)
	if database[name] then
		if loaded.name ~= name then
			local startTime = os.time()

			local map = mapsystem.construct(database[name])
			
			if not map then
				if settings.debug == true then
					print("Mapsystem: Error loading the map with the name of '" ..name ..".")

					return
				end
			end

			if not map.name then
				map.name = name
			end

			if settings.debug == true then
				print("Mapsystem: Successfully loaded the map with the name of " ..name .."'")
				print("Mapsystem: The map took '" ..os.time() - startTime .."' seconds to load.")
			end

			current = map
			loaded[map.name] = map

			return true
		else
			return false
		end
	else
		if settings.debug == true then
			print("Mapsystem: The map with the name of '" ..name .."' was not found. Make sure that it has been correctly added to the map database.")
		end

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
	if current.state then
	--for i, map in pairs(loaded) do
		if current.state.update ~= nil then
			if current.state.update == true then
				if current.update then
					current.update(dt)
				end
			end
		else
			if current.update then
				current.update(dt)
			end
		end
	--end
	end
end

function mapsystem.fixedUpdate(timestep)
	if current.state then
	--for i, map in pairs(loaded) do
		if current.state.fixedUpdate ~= nil then
			if current.state.fixedUpdate == true then
				if current.fixedUpdate then
					current.fixedUpdate(timestep)
				end
			end
		else
			if current.fixedUpdate then
				current.fixedUpdate(timestep)
			end
		end
	--end
	end
end

function mapsystem.draw(layerID, layerName)
	if current.state then
	--for i, map in pairs(loaded) do
		if current.state.draw ~= nil then
			if current.state.draw == true then
				if current.draw then
					current.draw(layerName)
				end
			end
		else
			if current.draw then
				current.draw(layerName)
			end
		end
	--end
	end
end

function mapsystem.getCurrent()
	return current
end

--[[ These function are disable for now - we can only have one loaded map at a time for now.

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

]]