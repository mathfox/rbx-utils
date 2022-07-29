local HumanoidUtils = {
	getAliveHumanoidFromDescendant = require(script.getAliveHumanoidFromDescendant),
	getAliveHumanoidFromModel = require(script.getAliveHumanoidFromModel),
	getAliveRootPartFromDescendant = require(script.getAliveRootPartFromDescendant),
	getAliveRootPartFromModel = require(script.getAliveRootPartFromModel),
	healHumanoid = require(script.healHumanoid),
	scaleHumanoid = require(script.scaleHumanoid),
	teleportHumanoidToCFrame = require(script.teleportHumanoidToCFrame),
	teleportHumanoidToPosition = require(script.teleportHumanoidToPosition),
}

--@block:dev:2
table.freeze(HumanoidUtils)

return HumanoidUtils
