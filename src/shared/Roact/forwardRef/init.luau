local assign = require(script.Parent.Parent.TableUtils.assign)
local Option = require(script.Parent.Parent.Option)

local Ref = require(script.Parent.PropMarkers.Ref)

local excludeRef = {
	[Ref] = Option.None,
}

--[[
	Allows forwarding of refs to underlying host components. Accepts a render
	callback which accepts props and a ref, and returns an element.
]]
-- TODO: proper function type
local function forwardRef(render: (...any) -> (...any))
	--@block:dev:4
	if type(render) ~= "function" then
		error("Expected arg #1 to be a function", 2)
	end

	return function(props)
		local ref = props[Ref]
		local propsWithoutRef = assign({}, props, excludeRef)

		return render(propsWithoutRef, ref)
	end
end

return forwardRef
