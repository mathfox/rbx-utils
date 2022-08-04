local NumberSequenceUtils = {
	multiplyNumberSequence = require(script.multiplyNumberSequence),
	evaluateNumberSequence = require(script.evaluateNumberSequence),
}

--@block:dev:2 --no-lines-preserve
table.freeze(NumberSequenceUtils)

return NumberSequenceUtils
