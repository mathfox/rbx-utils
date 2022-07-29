local FunctionUtils = {
	bindArgs = require(script.bindArgs),
	noop = require(script.noop),
	returnArgs = require(script.returnArgs),
	void = require(script.void),
}

--@block:dev:2
table.freeze(FunctionUtils)

return FunctionUtils
