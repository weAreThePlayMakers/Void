
local function create()
	local entity = {}
	
	-- Some base variables which are almost always used by child entities.
	entity.x = 0
	entity.y = 0

	-- The entity state table contains information used to determine certain states of the entity.
	entity.state = {}
	entity.state.active = true 	-- If false the entity will not be updated.
	entity.state.draw = true	-- If false the entity will not be drawn.

	-- Layers are based on an id system defined in the gamestate file. Either a single number or a table of numbers can be used.
	entity.state.drawStack = 1

	-- The construct method is called by the entity system on creation. It takes in a table of parameters which can then be indiviually handled here.
	function entity:construct(params)
		self.x = params.x or self.x
		self.y = params.y or self.y

		return self
	end

	-- Updates the entity each possible frame.
	function entity:update(dt)

	end

	-- Updates the entity with a set time between frames. More stable but not as smooth.
	function entity:fixedUpdate(timestep)

	end

	-- Our draw method. We do drawing here.
	function entity:draw()
		
	end

	-- Called when the entity is destroyed by the entity system.
	function entity:onDestroy()
		
	end

	return entity
end

-- We add the entity to our list of entities and supply it our create function.
entities.add("entity", create)