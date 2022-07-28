local CharacterUtils = {
	getAlivePlayerHumanoid = require(script.getAlivePlayerHumanoid),
	getAlivePlayerRootPart = require(script.getAlivePlayerRootPart),
	getPlayerFromCharacterDescendant = require(script.getPlayerFromCharacterDescendant),
	getPlayerHumanoid = require(script.getPlayerHumanoid),
	getPlayerRootPart = require(script.getPlayerRootPart),
	unequipPlayerTools = require(script.unequipPlayerTools),
}
--@block:dev:start
table.freeze(CharacterUtils)
--@block:dev:end

return CharacterUtils
