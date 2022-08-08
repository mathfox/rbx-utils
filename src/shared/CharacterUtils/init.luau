local CharacterUtils = {
	getAlivePlayerHumanoid = require(script.getAlivePlayerHumanoid),
	getAlivePlayerRootPart = require(script.getAlivePlayerRootPart),
	getPlayerHumanoid = require(script.getPlayerHumanoid),
	getPlayerRootPart = require(script.getPlayerRootPart),
	unequipPlayerTools = require(script.unequipPlayerTools),
}

--@block:dev:2 --no-lines-preserve
table.freeze(CharacterUtils)

return CharacterUtils
