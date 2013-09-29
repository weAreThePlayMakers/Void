
local function create()
	local point = entities.extend("entity")

	point.size = 0.1
	point.rot = 0

	point.sprite = gamedata.get("circle")
	point.w, point.h =  video.getSpriteStateSize(point.sprite)

	point.color = color.white

	function point:construct(params)
		if params.x then self.x = params.x end
		if params.y then self.y = params.y end

		if params.color then self.color = params.color end

		if params.size then self.size = params.size end

		if params.rot then self.rot = params.rot end

		if params.sprite then self.sprite = params.sprite end

		return self
	end

	function point:render(layer)
		if layer == "fg" then
			local x, y = camera.translate(self.x, self.y)
			video.renderSpriteState(self.sprite, x, y, self.size, self.rot, self.color.a, self.color.r, self.color.g, self.color.b)
		end
	end

	return point
end

entities.add("debug_point", create)