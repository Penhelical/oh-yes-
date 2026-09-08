local input = {}

local uiclass = require("ui.uiclass")
local uirender = require("ui.uirender")
local uiloader = require("ui.main")
local assets = require("assetloader")
local events = require("events.events")
local eventloader = require("events.addevent")
local eventClass = require("events.eventClass")
local config = require("config")

local g = 0
local global = 0
local lasttime = global
function input.Scroll(key)
	list = true
	local a = 0
	g = g + 1
	config.AVGPS = g / (love.timer.getTime()-global)
	if love.timer.getTime()-lasttime>1.25 then
		global = love.timer.getTime()
		print("lol")
		g = 0
		config.AVGPS = 0
	end
	lasttime = love.timer.getTime()
	
	uiloader.MoveSongs(key)		
end

function input.Restart()
	love.event.quit("restart")
end

function input.Enter()
	local newEvent = events.Enter
	if newEvent.inprocess then newEvent.inprocess() end
end

function input.HideText()
	config.SHOW_TEXT = not config.SHOW_TEXT
end

function input.StopSongs()
	config.PREVIEW_SONG = not config.PREVIEW_SONG
	if config.PREVIEW_SONG then love.audio.stop() end
end

function input.Transparency(key)
	local k = key == "left" and -1 or 1
	config.BACKGROUND_TRANSPARENCY = math.min(math.max(config.BACKGROUND_TRANSPARENCY +0.1*k,0),1)
	print("CHANGED TO",config.BACKGROUND_TRANSPARENCY)
	uiloader.updateBack()
end

function input.Volume(key)
	if key == "[" then
		config.MUSIC_VOLUME = math.max(config.MUSIC_VOLUME-0.1,0)
	elseif key == "]" then
		config.MUSIC_VOLUME = config.MUSIC_VOLUME+0.1
	end
	print(config.MUSIC_VOLUME)
	uiloader.updateMusic()
end
return input
