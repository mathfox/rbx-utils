local Symbol = require(script.Parent.Parent.Symbol)

local ComponentLifecyclePhase = {
	-- Component methods
	Init = Symbol("init"),
	Render = Symbol("render"),
	ShouldUpdate = Symbol("shouldUpdate"),
	WillUpdate = Symbol("willUpdate"),
	DidMount = Symbol("didMount"),
	DidUpdate = Symbol("didUpdate"),
	WillUnmount = Symbol("willUnmount"),

	-- Phases describing reconciliation status
	ReconcileChildren = Symbol("reconcileChildren"),
	Idle = Symbol("idle"),
}

--@block:dev:2 --no-lines-preserve
table.freeze(ComponentLifecyclePhase)

return ComponentLifecyclePhase
