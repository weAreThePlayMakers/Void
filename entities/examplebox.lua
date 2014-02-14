
local function create()
	local box = entities.extend("entity")

	box.nextx = box.x
	box.nexty = box.y

	box.w = 32
	box.h = 32

	box.color = color.createRGBA(255, 0, 0, 255)

	function box:construct(params)
		-- We take the parameters from the base entity...
		self.x = params.x or self.x
		self.y = params.y or self.y

		-- ...and add new ones for the w and h variables.
		self.w = params.w or self.w
		self.h = params.h or self.h

		return self
	end

	function box:update(dt)
		if mouse.check("lpress") then
			local x, y = mouse.getRelativePosition()

			if collision.boxContains(x, y, self.x, self.y, self.w, self.h) then

				-- Just some retarded test code
				self.nextx = self.nextx + math.randomFloat(-50, 50)
				self.nexty = self.nexty + math.randomFloat(-50, 50)

				self.nextx = math.clamp(self.nextx, -_w / 2, _w / 2)
				self.nexty = math.clamp(self.nexty, -_h / 2, _h / 2)
			end
		end

		self.x = math.lerp(self.x, self.nextx, dt)
		self.y = math.lerp(self.y, self.nexty, dt)
	end

	function box:draw()
		love.graphics.setColor(self.color)

		love.graphics.print("Click me", self.x, self.y - 16)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end

	return box
end

entities.add("examplebox", create)