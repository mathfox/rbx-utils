local Symbol = require(script.Parent.Parent.Symbol)

local createSignal = require(script.Parent.createSignal)
local Type = require(script.Parent.Type)

local BindingImpl = Symbol("BindingImpl")

local BindingInternalApi = {}

local bindingPrototype = {}

function bindingPrototype:getValue()
	return BindingInternalApi.getValue(self)
end

function bindingPrototype:map(predicate)
	return BindingInternalApi.map(self, predicate)
end

local BindingPublicMeta = {
	__index = bindingPrototype,
	__tostring = function(self)
		return string.format("RoactBinding(%s)", tostring(self:getValue()))
	end,
}

--@block:dev:2
table.freeze(BindingPublicMeta)

function BindingInternalApi.update(binding, newValue)
	return binding[BindingImpl].update(newValue)
end

function BindingInternalApi.subscribe(binding, callback)
	return binding[BindingImpl].subscribe(callback)
end

function BindingInternalApi.getValue(binding)
	return binding[BindingImpl].getValue()
end

function BindingInternalApi.create(initialValue)
	local impl = {
		value = initialValue,
		changeSignal = createSignal(),
	}

	function impl.subscribe(callback)
		return impl.changeSignal:subscribe(callback)
	end

	function impl.update(newValue)
		impl.value = newValue
		impl.changeSignal:fire(newValue)
	end

	function impl.getValue()
		return impl.value
	end

	local binding = setmetatable({
		[Type] = Type.Binding,
		[BindingImpl] = impl,
	}, BindingPublicMeta)

	--@block:dev:2
	table.freeze(binding)

	return binding, impl.update
end

function BindingInternalApi.map(upstreamBinding, predicate)
	--@block:dev:6
	if Type.of(upstreamBinding) ~= Type.Binding then
		error("Expected arg #1 to be a binding", 2)
	elseif type(predicate) ~= "function" then
		error("Expected arg #1 to be a function", 2)
	end

	local impl = {}

	function impl.subscribe(callback)
		return BindingInternalApi.subscribe(upstreamBinding, function(newValue)
			callback(predicate(newValue))
		end)
	end

	function impl.update(_newValue)
		error("Bindings created by Binding:map(fn) cannot be updated directly", 2)
	end

	function impl.getValue()
		return predicate(upstreamBinding:getValue())
	end

	local binding = setmetatable({
		[Type] = Type.Binding,
		[BindingImpl] = impl,
	}, BindingPublicMeta)

	--@block:dev:2
	table.freeze(binding)

	return binding
end

function BindingInternalApi.join(upstreamBindings)
	--@block:dev:start
	if type(upstreamBindings) ~= "table" then
		error("Expected arg #1 to be of type table")
	end

	for key, value in upstreamBindings do
		if Type.of(value) ~= Type.Binding then
			error(("Expected arg #1 to contain only bindings, but key %q had a non-binding value"):format(tostring(key)), 2)
		end
	end
	--@block:dev:end
	local impl = {}

	local function getValue()
		local value = {}

		for key, upstream in upstreamBindings do
			value[key] = upstream:getValue()
		end

		return value
	end

	function impl.subscribe(callback)
		local disconnects = {}

		for key, upstream in upstreamBindings do
			disconnects[key] = BindingInternalApi.subscribe(upstream, function(_newValue)
				callback(getValue())
			end)
		end

		return function()
			if disconnects == nil then
				return
			end

			for _, disconnect in disconnects do
				disconnect()
			end

			disconnects = nil
		end
	end

	function impl.update(_newValue)
		error("Bindings created by joinBindings(...) cannot be updated directly", 2)
	end

	function impl.getValue()
		return getValue()
	end

	local binding = setmetatable({
		[Type] = Type.Binding,
		[BindingImpl] = impl,
	}, BindingPublicMeta)

	--@block:dev:2
	table.freeze(binding)

	return binding
end

--@block:dev:2
table.freeze(BindingInternalApi)

return BindingInternalApi
