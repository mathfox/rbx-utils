local Types = require(script.Parent.Parent.Types)

export type Reducer<State, Action> = Types.RoduxReducer<State, Action>
type AnyAction = Types.RoduxAnyAction

local function createReducer<State>(initialState: State, handlers: { [any]: (State, AnyAction) -> State }): Reducer<State, AnyAction>
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
