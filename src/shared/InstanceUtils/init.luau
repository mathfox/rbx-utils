local InstanceUtils = {
	clearAllChildrenOfClass = require(script.clearAllChildrenOfClass),
	clearAllChildrenWhichIsA = require(script.clearAllChildrenWhichIsA),
	clearAllDescendantsOfClass = require(script.clearAllDescendantsOfClass),
	clearAllDescendantsWhichIsA = require(script.clearAllDescendantsWhichIsA),
	clearChildrenByPredicate = require(script.clearChildrenByPredicate),
	clearDescendantsByPredicate = require(script.clearDescendantsByPredicate),
	findFirstDescendantOfClass = require(script.findFirstDescendantOfClass),
	findFirstDescendantWhichIsA = require(script.findFirstDescendantWhichIsA),
	getChildrenOfClass = require(script.getChildrenOfClass),
	getChildrenWhichIsA = require(script.getChildrenWhichIsA),
	getDescendantsOfClass = require(script.getDescendantsOfClass),
	getDescendantsWhichIsA = require(script.getDescendantsWhichIsA),
	waitForChildOfClass = require(script.waitForChildOfClass),
	waitForChildWhichIsA = require(script.waitForChildWhichIsA),
	waitForDescendantOfClass = require(script.waitForDescendantOfClass),
	waitForDescendantWhichIsA = require(script.waitForDescendantWhichIsA),
	waitUntilParentedTo = require(script.waitUntilParentedTo),
}

--@block:dev:2
table.freeze(InstanceUtils)

return InstanceUtils
