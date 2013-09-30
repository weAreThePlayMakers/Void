
local function create()
	local player = entities.extend("entity")

	--These should be handled by the size of the sprite in perticular
	player.w = 24
	player.h = 24

	player.speed = 1

	--Direction Vectors -> Used for the direction of movement
	--These are used to interpolate the velocity vectors to
	player.dx = 0
	player.dy = 0

	--Velocity vectors -> Used for physics calculations
	--These are the vectors that are used for the final movement
	player.vx = 0
	player.vy = 0

	player.grounded = false

	player.color = color.white

	function player:construct(params)
		if params.x then self.x = params.x end
		if params.y then self.y = params.y end

		--Currently we need to center the player as he does not use a centered sprite
		self.x = self.x - self.w
		self.y = self.y - self.h

		return self
	end

	function player:update(dt)
		--Do movement here
		if keys.check("left") then
			self.dx = -1
		elseif keys.check("right") then
			self.dx = 1
		else
			self.dx = 0
		end

		if keys.check("up") then
			if self.grounded then
				--We directly set the velocity to 1 for an impulse like effect
				--TODO: Remove the dependency of dy from vy

				self.dy = -0.75
				self.vy = -0.75
			end
		else
			self.dy = 0
		end

		--Not really physics but its a start
		self.vx = math.lerp(self.vx, self.dx, dt)

		if self.grounded then
			self.vy = math.lerp(self.vy, self.dy, dt)
		else
			self.vy = math.lerp(self.vy, 9.81 / 10, dt)
		end

		self.x = self.x + self.vx
		self.y = self.y + self.vy
	end

	function player:fixedUpdate(timestep)

		--Do collision handling here
		--The platform collision should be handled in a more local way but for know it should do
		for i, platform in pairs(self.map.platforms) do

			--We first assume that the player is not grounded
			self.grounded = false

			--Check if the player is colliding with the current platform
			if collision.box(self.x, self.y, self.w, self.h, platform.x, platform.y, platform.w, platform.h) then

				--Check from which direction the player is colliding and do the neccessary collision resolution
				if self.y - self.h < platform.y - self.h then
					self.grounded = true
					self.vy = 0
					self.y = platform.y - self.h

				elseif self.y > platform.y - platform.h then
					self.vy = 0
					self.y = platform.y + platform.h
				end

				--TODO: Handle x collision

				return
			end
		end
	end

	function player:render(layer)
		if layer == "fg" then
			local x, y = camera.translate(self.x, self.y)
			video.renderRectangle(x, y, self.w, self.h, self.color.a, self.color.r, self.color.g, self.color.b)
		end
	end

	function player:destroy()

	end

	return player
end

entities.add("player", create)