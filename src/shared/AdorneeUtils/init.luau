local AdorneeUtils = {
	getAdorneeBasePartPosition = require(script.getAdorneeBasePartPosition),
	getAdorneeCenterPosition = require(script.getAdorneeCenterPosition),
	getAdorneeBasePartCFrame = require(script.getAdorneeBasePartCFrame),
	getAdorneeBoundingBox = require(script.getAdorneeBoundingBox),
	getAdorneeAlignedSize = require(script.getAdorneeAlignedSize),
	getAdorneeBaseParts = require(script.getAdorneeBaseParts),
	getAdorneeBasePart = require(script.getAdorneeBasePart),
	getRenderAdornee = require(script.getRenderAdornee),
	isPartOfAdornee = require(script.isPartOfAdornee),
}

--@block:dev:2 --no-lines-preserve
table.freeze(AdorneeUtils)

return AdorneeUtils
