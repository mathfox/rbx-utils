local Types = require(script.Parent.Parent.Types)

type Reducer<State, Action> = Types.RoduxReducer<State, Action>
type AnyAction = Types.RoduxAnyAction

local function createReducer<State>(initialState: State, handlers: { [any]: (State, AnyAction) -> State }): Reducer<State, AnyAction>
	-- @typeChecksStart
	if initialState == nil then
		error('"initialState" (#1 argument) can not be nil', 2)
	end
	-- @typeChecksEnd
	return function(state: State?, action: AnyAction)
		if state == nil then
			state = initialState
		end

		local handler = handlers[action.type]
		if handler then
			return handler(state, action)
		end

		return state
	end
end

return createReducer
