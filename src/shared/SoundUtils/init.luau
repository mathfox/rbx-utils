local SoundUtils = {
	promiseAllSoundsLoaded = require(script.promiseAllSoundsLoaded),
	promiseSoundLoaded = require(script.promiseSoundLoaded),
}

--@block:dev:2 --no-lines-preserve
table.freeze(SoundUtils)

return SoundUtils
