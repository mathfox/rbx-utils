return function()
	local SoundUtils = require(script.Parent)

	it("should be a table", function()
		expect(SoundUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(SoundUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			SoundUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(SoundUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			promiseAllSoundsLoaded = "function",
			promiseSoundLoaded = "function",
		}

		expect(function()
			for key, value in SoundUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
