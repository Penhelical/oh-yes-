local module = {}
local animations = {}
module.renderAnimations = function(nowTime)
	for _,anim in pairs(animations) do

		local obj = anim.object
		local props = anim.properties
		local duration = anim.duration
		local startTime = anim.startTime
		local startprops = anim.originProperties
		local isExp = anim.isExp
		local removeAfter = anim.removeAfter

		local elapsed = nowTime - startTime
		local progress = math.min(elapsed/duration,1) --^ (isExp and 0.5 or 1)
		for i,p in pairs(props) do
			obj[i] = (startprops[i] + (p - startprops[i]) * progress)
		end
		if progress >= 1 then table.remove(animations,_) if removeAfter then obj:destroy() end end
	end
end

module.Animate = function(obj,props,duration,isExp,removeAfter)
	local startprops = {}
	for i,prop in pairs(props or {}) do
		startprops[i] = obj[i]
	end
	table.insert(animations,{
		object=obj,
		duration=duration or 1,
		properties=props or {},
		startTime=love.timer.getTime(),
		originProperties=startprops,
		isExp=isExp or false,
		removeAfter=removeAfter or  false,
	}
	)
end
return module