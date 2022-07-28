local CollectionServiceUtils = {
	findFirstAncestorOfTag = require(script.findFirstAncestorOfTag),
	removeAllTags = require(script.removeAllTags),
	hasTags = require(script.hasTags),
}

--@block:dev:start
table.freeze(CollectionServiceUtils)
--@block:dev:end

return CollectionServiceUtils
