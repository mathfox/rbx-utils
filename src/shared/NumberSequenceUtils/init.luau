local NumberSequenceUtils = {
	multiplyNumberSequence = require(script.multiplyNumberSequence),
	evaluateNumberSequence = require(script.evaluateNumberSequence),
}
--@block:dev:start
table.freeze(NumberSequenceUtils)
--@block:dev:end

return NumberSequenceUtils
