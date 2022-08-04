local ModuleScriptUtils = {
	loadChildren = require(script.loadChildren),
	loadChildrenFilter = require(script.loadChildrenFilter),
	loadDescendants = require(script.loadDescendants),
	loadDescendantsFilter = require(script.loadDescendantsFilter),
}

--@block:dev:2 --no-lines-preserve
table.freeze(ModuleScriptUtils)

return ModuleScriptUtils
