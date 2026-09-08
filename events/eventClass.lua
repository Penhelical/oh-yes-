local events = require("events.events")

local eventClass = {}
eventClass.__index = eventClass

function eventClass.new(name)
	local self = setmetatable({},eventClass)
	self.name = name
	self.functions = {}
	events.addEvent(self)
	return self
end

function eventClass:connect(func)
	table.insert(self.functions,func)
	self.inprocess = function(args)
		for i,f in pairs(self.functions) do
			f(args)
		end
	end
end
return eventClass