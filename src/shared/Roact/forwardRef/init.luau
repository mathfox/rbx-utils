local assign = require(script.Parent.Parent.TableUtils.assign)
local Option = require(script.Parent.Parent.Option)
local Types = require(script.Parent.Parent.Types)

local Ref = require(script.Parent.PropMarkers.Ref)

type Element = Types.RoactElement
type Ref = Types.RoactRef

local excludeRef = {
	[Ref] = Option.None,
}

--[[
	Allows forwarding of refs to underlying host components. Accepts a render
	callback which accepts props and a ref, and returns an element.
]]
local function forwardRef(render: ({ [any]: any }, Ref) -> Element?)
	--@block:dev:4
	if type(render) ~= "function" then
		error("Expected arg #1 to be a function", 2)
	end

	return function(props: { [any]: any })
		local ref = props[Ref]
		local propsWithoutRef = assign({}, props, excludeRef)

		return render(propsWithoutRef, ref)
	end
end

return forwardRef
