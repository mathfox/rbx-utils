local Types = require(script.Parent.Parent.Types)

local ElementKind = require(script.Parent.ElementKind)
local Type = require(script.Parent.Type)

type ElementImpl = Types.RoactElementImpl
type Fragment = Types.RoactFragment

local function createFragment(elements: { [any]: ElementImpl }): Fragment
	--@block:dev:2
	table.freeze(elements)

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
