local events = require("events.events")
local Color3 = require("libs.color3")
local v2 = require("ui.v2")
local config = require("config")
local general = require("ui.general")
local uisystem = require("ui.uisystem")
local animator = require("ui.animator")


local filetypes = {
	"jpeg",
	"webp",
	"jpg",
    "png",
}

local addons = {
	"background",
	"bg",
	"wallpaper",
	"",
}

return function(key)
	if config.STATUS == "DIFFICULTY" then return end
	local vector = v2.new(0,10)
	if key == "up" and uisystem.files[uisystem.currentSong-1] then
		uisystem.lastCurrentSong = uisystem.currentSong
		uisystem.currentSong = uisystem.currentSong  - 1
	elseif key == "down" and uisystem.files[uisystem.currentSong+1] then
		uisystem.lastCurrentSong = uisystem.currentSong
		uisystem.currentSong = uisystem.currentSong  + 1
	elseif key == "check" then

	else
		return
	end
	local current = uisystem.currentSong
	print(current,#uisystem.files)
	if not uisystem.files[current] then return end
	uisystem.affectAll("songs",function(x)
		x:destroy()
	end)
	local rendered = general.AddTextSong(1,uisystem.files[current])
	
	local song = uisystem.songs[rendered.z][rendered.n]
	if song == nil then return end
	song.scale = v2.new(2,2)
	song.pos = v2.new(0,10) + v2.new()
	local newfiles = love.filesystem.getDirectoryItems("//Songs//"..song.path)
	local fullpath
	local musicpath
	uisystem.affectAll("songs",function(obj)
		animator.Animate(obj,{color = obj.color + Color3.HSV(0,0,0,1)},0.5,false,false)
	end)
	currentfile = {songname=song.path,musicname=nil}
	for _,filetype in ipairs(filetypes) do
		if fullpath and musicpath then break end
		for _,addon in ipairs(addons) do
			if fullpath and musicpath then break end
			for _, file in ipairs(newfiles) do
				local s = #addon > 0 and file:lower():gmatch(addon) or nil
				local t = {}

				if s then for x in s do
				    t[#t + 1] = x
				end end
				if not fullpath and file:lower():match("%"..addon.."."..filetype.."$") or #t > 0 then
					fullpath = "//Songs//"..song.path.."//"..file
				elseif file:lower():match("%.mp3") then
			        musicpath = file
			    end
			end		
		end		
	end
	local directionVector1 = uisystem.lastCurrentSong-current < 0 and -400 or 400
	local directionVector2 = uisystem.lastCurrentSong-current > 0 and -400 or 400
	uisystem.affectAll("back",function(obj)
		obj:destroy()
	end)
	if uisystem.music then love.audio.stop(uisystem.music) uisystem.music:release() uisystem.music = nil end
	
	collectgarbage()
	if fullpath then
		local image = general.AddBack(fullpath,directionVector2)
		image.pos = v2.y(directionVector2)
		animator.Animate(image,{pos = v2.new(0,0)},math.max(0.5-config.AVGPS/6,0))
		animator.Animate(image,{color = Color3.HSV(1,1,1,config.BACKGROUND_TRANSPARENCY)},math.max(0.5-config.AVGPS/6,0),false,false)
		
	end

	if musicpath then
		currentfile.musicname = musicpath
		uisystem.musicname = musicpath
		if config.PREVIEW_SONG then pcall(general.AddMusic,("//Songs//"..song.path.."//"..musicpath)) end
	end
end