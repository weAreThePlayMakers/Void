
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
		-- Entities can call this function to let their collision get handled by the world.
		-- Do quadtree collision checking here.

		-- Convert the different collision types and then check them against eachother.
		-- First perform static collision checking and then dynamic collision checking.

		if collider.collisionType == "box" then

		elseif collider.collisionType == "circle" then

		elseif collider.collisionType == "mesh" then

		elseif collider.collisionType == "pixel" then

		elseif collider.collisionType == "ray" then

		end
	end

	function world:construct(data)
		if data then
			-- We handle the data supplied here. Data is interpreted and given by mapsystem.lua

			self.name = data.name 			-- String 	-> Name of the map
			self.author = data.author		-- String 	-> Author of the map
			self.gametype = data.gametype	-- Table 	-> The gametypes that this map will show up under
			self.cdate = data.cdate			-- String	-> The date on which the map was created
			self.objects = data.objects 	-- Table 	-> Contains all the different objects to be drawn each frame
			self.colliders = data.colliders	-- Table 	-> Contains the colliders

			self:createQuadTree()
		end
	end

	-- Draw all the worlds static objects.
	function world:draw()
		for i, obj in pairs(self.objects) do
			if obj.type == "rect" then
				love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
				love.graphics.rectangle("fill", obj.x, obj.y, obj.w, obj.h)

			elseif obj.type == "circle" then
				love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
				love.graphics.circle("fill", obj.x, obj.y, obj.r, 64)

			elseif obj.type == "image" then
				love.graphics.setColor(obj.red, obj.green, obj.blue, obj.alpha)
				love.graphics.draw(obj.img, obj.x, obj.y, obj.rot, obj.sx, obj.sy)
			end
		end
	end

	print("ASJKDHJKASDHJKLADS")

	return world
end

entities.add("world", create)