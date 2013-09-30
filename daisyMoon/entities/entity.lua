
local function create()
	local entity = {}
	
	entity.x = 0
	entity.y = 0
	entity.state = {}
	entity.state.active = true
	entity.state.render = true

	function entity:construct(params)
		if params.x then self.x = params.x end
		if params.y then self.y = params.y end

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

	return entity
end

entities.add("entity", create)