local RandomUtils = {
	getRandomFloat = require(script.getRandomFloat),
	getRandomInt = require(script.getRandomInt),
}

--@block:dev:2 --no-lines-preserve
table.freeze(RandomUtils)

return RandomUtils
