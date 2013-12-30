
entities = {}

local entitiesPath = settings.paths.entities
local objects = {}
local database = {}
local id = 0

local renderlayers = {}

--Here are some predefined renderlayers:
renderlayers[1] = "background"
renderlayers[2] = "midground"
renderlayers[3] = "forground"
renderlayers[4]	= "gui"
renderlayers[5] = "gui2"

--Use this function to add new files to the entity register. Should be done at the end of newly loaded files.
function entities.add(type, func)
	if not database[type] then
		database[type] = func
	end
end

--Entities.create is used to instantiate new entities. 
function entities.create(type, params, ignoreStates, grouping)
	if(database[type]) then
		local entity = database[type]()

		if entity ~= nil then
			entity.type = type
			

			if mapsystem then
				if grouping == nil then
					entity.map = mapsystem.getCurrent()
				else
					entity.map = {name = grouping}
				end
			else
				--Simply a placeholder if there is no mapsystem.
				entity.map = {name = "default"}
			end

			if entity.construct then
				if params then 
					entity:construct(params)
				else
					entity:construct({})
				end
			else
				if settings.debug == true then
					print("Entitysystem: The entity with the type of '" ..type .."' does not have a construct function.")
				end
			end

			id = id + 1
			entity.id = id

			objects[id] = entity

			if ignoreStates then
				entity.ignoreStates = ignoreStates
			else
				entity.ignoreStates = false
			end

			return objects[id]
		else
			if settings.debug == true then
				print("Entitysystem: There was a problem loading the entity with the type of '" ..type .."' -- Make sure the entity is actually returned at the end of its instantiation function.")
				return nil
			end
		end
	else
		if settings.debug == true then
			print("Entitysystem: The enitity with the type of '" ..type .."' could not be created. Make sure that it has been added to the database before creating it.")
		end
	end
end

--This can be used to create new entities without making them show up in the game.
--The main purpose is to be able to create new entities in another entity and to extend its functionality.

function entities.extend(type)
	if(database[type]) then
		entity = database[type]()

		return entity
	end
end

--Entities can be removed from the game by using either one of these functions. It should be taken into respect that remove entities by map
--should be used in combination with the mapsystem file. Otherwise all entities will be assigned to a default map. This means that if there
--is no mapsystem in place and the removeByMap function is called all entities will be destroyed.

function entities.destroy(entity, silent)
	if not silent then entity:onDestroy() end

	entity.active = false
	objects[entity.id] = nil
end

function entities.removeByMap(mapname)
	for i, ent in pairs(objects) do
		if objects[i].map.name == mapname then
			entities.destroy(ent, true)
		end
	end
end

--These functions should be called from the given loops in the main.lua.
function entities.update(dt)
	for i, ent in pairs(objects) do
		if ent.ignoreStates == false then
			if ent.state.active == true then
				if ent.map.state.update == true then
					ent:update(dt)
				end
			end
		else
			ent:update(dt)
		end
	end
end

function entities.fixedUpdate(timestep)
	for i, ent in pairs(objects) do
		if ent.ignoreStates == false then
			if ent.state.active == true then
				if ent.map.state.fixedUpdate == true then
					ent:fixedUpdate(timestep)
				end
			end
		else
			ent:fixedUpdate(timestep)
		end
	end
end

function entities.render(layerID, layerName)
	for i, ent in pairs(objects) do
		local t = type(ent.state.renderlayers)

		if t ~= "table" then
			if ent.state.renderlayers == layerID or ent.state.renderlayers == layerName then
				if ent.ignoreStates == false then
					if ent.state.render then
						if ent.map.state.render == true then
							ent:render(layerName)
						end
					end
				else
					ent:render(layerName)
				end
			end
		else
			for n, l in pairs(ent.state.renderlayers) do
				if l == layerID or l == layerName then
					if ent.ignoreStates == false then
						if ent.state.render then
							if ent.map.state.render == true then
								ent:render(layerName)
							end
						end
					else
						ent:render(layerName)
					end
				end
			end
		end
	end
end