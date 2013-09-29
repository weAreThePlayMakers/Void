
function math.clamp(num, min, max)
	if num < min and min < max then num = min end
	if num > max and max > min then num = max end
	return num
end

function math.lerp(num, endNum, dt)
	return num + (endNum - num) * dt
end

function math.percent(startNum, endNum, percent)
	if percent > 100 or percent < 0 then
		percent = math.clamp(percent, 0, 100)
	end

	num = (startNum * (percent)) + (endNum - endNum * (percent))

	return num
end

function math.randomFloat(a, b, decimal)
	local value_a = 1
	local value_b = 1

	if a ~= 0 then
		value_a = a / a
	else
		value_a = 1
	end

	if b ~= 0 then
		value_b = b / b
	else
		value_b = 1
	end

	if decimal then
		return math.random(a * (10 ^ decimal) * value_a, b * (10 * decimal) * value_b) / (10 ^ decimal)
	else
		return math.random(a * (10 ^ 5) * value_a, b * (10 ^ 5) * value_b) / (10 ^ 5)
	end
end

function math.lerpDeg(angle, endAngle, dt)
	local difference = math.abs(endAngle - angle)

    if difference > 180 then
        if endAngle > angle then
            angle = angle + 360
        else
        	endAngle = endAngle + 360
        end
    end

	local value = angle + (endAngle - angle) * dt

	local rangeZero = 360

	if(value >= 0 and value <= 360) then
		return value
	else
		return value % rangeZero
	end
end