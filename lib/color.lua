
color = {}

function color.createRGB(ar, ag, ab)
	local c = {r = ar, g = ag, b = ab, a = 255}

	-- Adding indices to the variables so they can be used by 'love.graphics.setColor' and other functions
	c[1] = c.r
	c[2] = c.g
	c[3] = c.b
	c[4] = c.a

	return c
end

function color.createRGBA(ar, ag, ab, aa)
	local c = {r = ar, g = ag, b = ab, a = aa}

	c[1] = c.r
	c[2] = c.g
	c[3] = c.b
	c[4] = c.a

	return c
end

function color.percent(startColor, endColor, percent)
	if percent > 100 or percent < 0 then
		percent = math.clamp(percent, 0, 100)
	end

	local c = {}

	c.r = (startColor.r * (percent)) + (endColor.r - endColor.r * (percent))
	c.g = (startColor.g * (percent)) + (endColor.g - endColor.g * (percent))
	c.b = (startColor.b * (percent)) + (endColor.b - endColor.b * (percent))
	c.a = (startColor.a * (percent)) + (endColor.a - endColor.a * (percent))

	return c
end

function color.lerp(color, endColor, dt)
	local c = {}

	c.r = math.clamp(color.r + (endColor.r - color.r) * dt, 0, 255)
	c.g = math.clamp(color.g + (endColor.g - color.g) * dt, 0, 255)
	c.b = math.clamp(color.b + (endColor.b - color.b) * dt, 0, 255)
	c.a = math.clamp(color.a + (endColor.a - color.a) * dt, 0, 255)

	return c
end

function color.offset(color, offset, r, g, b, a)
	c = {}

	if r == nil or r == true then c.r = math.clamp(math.random(color.r - offset, color.r + offset), 0, 255)
	else c.r = color.r end

	if g == nil or g == true then c.g = math.clamp(math.random(color.g - offset, color.g + offset), 0, 255)
	else c.g = color.g end

	if b == nil or b == true then c.b = math.clamp(math.random(color.b - offset, color.b + offset), 0, 255)
	else c.b = color.b end

	if a == nil or a == true then c.a = math.clamp(math.random(color.a - offset, color.a + offset), 0, 255)
	else c.a = color.a end

	return c
end

function color.clamp(color)
	c = {}

	c.r = math.clamp(color.r, 0, 255)
	c.g = math.clamp(color.g, 0, 255)
	c.b = math.clamp(color.b, 0, 255)
	c.a = math.clamp(color.a, 0, 255)

	return c
end

--COLOR DATABASE
color.black 	= color.createRGB(  0,   0,   0)
color.grey 		= color.createRGB(128, 128, 128)
color.white 	= color.createRGB(255, 255, 255)

color.zero 		= color.createRGBA(  0,  0,  0,  0)