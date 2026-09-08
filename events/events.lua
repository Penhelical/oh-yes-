local events = {}

events.addEvent = function(e)
	events[e.name] = e
	return true
end

return events