local Types = require(script.Parent.Parent.Types)

local ElementKind = require(script.Parent.ElementKind)
local Type = require(script.Parent.Type)

type Fragment = Types.RoactFragment
type Element = Types.RoactElement

local function createFragment(elements: { [any]: Element }): Fragment
	local fragment = {
		[Type] = Type.Element,
		[ElementKind] = ElementKind.Fragment,
		elements = elements,
	}

	--@block:dev:2
	table.freeze(fragment)

	return fragment
end

return createFragment
