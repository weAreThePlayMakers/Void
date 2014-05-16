
entities = {}

local entitiesPath = settings.paths.entities
local database = {}
local objects = {}
local id = 0

local drawStack = {}

-- Use this function to add new files to the entity register. Should be done at the end of newly loaded files.
function entities.add(type, func)
	if not database[type] then
		database[type] = func
	end
end

-- Entities.create is used to instantiate new entities.
-- If a parent is supplied the entity will ignored by base update and draw states. More on that in further down.

function entities.create(type, params, parent)
	if database[type] then
		local entity = database[type]()

		if entity ~= nil then
			entity.type = type

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

			entity.parent = parent or nil

			id = id + 1
			entity.id = id

			objects[id] = entity

			--[[
				The entity state table contains information used to determine certain states of the entity.

				If the entity has a parent the parent takes over the entities update and draw function handling.
				This is usefull when working with world entities or particle system which maintain each of their children
				outside of the main games entity system.
			--]]

			entity.state = {}

			if entity.parent then
				entity.state.update = true 		--  If false the entity will not be updated.
				entity.state.fixedUpdate = true	--  If false the entity will not be updated in the fixed update loop.
				entity.state.draw = true		--  If false the entity will not be drawn.
			else
				entity.state.update = false
				entity.state.fixedUpdate = false
				entity.state.draw = false
			end

			-- Layers are based on an id system defined in the gamestate file. Either a single number or a table of numbers can be used.
			entity.state.drawStack = 1

			return objects[id]
		else
			if settings.debug == true then
				print("Entitysystem: There was a problem loading the entity with the type of '" ..type .."' --  Make sure the entity is actually returned at the end of its instantiation function.")
				return nil
			end
		end
	else
		if settings.debug == true then
			print("Entitysystem: The enitity with the type of '" ..type .."' could not be created. Make sure that it has been added to the database before creating it.")
		end
	end
end

--[[
	This can be used to create new entities without making them show up in the game.
	The main purpose is to be able to create new entities in another entity and to extend its functionality.
--]]

function entities.extend(type)
	if database[type] then
		entity = database[type]()

		return entity
	end
end

function entities.destroy(entity, silent)
	if not silent then entity:onDestroy() end

	entity.active = false
	objects[entity.id] = nil
end

function entities.flush()
	objects = {}
end

function entities.removeByTable(t)
	for i, ent in pairs(t) do
		if objects[t.id] then
			entities.destroy(objects[t.id], true)
		end
	end
end

-- These functions should be called from the given loops in the main.lua.
function entities.update(dt)
	for i, ent in pairs(objects) do
		if ent.ignoreStates == false and ent.update then
			if ent.state.update == true then
				ent:update(dt)
			end
		else
			ent:update(dt)
		end
	end
end

function entities.fixedUpdate(timestep)
	for i, ent in pairs(objects) do
		if ent.ignoreStates == false and ent.fixedUpdate then
			if ent.state.fixedUpdate == true then
				ent:fixedUpdate(timestep)
			end
		else
			ent:fixedUpdate(timestep)
		end
	end
end

function entities.draw(layerID, layerName)
	for i, ent in pairs(objects) do
		if ent.draw then
			local t = type(ent.state.drawStack)

			if t ~= "table" then
				if ent.state.drawStack == layerID or ent.state.drawStack == layerName then
					if ent.ignoreStates == false then
						if ent.state.draw then
							ent:draw(layerName)
						end
					else
						ent:draw(layerName)
					end
				end
			else
				for n, l in pairs(ent.state.drawStack) do
					if l == layerID or l == layerName then
						if ent.ignoreStates == false then
							if ent.state.draw then
								ent:draw(layerName)
							end
						else
							ent:draw(layerName)
						end
					end
				end
			end
		end
	end
end

-- This function is used to update the current draw stack so that entities can interface with the layer based drawing we created.

function entities.updateDrawStack(stack)
	drawStack = stack
end