
local function create()
	local entity = {}
	
	entity.x = 0
	entity.y = 0

	entity.state = {}
	entity.state.active = true
	entity.state.render = true
	entity.state.renderlayers = 1

	function entity:construct(params)
		self.x = params.x or self.x
		self.y = params.y or self.y

		return self
	end

	function entity:update(dt)

	end

	function entity:fixedUpdate(timestep)

	end

	function entity:render()

	end

	function entity:destroy()
		
	end

	function entity:onDestroy()
		
	end

	return entity
end

entities.add("entity", create)