return function()
	local PlayerUtils = require(script.Parent)

	it("should be a table", function()
		expect(PlayerUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(PlayerUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			PlayerUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(PlayerUtils, {})
		end).to.throw()
	end)

	it("should expose known APIs", function()
		local knownAPIs = {
			getAlivePlayerHumanoid = "function",
			getAlivePlayerRootPart = "function",
			getFriendsList = "function",
			getOnlineFriendsList = "function",
			getPlayerFromCharacterDescendant = "table",
			getPlayerHumanoid = "function",
			getPlayerRootPart = "function",
			getPlayersInRadiusList = "function",
			unequipPlayerTools = "function",
		}

		expect(function()
			for key, value in PlayerUtils do
				assert(knownAPIs[key] ~= nil)
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
