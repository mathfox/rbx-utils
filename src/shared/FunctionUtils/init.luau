local FunctionUtils = {
	bindArgs = require(script.bindArgs),
	noop = require(script.noop),
	returnArgs = require(script.returnArgs),
	void = require(script.void),
}

--@block:dev:start
table.freeze(FunctionUtils)
--@block:dev:end

return FunctionUtils
