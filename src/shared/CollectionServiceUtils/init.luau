local CollectionServiceUtils = {
	findFirstAncestorOfTag = require(script.findFirstAncestorOfTag),
	removeAllTags = require(script.removeAllTags),
	hasTags = require(script.hasTags),
}

--@block:dev:2 --no-lines-preserve
table.freeze(CollectionServiceUtils)

return CollectionServiceUtils
