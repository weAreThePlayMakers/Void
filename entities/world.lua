
local function create()
	local world = {}

	--[[
		STILL VERY VERY WIP

		We use a sepperate entities system in here so we can differentiate between static and dynamic entities.
		This should optimize collision detection a lot. It also allows us to handle collision through one central function removing the
		need for each entity to check every other entities collision against its own. Changes to collision resolution and detection 
		should be much simpler this way as well since we are rooting all collision code into one central area.
	]]

	world.objects = {}	-- Objects that simply need to be drawn go in here.
	world.colliders = {} -- Objects with collision should go in this table.
	world.quadtree = {}	-- The quadtree splits the scene into multiple parts allowing faster collision detection by the world.

	function world:createQuadTree()
		-- Construct a new quadtree here.
	end

	function world:updateQuadTree()
		-- Check quadtree dependancies for dynamic objects here and update them if neccessary.
	end

	function world:getQuadtree()
		-- Supply a certain system with the current quadtree.
	end

	-- Dynamic entities can handle their collision through this function.
	function world:handleCollision(collider)

	end

	function world:construct(data)

	end

	-- Draw all the worlds static objects.
	function world:draw()

	end

	return world
end

entities.add("world", create)