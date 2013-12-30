
local function create()
	local line = entities.extend("entity")

	line.x2 = line.x + 100
	line.y2 = line.y + 100

	line.color = color.white

	line.state.renderlayers = 3

	function line:construct(params)
		self.x = params.x or self.x
		self.y = params.y or self.y

		self.x2 = params.x2 or self.x2
		self.y2 = params.y2 or self.y2

		self.color = params.color or self.color

		return self
	end

	function line:render(layer)
		if layer == "foreground" then
			local x, y = camera.translate(self.x, self.y)
			local x2, y2 = camera.translate(self.x2, self.y2)

			video.renderLine(x, y, x2, y2, self.color.a, self.color.r, self.color.g, self.color.b)
		end
	end

	return line
end

entities.add("debug_line", create)