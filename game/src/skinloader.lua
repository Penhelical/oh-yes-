local skin = {}
local config = require("config")

skin.reload = function()
	for i,name in ipairs({'hitcircle@2x','approachcircle@2x','hitcircleoverlay@2x','approachcircle','cursor','hit0-0','default-0',
	'default-1','default-2','default-3','default-4','default-5','default-6','default-7','default-8','default-9',"hit50-0","hit100-3@2x"}) do
		skin[name] = love.graphics.newImage("/assets/skin/"..name..".png")

	end
	for i,name in ipairs({'soft-hitnormal','combobreak','soft-hitclap',"soft-hitwhistle","soft-hitfinish"}) do
		skin[name] = love.audio.newSource("/assets/skin/"..name..".ogg","static")
		skin[name]:setVolume(config.HITSOUND_VOLUME)
	end
	return skin
end

return skin