-- modified version of https://github.com/Roblox/roact-rodux

local RoactRodux = {
	StoreProvider = require(script.StoreProvider),
	StoreContext = require(script.StoreContext),
	connect = require(script.connect),
}

--@block:dev:2
table.freeze(RoactRodux)

return RoactRodux
