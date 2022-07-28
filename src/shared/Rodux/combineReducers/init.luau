local Types = require(script.Parent.Parent.Types)

type Reducer<State, Action> = Types.RoduxReducer<State, Action>
type AnyAction = Types.RoduxAnyAction

-- Creates a composite reducer from a map of keys and sub-reducers.
local function combineReducers(map: { [any]: Reducer<any, AnyAction> }): Reducer<any, AnyAction>
	-- @typeChecksStart
	if type(map) ~= "table" then
		error(('invalid type of "map" (#1 argument), expected a table, got (%s) instead'):format(type(map)), 2)
	end
	-- @typeChecksEnd
	return function(state: { [any]: any }?, action: AnyAction)
		local newState = {}

		for key, reducer in map do
			-- Each reducer gets its own state, not the entire state table
			newState[key] = reducer(if state then state[key] else nil, action)
		end

		return newState
	end
end

return combineReducers
