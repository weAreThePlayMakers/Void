
function table.length(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end

function table.add(t, e)
	t[table.length(t) + 1] = e
end

function table.merge(t1, t2)
	local length = table.length(t2)

	for i, item in pairs(t1) do
		t2[length+i] = item
	end

	return t2
end