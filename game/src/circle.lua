local config = require("config")

local v2 = require("libs.v2")
local skin = require("src.skinloader").reload()

local circle = {}

local unitsize = skin["hitcircle@2x"]:getWidth()

local DrawElement = function(image,params,alpha)
	local width,height = image:getDimensions()
	local sx,sy = params.size.x,params.size.y
	local pos = params:offset(width*sx,height*sy)
	if alpha then love.graphics.setColor(1, 1, 1, alpha ) end
	love.graphics.draw(image,pos.x,pos.y,0,sx,sy)
	if alpha then love.graphics.setColor(1, 1, 1, 1 ) end
end

circle.Create = function(params,alpha,count)
	if config.HITCIRCLE then DrawElement(skin["hitcircle@2x"],params,alpha) end
	if config.HITCIRCLEOVERLAY then DrawElement(skin["hitcircleoverlay@2x"],params,alpha) end
	if config.COUNT then
		if count and #(tostring(count)) <2 then
			DrawElement(skin["default-"..tostring(count)],params:scale(0.8),alpha)
		elseif count and #(tostring(count)) == 2 then
			local text = tostring(count)
			local c1 = string.sub(text, 1, 1)
			local c2 = string.sub(text, 2, 2)
			DrawElement(skin["default-"..c1],params:plusx(-skin["default-"..c2]:getWidth()/4),alpha)
			DrawElement(skin["default-"..c2],params:plusx(skin["default-"..c2]:getWidth()/1.8),alpha)
		end
	end
end
circle.Miss = function(params,alpha)
	DrawElement(skin["hit0-0"],params,alpha)
end

circle.Accuracy = function(s,params,alpha)
	DrawElement(skin[s == "s100" and "hit100-3@2x" or "hit50-0"],params,alpha)
end
circle.ReactCircle = function(params,alpha)
	DrawElement(skin["approachcircle@2x"],params,alpha)
end

local pow = (config.EXPONENTIAL_APPROACH_CIRCLE and 2 or 1)
circle.render = function(objects,globalOffset,nowTime,scale)
	local a = 0
	for i, obj in ipairs(objects) do
		local timescope = obj and obj.timing and obj.timing+globalOffset-nowTime
		if obj ~= nil and timescope >= 0 then
			a = 1 + 1
        	local elapsed = nowTime-(obj.timing+globalOffset-config.REACTION)
        	local progress = math.min(elapsed/(config.REACTION),1)
        	local invert = 1-progress
        	local hidden = config.HIDDEN and math.min(invert*(1/config.CIRCLEAPPEAR_TIME),1) or math.min(progress*(1/config.CIRCLEAPPEAR_TIME),1)
        	if config.APPROACHCIRCLE and (not config.HIDDEN or config.HIDDEN_APPROACH_CIRCLE) then
        		local startSize = 1/config.REACTION+4*scale
        		local endSize = 0.95*scale
        		local diff = startSize - (startSize - endSize) * progress
	            circle.ReactCircle(
	                v2.complete(obj.x, obj.y, diff, diff),
	                hidden*1.15
	            )
        	end

            circle.Create(
                v2.complete(obj.x, obj.y, scale, scale),
                hidden,
                obj.c
            )
        end
    end
    return a
end

return circle