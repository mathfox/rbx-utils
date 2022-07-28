local FunctionUtils = {
	bindArgs = require(script.bindArgs),
	noop = require(script.noop),
	returnArgs = require(script.returnArgs),
	void = require(script.void),
}

--@devblock:start
table.freeze(FunctionUtils)
--@devblock:end

return FunctionUtils
