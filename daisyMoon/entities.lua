
entities = {}

local entitiesPath = settings.paths.entities
local objects = {}
local database = {}
local id = 0

--Use this function to add new files to the entity register. Should be done at the end of newly loaded files.
function entities.add(type, func)
	if not database[type] then
		database[type] = func
	end
end

--Entities.create is used to instantiate new entities. 
function entities.create(type, params)
	if(database[type]) then
		local entity = database[type]()

		if entity ~= nil then
			if mapsystem then
				entity.map = mapsystem.getCurrent()
			else
				--Simply a placeholder if there is no mapsystem.
				entitiy.map = {name = "default"}
			end

			local tempEntity

			if entity.construct then
				if params then 
					tempEntity = entity:construct(params)
				else
					tempEntity = entity:construct({})
				end
			else
				print("Entitysystem: The entity with the type of '" ..type .."' does not have a construct function.")
			end

			if tempEntity ~= nil then
				entity = tempEntity
			else
				print("Entitysystem: The entity with the type of '" ..type .."' is not returned in its construct function.")
			end


			id = id + 1
			entity.id = id

			objects[id] = entity

			return objects[id]
		else
			print("Entitysystem: There was a problem loading the entity with the type of '" ..type .."' -- Make sure the entity is actually returned at the end of its instantiation function.")
			return nil
		end
	else
		print("Entitysystem: The enitity with the type of '" ..type .."' could not be created. Make sure that it has been added to the database before creating it.")
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

function entities.destroy(entity)
	entity:onDestroy()

	objects[entity.id] = nil
end

function entities.removeByMap(mapname)
	for i, ent in pairs(objects) do
		for m, map in pairs(objects[i].map) do
			if objects[i].map[m].name == mapname then
				objects[ent.id] = nil
			end
		end
	end
end

--These functions should be called from the given loops in the main.lua.
function entities.update(dt)
	for i, ent in pairs(objects) do
		if(ent.state.active == true) then
			ent:update(dt)
		end
	end
end

function entities.fixedUpdate(timestep)
	for i, ent in pairs(objects) do
		if(ent.state.active == true) then
			ent:fixedUpdate(timestep)
		end
	end
end

function entities.render(layer)
	for i, ent in pairs(objects) do
		if(ent.state.render) then
			ent:render(layer)
		end
	end
end