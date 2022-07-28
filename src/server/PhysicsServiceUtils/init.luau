local PhysicsServiceUtils = {
	createCollisionGroupIfNotCreated = require(script.createCollisionGroupIfNotCreated),
	doesCollisionGroupWithIdExist = require(script.doesCollisionGroupWithIdExist),
	doesCollisionGroupWithNameExist = require(script.doesCollisionGroupWithNameExist),
}

--@block:dev:start
table.freeze(PhysicsServiceUtils)
--@block:dev:end

return PhysicsServiceUtils
