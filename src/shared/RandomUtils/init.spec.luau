return function()
	local RandomUtils = require(script.Parent)

	it("should be a table", function()
		expect(RandomUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(RandomUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			RandomUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(RandomUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			getRandomFloat = "function",
			getRandomInt = "function",
		}

		expect(function()
			for key, value in RandomUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
