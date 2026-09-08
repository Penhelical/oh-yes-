local Color3 = {}
Color3.__index = Color3


function Color3.new(rb,gb,bb,ab)
	local self = setmetatable({},Color3)
	self.__index = self
	self.r,self.g,self.b,self.a = love.math.colorFromBytes( rb, gb, bb, ab or 255)
	return self
end

function Color3.HSV(rb,gb,bb,ab)
	local self = setmetatable({},Color3)
	self.__index = self
	self.r,self.g,self.b,self.a = rb, gb, bb, ab or 255
	return self
end

function Color3:get()
	return self.r,self.g,self.b,self.a or 0
end

function Color3.__mul(a,b)
	if type(a) == "number" then
		return Color3.HSV(b.r*a,b.g*a,b.b*a,b.a*a)	
	elseif type(b) == "number" then
		return Color3.HSV(a.r*b,a.g*b,a.b*b,a.a*b)
	else
		local rx = a.r*b.r
		local gx = a.g*b.g
		local bx = a.b*b.b
		local ax = a.a*b.a
		return Color3.HSV(rx,gx,bx,ax)
	end
end

function Color3.__sub(a,b)
	local rx = a.r-b.r
	local gx = a.g-b.g
	local bx = a.b-b.b
	local ax = a.a-b.a
	return Color3.HSV(rx,gx,bx,ax)
end

function Color3.__add(a,b)
	local rx = a.r+b.r
	local gx = a.g+b.g
	local bx = a.b+b.b
	local ax = a.a+b.a
	return Color3.HSV(rx,gx,bx,ax)
end

return Color3