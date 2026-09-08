local eventClass = require("events.eventClass")

local eventloader = {}

eventloader.load = function()
	local mousepressed = eventClass.new("leftclick")
	local arrowdown = eventClass.new("arrow")
	local newEvent = eventClass.new("Enter")
	function love.mousereleased(x, y, button, istouch, presses)
		if button ~= 1 then return end
		local args = {x, y, istouch, presses}
		if mousepressed.inprocess then mousepressed.inprocess(args) end
	end
	
end

return eventloader