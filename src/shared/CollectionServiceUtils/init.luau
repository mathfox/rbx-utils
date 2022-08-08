local CollectionServiceUtils = {
	findFirstAncestorOfTag = require(script.findFirstAncestorOfTag),
	hasTags = require(script.hasTags),
	removeAllTags = require(script.removeAllTags),
}

--@block:dev:2 --no-lines-preserve
table.freeze(CollectionServiceUtils)

return CollectionServiceUtils
