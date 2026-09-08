
local events = require("events.events")
local Color3 = require("libs.color3")
local v2 = require("ui.v2")
local config = require("config")
local general = require("ui.general")
local uisystem = require("ui.uisystem")
local animator = require("ui.animator")

local mods = {}
mods.focus = require("ui.mods.focus")
mods.difficulty = require("ui.mods.difficulty")
local diffChooseEvent = require("ui.events.diffChoose")
local module = {}

module.DIFFICULTY = false

local animations = {}
local lastsongpath
local lastosupath

local scroll = 0
local currentfile
local AddTextSong
local AddImage
uisystem.allfiles = love.filesystem.getDirectoryItems("//Songs")
uisystem.files = uisystem.allfiles
local r = love.math.random(#uisystem.files)


uisystem.currentSong = r
local lastcurrent = current





module.load = function()
	print("Loaded")
	diffChooseEvent()
	
end
module.updateBack = function()
	uisystem.affectAll("back",function(obj)
		animator.Animate(obj,{color = Color3.HSV(1,1,1,config.BACKGROUND_TRANSPARENCY)},0.5)
	end)
end

module.updateMusic = function()
	if uisystem.music then
		uisystem.music:setVolume(config.MUSIC_VOLUME)
	end
end

local stopped = false
module.Search = function(request)

	stopped = true
	uisystem.files = {}
	stopped = false
	if #request ~= 0 then
		for i,v in pairs(uisystem.allfiles) do 
			if stopped then return end
			local t,_ = v:lower():gmatch(request:lower())
			local a = 0
			
			for i,n in t do	
				a = a + 1
			end
			if a > 0 then
				table.insert(uisystem.files,v)
			end
		end
	else
		uisystem.files = uisystem.allfiles
	end
	local wish = math.floor(#uisystem.files/2)
	uisystem.currentSong = uisystem.files[wish] and wish or 1
	uisystem.lastCurrentSong = uisystem.files[wish] and wish or 1
	mods.focus("check")
end

module.MoveSongs = function(key)
	if config.STATUS == "DIFFICULTY" then
		mods.difficulty(key)
	else
		mods.focus(key)
	end	
end	

return module