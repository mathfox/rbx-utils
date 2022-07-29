local PhysicsServiceUtils = {
	createCollisionGroupIfNotCreated = require(script.createCollisionGroupIfNotCreated),
	doesCollisionGroupWithIdExist = require(script.doesCollisionGroupWithIdExist),
	doesCollisionGroupWithNameExist = require(script.doesCollisionGroupWithNameExist),
}

--@block:dev:2
table.freeze(PhysicsServiceUtils)

return PhysicsServiceUtils
