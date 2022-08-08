return function()
	local NumberSequenceUtils = require(script.Parent)

	it("should be a table", function()
		expect(NumberSequenceUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(NumberSequenceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			NumberSequenceUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(NumberSequenceUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			evaluateNumberSequence = "function",
			multiplyNumberSequence = "function",
		}

		expect(function()
			for key, value in NumberSequenceUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
