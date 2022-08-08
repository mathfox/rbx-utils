-- A helper function to define a Rodux action creator with an associated name.

local Types = require(script.Parent.Parent.Types)

export type ActionCreator<Type, Action, Args...> = Types.RoduxActionCreator<Type, Action, Args...>

local function makeActionCreator<Type, Action, Args...>(name: Type, fn: (Args...) -> Action): ActionCreator<Type, Action, Args...>
	local actionCreator = { name = name }
	local actionCreatorMetatable = {
		__call = function(_, ...: Args...): Action & { type: Type }
			local result = fn(...)

			--@block:dev:4
			if type(result) ~= "table" then
				error("Invalid action: An action creator must return a table", 2)
			end

			result.type = name

			return result
		end,
	}

	setmetatable(actionCreator, actionCreatorMetatable)

	--@block:dev:3 --no-lines-preserve
	table.freeze(actionCreatorMetatable)
	table.freeze(actionCreator)

	return actionCreator
end

return makeActionCreator
