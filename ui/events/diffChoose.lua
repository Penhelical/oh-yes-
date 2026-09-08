

local events = require("events.events")
local Color3 = require("libs.color3")
local v2 = require("ui.v2")
local config = require("config")
local general = require("ui.general")
local uisystem = require("ui.uisystem")
local animator = require("ui.animator")
local uiclass = require("ui.uiclass")

return function()
	events.Enter:connect(function()
		local currentfile = uisystem.files[uisystem.currentSong]
		if not currentfile then return end
		
		local row = 0
		local insides = love.filesystem.getDirectoryItems("//Songs//"..currentfile)
		if config.STATUS ~= "DIFFICULTY" then
			config.STATUS = "DIFFICULTY"
			uisystem.affectAll("difficulty",function(obj)
				obj:destroy()
			end)		
			for _, ess in ipairs(insides) do
		    	if string.sub(ess, -4) == ".osu" then
		    		row = row + 1
					local songtext = uiclass.text()
					songtext.path=currentfile.songname
					
					local difficulty = ess:match("%[(.-)%]")
					if songtext.Text and #songtext.Text > 30 then
						songtext.Text = songtext.Text:sub(1,30).."..."
					end
					songtext.Text = difficulty
					songtext.color = Color3.new(255,255,255,0)
					songtext.z = 15
					songtext.pos = v2.new(-300,30*row)
					songtext.scale = v2.new(2,2)
					songtext.rotate = 50
					songtext.Button = true
					songtext.range = row
					songtext.size = v2.new(200,20)
					

					-- animator.Animate(songtext,{pos = v2.new(50
					-- ,30*row),color = Color3.HSV(1,1,1,1)},0.5)
					songtext.range = row
					songtext:render("difficulty")
					songtext.LeftClickEvent:connect(function()
						config.osupath="//Songs//"..currentfile.."//"..ess
						config.songpath="D:/osu!/Songs/"..currentfile.."/"..uisystem.musicname
						general.startSong()
					end)
				end
			end
			uisystem.affectAll("songs",function(obj)
				animator.Animate(obj,{color = obj.color - Color3.HSV(0,0,0,1)},0.5,false,true)
			end)
			uisystem.affectAll("difficulty",function(obj)
				animator.Animate(obj,{pos = v2.new(50,30*obj.range),color = obj.color + Color3.HSV(0,0,0,1)},0.5)
			end)
		else
			local rendered = general.AddTextSong(1,currentfile)
		
			local song = uisystem.songs[rendered.z][rendered.n]
			if song == nil then return end
			song.scale = v2.new(2,2)
			song.pos = v2.new(0,10) + v2.new()
			uisystem.affectAll("songs",function(obj)
				animator.Animate(obj,{color = obj.color + Color3.HSV(0,0,0,1)},0.5,false,false)
			end)
			uisystem.affectAll("difficulty",function(obj)
				animator.Animate(obj,{pos = v2.new(-300,30*obj.range),color = obj.color - Color3.HSV(0,0,0,1)},0.5,false,true)
			end)
			config.STATUS = nil
			
		end

	end)
end