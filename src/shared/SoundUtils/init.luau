local SoundUtils = {
	promiseAllSoundsLoaded = require(script.promiseAllSoundsLoaded),
	promiseSoundLoaded = require(script.promiseSoundLoaded),
}
--@block:dev:start
table.freeze(SoundUtils)
--@block:dev:end

return SoundUtils
