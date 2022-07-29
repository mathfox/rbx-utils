-- A helper function to define a Rodux action creator with an associated name.

local Types = require(script.Parent.Parent.Types)

type ActionCreator<Type, Action, Args...> = Types.RoduxActionCreator<Type, Action, Args...>

local function makeActionCreator<Type, Action, Args...>(name: Type, fn: (Args...) -> Action): ActionCreator<Type, Action, Args...>
	local actionCreator = { name = name }
	local actionCreatorMetatable = {
		__call = function(_, ...: Args...): Action & { type: Type }
			local result = fn(...)

			--@block:dev:2
			assert(type(result) == "table", "Invalid action: An action creator must return a table")

			result.type = name

			return result
		end,
	}

	setmetatable(actionCreator, actionCreatorMetatable)

	--@block:dev:3
	table.freeze(actionCreatorMetatable)
	table.freeze(actionCreator)

	return actionCreator
end

return makeActionCreator
