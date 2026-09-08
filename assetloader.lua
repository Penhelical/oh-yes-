local assetloader = {}
local config = require("config")

local fonts = {}

local function loadFonts()
	for i,font in ipairs(config.LOADED_FONTS or {}) do
		fonts[font] = love.graphics.newFont("/assets/Fonts/"..font..".otf")
	end	
end

function assetloader.load()
	loadFonts()
	assetloader.fonts = fonts
end

function assetloader.reload()
	fonts = {}
	loadFonts()
end


function assetloader.fonts() return fonts end

return assetloader