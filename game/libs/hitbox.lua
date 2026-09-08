local hitbox = {}
hitbox.__index = hitbox

hitbox.Circle = function(radius,pos1,pos2)
	if pos2 == nil or pos1 == nil then
		error("Hitbox Positions arent right")
		return false
	elseif radius == nil or radius <= 0 then
		error("Hitbox Radius is zero or below zero")
		return false
	end

	local distance = pos1 - pos2


	love.graphics.print(distance:unit(),40,20)
	local dist = distance:unit()
	if dist <= radius then

		return true,dist
	else
		return false
	end
end

return hitbox