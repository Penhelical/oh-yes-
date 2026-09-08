local events = require("events.events")
local Color3 = require("libs.color3")
local v2 = require("ui.v2")
local config = require("config")
local general = require("ui.general")
local uisystem = require("ui.uisystem")
local animator = require("ui.animator")


return function(key)
	uisystem.affectAll("difficulty",function(obj)
			animator.Animate(obj,{pos = obj.pos + v2.y(key == "down" and -50 or 50)},0.2,false)
	end)
end