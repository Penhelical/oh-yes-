local config = require("config")
---///MODULES
local skinloader = require("src.skinloader")
local circle = require("src.circle")
local particles = require("src.particles")

---///LIBRARIES
local v2 = require("libs.v2")
local hitbox = require("libs.hitbox")

---///ASSETS
local music = love.audio.newSource("audio.mp3", "static")



--Major

local AUTOTAPPING = false
local IGNORE_HS = false
local START_FROM = 0
local VSYNC = false
local PRE_LAUNCH_TIME = 5

--EXPERIMENTAL
local EXPERIMENTAL_SPLIT = config.EXPERIMENTAL_SPLIT or false
local MAP_SPLIT_INT = 10
local NEXT_MAP_GEN = 5


--RESOLUTION
local osuScale = {x=512,y=384}
local resolution = {x=1920,y=1080}

local truescaleX = (resolution.x/osuScale.x)
local truescaleY = (resolution.y/osuScale.y)

local scaleX = 0.85
local scaleY = 0.85
local trash = 0

--///

local objects = {}
local loaded = false
local FULLCOMBO = 0
music:setVolume(config.VOLUME)
--settings
local reaction = config.REACTION
local scale = config.SCALE
local speedRate = config.SPEEDRATE
local globalOffset = 0
local timingRate = 0.3
local nextFrame = 0
local currentFrame = 0
local combo = 0
local queue = 1
local text
local tocheck = {}
local lts
local MAX_FULLCOMBO = 0

local targetFPS = 1000
local targetFrameTime = 1 / targetFPS
local minfps = nil
local maxfps = 0
local avgfps = 1000
local fps = 0
local frameTime = 0

local frames = 0
local timer = 0
local usualdrop = 0
local roller = 0

local precision = 0
local precisionhits = 0
local precisionscore = 0
love.graphics.setDefaultFilter("linear", "linear", 0)
local skin = skinloader.reload()
local font = love.graphics.newFont("/assets/font.ttf",92)
local icon = love.image.newImageData("/assets/ohyes!logo.png")
--CONST???

music:setPitch(speedRate)
local unitsize = skin["hitcircle@2x"]:getWidth()

local basediametr = (54.4 - 4.48 * 5) * 1.00041 * 2
local basescale = basediametr/unitsize

local gen

local mouse = {}
local offsetX = unitsize*scale/2
local offsetY = unitsize*scale/2
local canvas 
local frame_time = 1 / 1000
local newestIndex = 0

function split(str, separator)
    local result = {}

    for value in str:gmatch("[^" .. separator .. "]+") do
        table.insert(result, value)
    end

    return result
end

local function getPreempt(ar)
    if ar < 5 then
        return 1200 + 600 *(5 - ar) / 5
    else
        return 1200 - 750 * (ar - 5) /5
    end
end
local function defineHS(ht)
    if IGNORE_HS then return "soft-hitnormal" end
    if ht == 2 then return "soft-hitwhistle"
    elseif ht == 4 then return "soft-hitfinish"
    elseif ht == 8 then return "soft-hitclap" end

    return "soft-hitnormal" 
end


local function getCSinScale(cs)
    return ((54.4 - 4.48 * cs) * 1.00041 * 2)/unitsize/basescale
end
local function MissInit(obj,fooltime)
    obj.w = true
    if FULLCOMBO > 5 then
        local hitsh = skin.combobreak:clone()
        hitsh:play()
    end
    FULLCOMBO = 0
    particles.Miss(fooltime,obj.x,obj.y)
end


local s300 = 78
local s100 = 138
local s50 =  198

