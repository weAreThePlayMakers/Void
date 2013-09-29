
local function create()
	local line = entities.extend("entity")

	line.x2 = line.x + 100
	line.y2 = line.y + 100

	line.color = color.white

	function line:construct(params)
		if params.x then self.x = params.x end
		if params.y then self.y = params.y end

		if params.x2 then self.x2 = params.x2 end
		if params.y2 then self.y2 = params.y2 end

		if params.color then self.color = params.color end

		return self
	end

	function line:render(layer)
		if layer == "fg" then
			local x, y = camera.translate(self.x, self.y)
			local x2, y2 = camera.translate(self.x2, self.y2)
			video.renderLine(x, y, x2, y2, self.color.a, self.color.r, self.color.g, self.color.b)
		end
	end

	return line
end

entities.add("debug_line", create)