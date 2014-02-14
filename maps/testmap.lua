
function loadLevel()
	local map = {}

	-- These states are required by the mapsystem by default.
	map.state = {}
	map.state.draw	 		= true
	map.state.update 		= true
	map.state.fixedUpdate 	= true

	function map:load()
		entities.create("examplebox")
	end

	function map:update(dt)

	end

	function map:fixedUpdate(timestep)

	end

	function map:draw(layer)

	end

	return map
end

mapsystem.add("testmap", loadLevel)