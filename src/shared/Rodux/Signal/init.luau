--[[
	A limited, simple implementation of a Signal.

	Handlers are fired in order, and (dis)connections are properly handled when
	executing an event.
]]

local Types = require(script.Parent.Parent.Types)

type Store<State = any> = Types.RoduxStore<State>

local function immutableRemoveValue(list, removeValue)
	local new = {}

	for i = 1, #list do
		if list[i] ~= removeValue then
			table.insert(new, list[i])
		end
	end

	return new
end

type Listener = {
	callback: (...any) -> ...any,
	disconnected: boolean,
	connectTraceback: string,
	disconnectTraceback: string?,
}

type SignalImpl = {
	__index: SignalImpl,

	_fire: (self: Signal) -> (),

	connect: (self: Signal) -> (),
}
type Signal = typeof(setmetatable({} :: {
	_listeners: { Listener },
	-- TODO: store type
	_store: any,
}, {} :: SignalImpl))

local SignalImpl = {}
SignalImpl.__index = SignalImpl

function SignalImpl:connect(callback: (...any) -> ...any)
	--@block:dev:4
	if type(callback) ~= "function" then
		error("invalid #1 argument, expected a function", 2)
	end

	if self._store and self._store._isDispatching then
		error(
			"You may not call store.changed:connect() while the reducer is executing. "
				.. "If you would like to be notified after the store has been updated, subscribe from a "
				.. "component and invoke store:getState() in the callback to access the latest state. ",
			2
		)
	end

	local listener = {
		callback = callback,
		disconnected = false,
		connectTraceback = debug.traceback(nil, 2),
		disconnectTraceback = nil,
	}

	local newListeners = table.clone(self._listeners)
	table.insert(newListeners, listener)
	self._listeners = newListeners

	return function()
		if listener.disconnected then
			error(("Listener connected at: \n%s\n" .. "was already disconnected at: \n%s\n"):format(tostring(listener.connectTraceback), tostring(listener.disconnectTraceback)), 2)
		end

		if self._store and self._store._isDispatching then
			error("You may not unsubscribe from a store listener while the reducer is executing.", 2)
		end

		listener.disconnected = true
		listener.disconnectTraceback = debug.traceback()
		self._listeners = immutableRemoveValue(self._listeners, listener)
	end
end

function SignalImpl:_fire(newState, prevState)
	for _, listener in self._listeners do
		if not listener.disconnected then
			local co = coroutine.create(listener.callback)
			local ok, message = coroutine.resume(co, newState, prevState)
			if not ok then
				error(message, 2)
			elseif coroutine.status(co) ~= "dead" then
				error(('Attempted to yield inside a "changed" connection which was connected at:\n%s'):format(listener.connectTraceback), 2)
			end
		end
	end
end

--@block:dev:2
table.freeze(SignalImpl)

local Signal = {}

function Signal.new(store: Store): Signal
	local signal = setmetatable({
		_listeners = {},
		_store = store,
	}, SignalImpl)

	--@block:dev:2 --no-lines-preserve
	table.freeze(signal)

	return signal
end

--@block:dev:2 --no-lines-preserve
table.freeze(Signal)

return Signal
