local CharacterUtils = {
	getAlivePlayerHumanoid = require(script.getAlivePlayerHumanoid),
	getAlivePlayerRootPart = require(script.getAlivePlayerRootPart),
	getPlayerFromCharacterDescendant = require(script.getPlayerFromCharacterDescendant),
	getPlayerHumanoid = require(script.getPlayerHumanoid),
	getPlayerRootPart = require(script.getPlayerRootPart),
	unequipPlayerTools = require(script.unequipPlayerTools),
}

--@block:dev:2
table.freeze(CharacterUtils)

return CharacterUtils
