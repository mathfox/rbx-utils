--[[
	Contains markers for annotating objects with types.

	To set the type of an object, use `Type` as a key and the actual marker as
	the value:

		local foo = {
			[Type] = Type.Foo,
		}
]]

local Symbol = require(script.Parent.Parent.Symbol)

local Type = {}

local TypeInternal = {}

local function addType(name: string)
	TypeInternal[name] = Symbol("Roact" .. name)
end

addType("Binding")
addType("Element")
addType("HostChangeEvent")
addType("HostEvent")
addType("StatefulComponentClass")
addType("StatefulComponentInstance")
addType("VirtualNode")
addType("VirtualTree")

function TypeInternal.of(value)
	return if type(value) ~= "table" then nil else value[Type]
end

local TypeMetatable = {
	__index = TypeInternal,
	__tostring = function()
		return "RoactType"
	end,
}

setmetatable(Type, TypeMetatable)

--@block:dev:4
table.freeze(TypeInternal)
table.freeze(TypeMetatable)
table.freeze(Type)

return Type
