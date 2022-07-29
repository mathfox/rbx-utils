local NumberSequenceUtils = {
	multiplyNumberSequence = require(script.multiplyNumberSequence),
	evaluateNumberSequence = require(script.evaluateNumberSequence),
}

--@block:dev:2
table.freeze(NumberSequenceUtils)

return NumberSequenceUtils
