local RandomUtils = {
	getRandomFloat = require(script.getRandomFloat),
	getRandomInt = require(script.getRandomInt),
}

--@block:dev:2
table.freeze(RandomUtils)

return RandomUtils
