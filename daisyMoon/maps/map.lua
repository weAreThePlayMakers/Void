
local function load()
	local map = {}

	local speed = 2

	local lines = {}
	local linecount = 100
	local rotation = 2 * math.pi / linecount

	local offsets = {}
	local points = {}

	local lx = 0
	local ly = 0

	function map.load()
		for i = 1, linecount, 1 do
			local line = entities.create("debug_line",{x2 = math.cos(math.pi / linecount + i) * 250, y2 = math.sin(math.pi / linecount + i) * 250})
			lines[i] = line
			offsets[i] = math.random(0, 50)

			local point = entities.create("debug_point",{size = 0.025})
			points[i] = point
		end
	end

	function map.update(dt)
		for i, line in pairs(lines) do
			local rot = (2 * math.pi / linecount) * i + _time / 10 * speed

			line.x = lx
			line.y = ly

			line.x2 = math.cos(rot + offsets[i] * math.sin(_time / 10000)) * 800
			line.y2 = math.sin(rot + offsets[i]) * 100

			lx = line.x2
			ly = line.y2

			points[i].x = lx
			points[i].y = ly
		end
	end

	return map
end

mapsystem.add("map", load)