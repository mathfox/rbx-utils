local Types = require(script.Parent.Parent.Types)

local Children = require(script.Parent.PropMarkers.Children)
local ElementKind = require(script.Parent.ElementKind)
local Logging = require(script.Parent.Logging)
local Type = require(script.Parent.Type)

type FunctionComponent = Types.RoactFunctionComponent
type StatefulComponent = Types.RoactStatefulComponent
type Element = Types.RoactElement

local multipleChildrenMessage = [[
The prop `Roact.Children` was defined but was overridden by the third parameter to createElement!
This can happen when a component passes props through to a child element but also uses the `children` argument:

	Roact.createElement("Frame", passedProps, {
		child = ...
	})

Instead, consider using a utility function to merge tables of children together:

	local children = mergeTables(passedProps[Roact.Children], {
		child = ...
	})

	local fullProps = mergeTables(passedProps, {
		[Roact.Children] = children
	})

	Roact.createElement("Frame", fullProps)]]

--[[
	Creates a new element representing the given component.

	Elements are lightweight representations of what a component instance should
	look like.

	Children is a shorthand for specifying `Roact.Children` as a key inside
	props. If specified, the passed `props` table is mutated!
]]
local function createElement(component: string | FunctionComponent | StatefulComponent, props: { [any]: any }?, children: { [any]: any }?): Element
	--@block:dev:8
	if component == nil then
		error('"component" argument is required', 2)
	elseif type(props) ~= "table" and props ~= nil then
		error('"props" must be either a table or nil', 2)
	elseif type(children) ~= "table" and children ~= nil then
		error('"children" must be either a table or nil', 2)
	end

	if props == nil then
		props = {}
	end

	if children ~= nil then
		if props[Children] ~= nil then
			Logging.warnOnce(multipleChildrenMessage)
		end

		props[Children] = children
	end

	local element = {
		[Type] = Type.Element,
		[ElementKind] = ElementKind.fromComponent(component),
		component = component,
		props = props,
		--@block:elementTracing:3 --path=.Parent
		-- We trim out the leading newline since there's no way to specify the
		-- trace level without also specifying a message.
		source = debug.traceback("", 2):sub(2),
	}

	--@block:dev:2
	table.freeze(element)

	return element
end

return createElement
