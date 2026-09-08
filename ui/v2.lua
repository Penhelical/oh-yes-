local v2 = {}
v2.__index = v2

function v2.new(x,y)
	local g = setmetatable({},v2)
	g.x = x or 0
	g.y = y or 0

	return g
end

function v2.__sub(a,b)
	local x = a.x - b.x
	local y = a.y - b.y
	return v2.new(x,y)
end

function v2.__add(a,b)
	local x = a.x + b.x
	local y = a.y + b.y
	return v2.new(x,y)
end
function v2.x(y)
	return v2.new(y,0)
end
function v2.y(y)
	return v2.new(0,y)
end
function v2.__mul(a,b)
	local result
	if getmetatable(a) == v2 and getmetatable(b) == v2 then
		local x = a.x * b.x
		local y = a.y * b.y
		result = v2.new(x,y)
	elseif getmetatable(b) == v2 then
		local x = b.x * a
		local y = b.y * a
		result = v2.new(x,y)
	elseif getmetatable(a) == v2 then
		local x = a.x * b
		local y = a.y * b
		result = v2.new(x,y)
	end
	return result or v2.new()
end

function v2.__div(a,b)
	local result
	if getmetatable(a) == v2 and getmetatable(b) == v2 then
		local x = a.x / b.x
		local y = a.y / b.y
		result = v2.new(x,y)
	elseif getmetatable(b) == v2 then
		local x = b.x / a
		local y = b.y / a
		result = v2.new(x,y)
	elseif getmetatable(a) == v2 then
		local x = a.x / b
		local y = a.y / b
		result = v2.new(x,y)
	end
	return result or v2.new()
end

return v2