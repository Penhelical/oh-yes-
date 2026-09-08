local general = {}
local Color3 = require("libs.color3")
local v2 = require("ui.v2")
local config = require("config")
local uiclass = require("ui.uiclass")
local uisystem = require("ui.uisystem")

general.AddTextSong = function(range,file)
    local songtext = uiclass.text()
    songtext.path=file
    songtext.Text = file:match("^[^%-]+%-%s*(.+)$")
    if songtext.Text and #songtext.Text > 30 then
        songtext.Text = songtext.Text:sub(1,30).."..."
    end
    songtext.color = Color3.new(255,255,255,0)
    songtext.z = 15
    songtext.pos = v2.new(20,10*range) + v2.new(15,15)
    songtext.scale = v2.new(1,1)
    songtext.rotate = 50
    songtext.range = range
    songtext.BackgroundEnabled = true
    songtext.BackgroundColor = Color3.new(51,51,51,0)
    songtext:render("songs")
    return songtext
end

general.AddBack = function(path,y)
    local hoi = uiclass.image(path,v2.new(0,y))
    hoi.path = path
    hoi.scale = v2.new(0.8,0.8)
    hoi.color = Color3.new(255,255,255,255)
    hoi.z = 13
    hoi.range = current
    hoi:render("back")

    return hoi
end

general.AddMusic = function(path)
    local music = love.audio.newSource(path, "stream" )
    uisystem.music = music
    music:setVolume(config.MUSIC_VOLUME)
    love.audio.play(music)
end

general.startSong = function()
    love.audio.stop()
    local songpath = config.songpath
    local osupath = config.osupath
    if songpath and osupath and lastsongpath ~= songpath and lastosupath ~= osupath then    
        local audiocontent = io.open(songpath,"rb")
        local musicdata = audiocontent:read("*all")
        audiocontent:close()
        local mapcontent = love.filesystem.read(osupath)
        local osufile = io.open("D:/osu!/game/map.osu","w")
        local audifile = io.open("D:/osu!/game/audio.mp3","wb")
        osufile:write(mapcontent)
        audifile:write(musicdata)

        osufile:close()
        audifile:close()
        lastsongpath = songpath
        lastosupath = osupath
        local t,_ = love.filesystem.getSourceBaseDirectory():gsub("%.%.$","")
        local newfile = io.open(t.."/game/launcher-config.cfg","w+")
        newfile:write(tostring(config.MUSIC_VOLUME))
        newfile:close()
        os.execute('start "" "D:\\osu!\\LOVE\\lovec.exe" "D:\\osu!\\game"')         
    else
        os.execute('start "" "D:\\osu!\\LOVE\\lovec.exe" "D:\\osu!\\game"')
    end
end

return general