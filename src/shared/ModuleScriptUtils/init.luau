local ModuleScriptUtils = {
	loadChildren = require(script.loadChildren),
	loadChildrenFilter = require(script.loadChildrenFilter),
	loadDescendants = require(script.loadDescendants),
	loadDescendantsFilter = require(script.loadDescendantsFilter),
}
--@block:dev:start
table.freeze(ModuleScriptUtils)
--@block:dev:end

return ModuleScriptUtils
