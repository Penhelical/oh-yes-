local hitbox = {}

function hitbox.Check(origin,pos,size)
	if origin.x >= pos.x and origin.y >= pos.y and origin.x <= pos.x+size.x and origin.y <= pos.y+size.y then
		return true
	end
	return false
end

return hitbox