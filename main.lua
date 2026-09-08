local uiclass = require("ui.uiclass")
local uirender = require("ui.uirender")
local uiloader = require("ui.main")
local assets = require("assetloader")
local events = require("events.events")
local eventloader = require("events.addevent")
local eventClass = require("events.eventClass")
local config = require("config")
local inputloader = require("input")
local animator = require("ui.animator")

local icon = love.image.newImageData("/assets/ohyes!logo.png")
local function loadProperties()
	local t,_ = love.filesystem.getSourceBaseDirectory():gsub("%.%.$","")
	local file,name = io.open(t.."user-config.cfg","r")


    for line in file:lines() do
        local property, value = line:match("^%s*([^=]+)%s*=%s*(.-)%s*$")

        if property and value then
        	value = tonumber(value) or value
            config[property] = value
            print("succesful")
        end
    end

    file:close()
end

function love.conf(t)
	t.console = true
end

function love.load()
	loadProperties()
	for i,v in pairs(config) do
		print(i,v)
	end
	eventloader.load()
	assets.load()
	uiloader.load()
	events.arrow:connect(function()
		print("loh")
	end)
	love.window.setIcon(icon)
    love.window.setTitle("oh yes!launcher")
	love.window.setMode(config.RESOLUTION_X,config.RESOLUTION_Y,{vsync = LAUNCHER_VSYNC == true and 1 or false})
end

local speed = 0
local lasttime = 0
local list = false

uiloader.avgps = 0

local g = {}
local global = 0
local searchMode = false
local searchRequest = ""

local keybindings = {
	["down"] = inputloader.Scroll,
	["up"] = inputloader.Scroll,
	["`"] = inputloader.Restart,
	["f2"] = inputloader.Hidetext,
	["return"] = inputloader.Enter,
	["f1"] = inputloader.StopSongs,
	["right"] = inputloader.Transparency,
	["left"] = inputloader.Transparency,
	["["] = inputloader.Volume,
	["]"] = inputloader.Volume,
}

function love.keypressed(key)
	
	if searchMode then 
		for i,v in pairs(keybindings) do
			if key == i then
				goto next
				break
			end
		end
		if key == "backspace" then
			searchRequest = searchRequest:sub(1,#searchRequest-1)
		elseif key == "space" then
			searchRequest = searchRequest.." "
		elseif key == "escape" then
			searchRequest = ""
			searchMode = false
		elseif #key == 1 then
			searchRequest = searchRequest..key
		end
		uiloader.Search(searchRequest)
		
	end
	::next::
	if key == "/" and not searchMode then
		searchMode = true
	end
	for i,v in pairs(keybindings) do
		if i == key then
			if type(v) == "function" then
				v(key)
			end
		end
	end

end

function love.update()

end

local k = {1,2,3}

function love.quit()
	local t,_ = love.filesystem.getSourceBaseDirectory():gsub("%.%.$","")
	local newfile = io.open(t.."user-config.cfg","w+")
	local result = ""
	for i,v in pairs(config) do
		if type(v) ~= "table" then
			result = result..i.."="..tostring(v)..'\n'
		end
	end
	newfile:write(result)
	newfile:close()

end

function love.draw()
	uirender.Render()
	animator.renderAnimations(love.timer.getTime())
	love.graphics.print(searchRequest,200,10)
end