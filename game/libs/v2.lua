local v2 = {}
v2.__index = v2

v2.new = function(x,y)
	local new = setmetatable({}, v2)
	new.x = x
	new.y = y
	return new
end

v2.complete = function(x1,y1,x2,y2)
	local new = setmetatable({}, v2)
	
	new.pos = v2.new(x1,y1)

	new.size = v2.new(x2,y2)
	
	return new
end

v2.__sub = function(a,b)
	x = a.x - b.x
	y = a.y - b.y

	return v2.new(x,y)
end

function v2:unit()
	local a = self.x
	local b = self.y
	local c = (a^2+b^2)^0.5
	return c
end

function v2:offset(ix,iy)
	return v2.new(self.pos.x-ix/2,self.pos.y-iy/2)
end

function v2:scale(k)
	self.size.x = self.size.x * k
	self.size.y = self.size.y * k
	return self
end

function v2:plusx(x)
	self.pos.x = self.pos.x + x
	return self
end

return v2