function love.load()
    local text = love.filesystem.read("map.osu")
    local hitObjects = {}
    local inHitObjects = false
    local ar = text:match("ApproachRate:(%d+%.?%d*)") or 9
    local cs = text:match("CircleSize:(%d+%.?%d*)")
    local od = text:match("OverallDifficulty:(%d+%.?%d*)") or 10

    scale = config.CIRCLESIZE_ENABLED and getCSinScale(cs)*truescaleX/truescaleY or config.SCALE
    reaction = config.APPROACHRATE_ENABLED and getPreempt(tonumber(ar))/1000 or config.REACTION

    local newfile = love.filesystem.read("launcher-config.cfg")
    config.VOLUME = tonumber(newfile)
    print(newfile)
    music:setVolume(config.VOLUME)
    config.REACTION = reaction







    local offsetX = unitsize*scale/2
    local offsetY = unitsize*scale/2





    


    for line in text:gmatch("[^\r\n]+") do
        if line == "[HitObjects]" then
            inHitObjects = true
            goto continue

        elseif line:match("^%[.+%]$") then
            -- We've reached another section
            inHitObjects = false

        elseif inHitObjects and line ~= "" then
            table.insert(hitObjects, line)
        end
        ::continue::
    end
    s300 = (78 - 6*od ) /1000
    s100 = (138 - 8*od) /1000
    s50 =  (198 - 10*od) /1000
    gen = coroutine.create(function()
            local lx = 0
            for i, object in ipairs(hitObjects) do
                local hitobject = split(object,",")
                local tamin = math.floor(tonumber(hitobject[3])/1000) or 0
                local ieject = math.floor(tamin/MAP_SPLIT_INT)+1
                if EXPERIMENTAL_SPLIT and objects[ieject] == nil then
                    objects[ieject] = {}
                    trash = trash + 1
                    local lts = objects[ieject-1]
                    newestIndex = ieject
                    currentFrame = ieject
                    objects[ieject].age = ieject
                    if ieject ~= 1 then objects[ieject].nextFrame = lts[#lts].timing coroutine.yield() end
                end

                table.insert(EXPERIMENTAL_SPLIT and objects[ieject] or objects,
                {i = i,
                timing = tonumber(hitobject[3])/1000,
                x = offsetX+tonumber(hitobject[1])*truescaleX*scaleX,
                y = offsetY+tonumber(hitobject[2])*truescaleY*scaleY,
                n = (hitobject[4] == "5") and true or false,
                h = tonumber(hitobject[5]),
                s = false,
                w = false,
                nx = (hitobject[4] == "5") and 0 or lx + 1
                })
                lx = (hitobject[4] == "5") and 0 or lx + 1
            end

    end)
    coroutine.resume(gen)
    love.window.setIcon(icon)
    love.window.setTitle("oh yes!")
    love.window.setMode(resolution.x,resolution.y,{
    vsync = VSYNC == true and 1 or false,
    fullscreen = true,
    fullscreentype = "exclusive",
    msaa=0,
    stencil=8,
    depth=24,
    resizable = false,
    borderless = true,
    centered=true,
    msaa=0,
    })
    love.mouse.setVisible(false)
    globalOffset = love.timer.getTime()
    config.globalOffset = globalOffset
    loaded = true
    music:play()
    collectgarbage("stop")
    canvas = love.graphics.newCanvas()

end

function love.keypressed( key, scancode )
        local x, y = mouse.x,mouse.y
        local time = love.timer.getTime()
        if key == "d" or key == "g" then
            if EXPERIMENTAL_SPLIT then 
                for i,layer in pairs(objects) do
                    for i,obj in ipairs(layer) do
                        if obj.w ~= true and math.abs(obj.timing+globalOffset-time) <= s50 then
                            local hitted,dist = hitbox.Circle(unitsize*scale/2,v2.new(x,y),v2.new(obj.x,obj.y)) 
                            if hitted then
                                local ms = math.abs(obj.timing+globalOffset-time)
                                precisionscore = precisionscore + 1-dist/unitsize*scale/2
                                precisionhits = precisionhits + 1
                                local s = ms <= s300 and "s300" or (ms <= s100 and "s100" or (ms <= s50 and "s50"))
                                particles.Accuracy(s,time,obj.x,obj.y)
                                local sound = skin[defineHS(obj.h)]:clone()
                                sound:play()
                                obj.w = true
                                FULLCOMBO = FULLCOMBO + 1
                                if config.AFTERCIRCLE_ANIMATION then particles.leftCircle(time,obj.x,obj.y) end
                                break
                            end
                        elseif obj.w ~= true and math.abs(obj.timing+globalOffset-time) <= config.REACTION then
                            local hitted,dist = hitbox.Circle(unitsize*scale/2,v2.new(x,y),v2.new(obj.x,obj.y)) 
                            if hitted then 
                                MissInit(obj,time)
                            end
                        end
                    end
                end
                
            else
                 for i,obj in ipairs(objects) do
                    if obj.w ~= true and math.abs(obj.timing+globalOffset-time) <= s50 then
                        local hitted,dist = hitbox.Circle(unitsize*scale/2,v2.new(x,y),v2.new(obj.x,obj.y)) 
                        if hitted then
                            local ms = math.abs(obj.timing+globalOffset-time)
                            precisionscore = precisionscore + 1-dist/unitsize*scale/2
                            precisionhits = precisionhits + 1
                            local s = ms <= s300 and "s300" or (ms <= s100 and "s100" or (ms <= s50 and "s50"))
                            particles.Accuracy(s,time,obj.x,obj.y)
                            local sound = skin[defineHS(obj.h)]:clone()
                            sound:play()
                            obj.w = true
                            FULLCOMBO = FULLCOMBO + 1
                            if config.AFTERCIRCLE_ANIMATION then particles.leftCircle(time,obj.x,obj.y) end
                            break
                        end
                    end
                end
            end            
            
        elseif key == "escape" then
            love.event.quit() 
        elseif key == "`" then
            love.event.quit("restart")  
        elseif key == "up" then
            config.VOLUME = config.VOLUME + 0.1
            music:setVolume(config.VOLUME)
        elseif key == "down" then
            config.VOLUME = config.VOLUME - 0.1
            music:setVolume(config.VOLUME)
        end
end

local timings = 0




function love.update(dt)
    if loaded == false then return end
    local fooltime = love.timer.getTime()
    local timescope = globalOffset-fooltime
    local songtime = fooltime-globalOffset
    frameTime = dt

    frames = frames + 1
    timer = timer + dt
    if EXPERIMENTAL_SPLIT then
        if fooltime+config.REACTION > objects[newestIndex].nextFrame+globalOffset then
            coroutine.resume(gen)
            for i, layer in pairs(objects) do
                if layer == nil then goto continue end
                if objects[newestIndex].age*MAP_SPLIT_INT - layer.age*MAP_SPLIT_INT > MAP_SPLIT_INT*2+config.REACTION then
                    objects[i] = nil
                end
                ::continue::
            end
        end
    end
    if timer >= 0.05 and fooltime>5 then
        fps = frames / timer
        usualdrop = fps - (minfps or fps)
        if not minfps or fps < minfps or fooltime % 1 <0.01 then
            minfps = fps       
        elseif fps > maxfps or fooltime % 0.5 <0.01 then
            maxfps = fps 
        end
        avgfps = ((maxfps+minfps+avgfps+fps)/4-math.max(usualdrop,0)/2   )
        frames = 0
        timer = 0
        
    end

    collectgarbage("step",20)
    if not EXPERIMENTAL_SPLIT then
        for i,v in pairs(objects) do
            if v and v.w == false and fooltime-objects[i].timing-globalOffset > s50 then
                objects[i].w = true
                if FULLCOMBO > 5 then
                    local hitsh = skin.combobreak:clone()
                    hitsh:play()
                end
                FULLCOMBO = 0
                particles.Miss(fooltime,objects[i].x,objects[i].y)
            end
        end
        if FULLCOMBO > MAX_FULLCOMBO then
                MAX_FULLCOMBO = FULLCOMBO
        end
    else
        for i,layer in pairs(objects) do
                    for i,obj in ipairs(layer) do
                        if obj and obj.w == false and fooltime-obj.timing-globalOffset > s50 then
                            MissInit(obj,fooltime)
                        end
                    end
        end
        if FULLCOMBO > MAX_FULLCOMBO then
                MAX_FULLCOMBO = FULLCOMBO
        end
    end
    
    
end

local renderCircles = {}

local tcombo = love.graphics.newText(font,"Hello")
local tprecision = love.graphics.newText(font,"Hello")
function love.draw()
    if loaded == false then return end
    love.graphics.setCanvas(canvas)
    love.graphics.clear(0,0,0,1)
    love.graphics.setBackgroundColor(0,0,0,1)
    
    love.graphics.setCanvas()
    love.graphics.draw(canvas)
    local nowTime = love.timer.getTime()
    --circle.render(globalOffset,nowTime,scale)
    love.graphics.print(string.sub(tostring(nowTime-globalOffset),1,1),10,50)
    love.graphics.print(math.floor(fps),10,30)
    love.graphics.print(minfps and math.floor(minfps) or 0,40,30)
    love.graphics.print(math.floor(maxfps),70,30)
    love.graphics.print(math.floor(avgfps),120,30)
    love.graphics.print(math.floor(usualdrop),160,30)
    --RENDER CIRCLES
    tprecision:set(tostring(math.floor(precisionscore/precisionhits*100)).."%")
    tcombo:set(tostring(FULLCOMBO..'/'..MAX_FULLCOMBO))
    love.graphics.draw(tprecision,0,900,0,1,1)
    love.graphics.draw(tcombo,0,990,0,1,1)
     local b = 0
     
     local timescope = globalOffset-nowTime
    local songtime = nowTime-globalOffset
    if EXPERIMENTAL_SPLIT then
        for i,layer in pairs(objects) do
            for i,n in ipairs(layer) do
                if math.abs(n.timing+globalOffset-nowTime) <= reaction and n.w == false then
                    b = b + 1
                    n.c = n.nx
                    renderCircles[b] = n
                end
            end
        end
        
    else
        
        

        for i,n in ipairs(objects) do
            if math.abs(n.timing+globalOffset-nowTime) <= reaction and n.w == false then
                b = b + 1
                if not n.c then n.c = n.n and 0 or ((objects[i-1] and objects[i-1].c) and objects[i-1].c+1 or 0) end
                renderCircles[b] = n
            end
        end
        
    end
    particles.render(nowTime,scale)
    circle.render(renderCircles,globalOffset,nowTime,scale)
    love.graphics.draw(
        skin.cursor,
        tonumber(mouse.x), tonumber(mouse.y),
        0,
        1, 1,
        skin.cursor:getWidth() / 2,
        skin.cursor:getHeight() / 2
    )
    local p = 0
     for i,layer in pairs(objects) do
                    for i,obj in ipairs(layer) do

                        p = p +1 end end
    love.graphics.print("render: " .. b, 10, 130)
    love.graphics.print("objects: " .. p, 10, 150)
    love.graphics.print("trash: " .. collectgarbage("count"), 10, 180)
    b = 0
    --particles.render(nowTime)

    renderCircles = {}
end



function love.mousemoved(x,y,dx,dy)
    mouse.y = y
    mouse.x = x
end