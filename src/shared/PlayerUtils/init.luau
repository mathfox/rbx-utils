local PlayerUtils = {
	getAlivePlayerHumanoid = require(script.getAlivePlayerHumanoid),
	getAlivePlayerRootPart = require(script.getAlivePlayerRootPart),
	getFriendsList = require(script.getFriendsList),
	getOnlineFriendsList = require(script.getOnlineFriendsList),
	getPlayerFromCharacterDescendant = require(script.getPlayerFromCharacterDescendant),
	getPlayerHumanoid = require(script.getPlayerHumanoid),
	getPlayerRootPart = require(script.getPlayerRootPart),
   getPlayersInRadiusList = require(script.getPlayersInRadiusList),
	unequipPlayerTools = require(script.unequipPlayerTools),
}

--@block:dev:2
table.freeze(PlayerUtils)

return PlayerUtils
