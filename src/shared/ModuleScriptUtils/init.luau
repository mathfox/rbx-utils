local ModuleScriptUtils = {
	loadChildren = require(script.loadChildren),
	loadChildrenFilter = require(script.loadChildrenFilter),
	loadDescendants = require(script.loadDescendants),
	loadDescendantsFilter = require(script.loadDescendantsFilter),
}

--@block:dev:2
table.freeze(ModuleScriptUtils)

return ModuleScriptUtils
