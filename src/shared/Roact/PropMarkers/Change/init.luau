--[[
	Change is used to generate special prop keys that can be used to connect to
	GetPropertyChangedSignal.

	Generally, Change is indexed by a Roblox property name:

		Roact.createElement("TextBox", {
			[Roact.Change.Text] = function(rbx)
				print("The TextBox", rbx, "changed text to", rbx.Text)
			end,
		})
]]

local Type = require(script.Parent.Parent.Type)

local Change = {}

local changeInstanceMetatable = {
	__tostring = function(self)
		return ("RoactHostChangeEvent(%s)"):format(self.name)
	end,
}

local ChangeMetatable = {
	__index = function(_, propertyName)
		local changeListener = {
			[Type] = Type.HostChangeEvent,
			name = propertyName,
		}

		setmetatable(changeListener, changeInstanceMetatable)
		Change[propertyName] = changeListener

		return changeListener
	end,
}

setmetatable(Change, ChangeMetatable)

--@block:dev:3 --no-lines-preserve
table.freeze(changeInstanceMetatable)
table.freeze(ChangeMetatable)

return Change
