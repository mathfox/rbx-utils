local PlayerUtils = {
	getFriendsList = require(script.getFriendsList),
	getOnlineFriendsList = require(script.getOnlineFriendsList),
	getPlayerFromCharacterDescendant = require(script.getPlayerFromCharacterDescendant),
}

--@block:dev:2 --no-lines-preserve
table.freeze(PlayerUtils)

return PlayerUtils
