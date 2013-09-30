
local function create()
	platform = entities.extend("entity")

	platform.w = 24
	platform.h = 8

	platform.color = color.white

	function platform:construct(params)
		if params.x then self.x = params.x end
		if params.y then self.y = params.y end

		if params.w then self.w = params.w end
		if params.h then self.h = params.h end

		if params.color then self.color = params.color end

		return self
	end

	function platform:render(layer)
		if layer == "mg" then
			local x, y = camera.translate(self.x, self.y)
			video.renderRectangle(x, y, self.w, self.h, self.color.a, self.color.r, self.color.g, self.color.b)
		end
	end

	return platform
end

entities.add("platform", create)