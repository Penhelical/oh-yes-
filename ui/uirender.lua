local uirender = {}
local config = require("config")
local uiloader = require("ui.main")
local uisystem = require("ui.uisystem")

local a = true
uirender.Render = function()
	local todraw = {}
	local order = {}
	for ap,rendergroup in pairs(uisystem.renderGroups) do
		local group = uisystem[rendergroup]
		if not group then goto next end
		for _,layer in pairs(group) do
			if not todraw[_] then todraw[_] = {} end

			for i,obj in pairs(layer) do
				local r,g,b,a = 255,255,255,255
				if obj == nil or obj.Visible == false then goto continue end
				table.insert(todraw[_],obj)
				::continue::
			end
		end
		::next::
	end
	local keys = {}

	for _,layer in pairs(todraw) do
		table.insert(keys,_)
	end
	table.sort(keys)

	for _,layer in ipairs(keys) do
		local layer = todraw[keys[_]]
		for i,obj in pairs(layer) do
			if obj.type == "text" and config.SHOW_TEXT then
				r,g,b,a = obj.color:get()
				if obj.drawInstance == nil or obj.NewText ~= obj.Text then
					if obj.NewText then obj.Text = obj.NewText end
					obj.drawInstance = love.graphics.newText( obj.TextFont, obj.Text )
				end
				love.graphics.setColor(r,g,b,a)
				love.graphics.draw(obj.drawInstance,obj.pos.x,obj.pos.y,0,obj.scale.x,obj.scale.y)
			elseif obj.type == "rectangle" then
				r,g,b,a = obj.color:get()
				love.graphics.setColor(r,g,b,a)
				love.graphics.rectangle(obj.mode,obj.pos.x,obj.pos.y,obj.size.x*obj.scale.x,obj.size.y*obj.scale.y)
			elseif obj.type == "image" then
			    r,g,b,a = obj.color:get()
				if obj.drawInstance == nil then
					obj.drawInstance = love.graphics.newImage(obj.path)
				end
				local scaleX = config.RESOLUTION_X/obj.drawInstance:getWidth()
				local scaleY = config.RESOLUTION_Y/obj.drawInstance:getHeight()
				love.graphics.setColor(r,g,b,a)
				love.graphics.draw(obj.drawInstance,obj.pos.x,obj.pos.y,0,scaleX,scaleY)
			end
		end
	end
	

end

return uirender