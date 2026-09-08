local v2 = require("ui.v2")
local Color3 = require("libs.color3")
local config = require("config")
local assets = require("assetloader")
local events = require("events.events")
local eventClass = require("events.eventClass")
local hitbox = require("ui.hitbox")
local uisystem = require("ui.uisystem")

local UIclass = {}
UIclass.__index = UIclass



function UIclass.rectangle(pos)
	local n = setmetatable({},UIclass)
	n.__index = n
	n.type = "rectangle"
	n.color = Color3.new(255,255,255,255)
	n.pos = pos or v2.new()
	n.size = v2.new(100,100)
	n.mode = "fill"
	n.scale = v2.new(1,1)
	n.rotate = rotate or 0
	n.Button = false
	n.z = 1

	--Border
	n.Border = false
	n.BorderScale = 1.01
	n.BorderColor = nil
	n.BorderOffset = v2.new()
	return n
end

function UIclass.text(text,pos)
	local n = setmetatable({},UIclass)
	n.__index = n
	n.type = "text"
	n.pos = pos or v2.new()
	n.color = Color3.new(255,255,255)
	n.TextFont = assets.fonts.HappyMorin
	n.Text = "Lorem Ipsum"
	n.scale = v2.new(1,1)
	n.rotate = rotate or 0
	n.z = 1
	return n
end

function UIclass.image(imagepath,pos)
	local n = setmetatable({},UIclass)
	n.__index = n
	n.path = imagepath
	n.type = "image"
	n.pos = pos or v2.new()
	n.color = Color3.new(255,255,255)
	n.TextFont = assets.fonts.HappyMorin
	n.Text = "Lorem Ipsum"
	n.scale = v2.new(1,1)
	n.rotate = rotate or 0
	n.z = 1
	return n
end


function UIclass:clone()
	local clone = setmetatable({},{})
	for i,setting in pairs(self) do
		clone[i] = setting
	end
	clone.__index = clone
	return clone
end

function UIclass:render(group)
	if not group or type("group") ~= "string" then group = "objects" end
	local layer,n = uisystem.AddObject(self,group)
	self.n = n 
	self.group = group
	if self.Border then
		local border = self:clone()
		local pos = border.pos
		border.size = border.size * border.BorderScale
		if border.BorderAtMiddle then
			border.pos = self.pos/2
		end
		border.pos = pos + border.BorderOffset
		
		border.color = border.BorderColor
		--border.z = self.z - 1

		uisystem.AddObject(border)
	end
	if self.BackgroundEnabled == true then
		self.Background = UIclass.rectangle(pos)
		self.Background.pos = self.pos
		self.Background.z = self.z - 1
		self.Background.color = self.BackgroundColor or self.Background.color 
		self.Background.range = self.range 
		self.Background.size = v2.new((self.Text and #self.Text or 0) * 22 *self.scale.x,self.scale.y*25)
		self.Background.pos = self.pos - self.Background.size/2
		self.Background:render(group)
	end
	if self.Button == true then
		self.LeftClickEvent = eventClass.new("00000"..tostring(#events).."guibutton".."LeftClick")
		events.leftclick:connect(function(args)
			x = args[1]
			y = args[2]
			if hitbox.Check(v2.new(x,y),self.pos,self.size) then
				if self.LeftClickEvent.inprocess then self.LeftClickEvent.inprocess(args) end
			end
		end)
	end
	return layer,n
end

function UIclass:destroy()
	uisystem.Destroy(self.group,self.z,self.n)
end

function UIclass:Destroy()
	uisystem.Destroy(self.group,self.z,self.n)
end
return UIclass