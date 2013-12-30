
local function create()
	local point = entities.extend("entity")

	point.size = 0.1
	point.rot = 0

	point.sprite = gamedata.get("circle")
	point.w, point.h =  video.getSpriteStateSize(point.sprite)

	point.color = color.white

	point.state.renderlayers = 3

	function point:construct(params)
		self.x = params.x or self.x
		self.y = params.y or self.y

		self.color = params.color or self.color

		self.size = params.size or self.size

		self.rot = params.rot or self.rot

		self.sprite = params.sprite or self.sprite

		return self
	end

	function point:render(layer)
		if layer == "foreground" then
			local x, y = camera.translate(self.x, self.y)

			video.renderSpriteState(self.sprite, x, y, self.size, self.rot, self.color.a, self.color.r, self.color.g, self.color.b)
		end
	end

	return point
end

entities.add("debug_point", create)