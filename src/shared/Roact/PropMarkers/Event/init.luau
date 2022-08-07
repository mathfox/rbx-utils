--[[
	Index into `Event` to get a prop key for attaching to an event on a Roblox
	Instance.

	Example:

		Roact.createElement("TextButton", {
			Text = "Hello, world!",

			[Roact.Event.MouseButton1Click] = function(rbx)
				print("Clicked", rbx)
			end
		})
]]

local Type = require(script.Parent.Parent.Type)

local Event = {}

local eventInstanceMetatable = {
	__tostring = function(self)
		return ("RoactHostEvent(%s)"):format(self.name)
	end,
}

local EventMetatable = {
	__index = function(_, eventName)
		local event = {
			[Type] = Type.HostEvent,
			name = eventName,
		}

		setmetatable(event, eventInstanceMetatable)

		Event[eventName] = event

		return event
	end,
}

setmetatable(Event, EventMetatable)

--@block:dev:3 --no-lines-preserve
table.freeze(eventInstanceMetatable)
table.freeze(EventMetatable)
table.freeze(Event)

return Event
