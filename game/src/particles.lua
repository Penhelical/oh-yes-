local particles = {}
local Ps = {}
local skin = require("src.skinloader").reload()
local circle = require("src.circle")
local v2 = require("libs.v2")
local config = require("config")
local scaling = 1
function particles.leftCircle(t,x,y)
    table.insert(Ps,{type = "leftcircle",timing = t,x = x, y = y})
end

function particles.Miss(t,x,y)

    table.insert(Ps,{type = "miss",timing = t,x = x, y = y})
end

function particles.Accuracy(s,t,x,y)
    table.insert(Ps,{class = s,type = "accuracy",timing = t,x = x, y = y})
end


function particles.render(nowTime,scale)
    for i,obj in pairs(Ps) do
        local decay = nowTime-obj.timing
        if obj.type == "leftcircle" then
            local progress = math.min(decay/0.2,1)
            local scaling = progress*1.02
            if progress == 1 then Ps[i] = nil end
            circle.Create(v2.complete(obj.x,obj.y,scale+scaling,scale+scaling),1-progress)

            
        elseif obj.type == "miss" then
            local progress = math.min(decay/config.REACTION,1)
            local scaling = progress*4
            circle.Miss(v2.complete(obj.x,obj.y+progress*0.5,scaling,scaling),math.cos(progress^2*math.pi))
            if progress == 1 then Ps[i] = nil end
        elseif obj.type == "accuracy" then
            if obj.class == "s300" then Ps[i] = nil goto continue end
            local progress = math.min(decay/config.REACTION,1)
            local scaling = progress*4
            circle.Accuracy(obj.class,v2.complete(obj.x,obj.y+progress*0.5,scaling,scaling),math.cos(progress^2*math.pi))
            if progress == 1 then Ps[i] = nil end
        end
        ::continue::
    end
end

return particles