return function()
	local OverlapParamsUtils = require(script.Parent)

	it("should be a table", function()
		expect(OverlapParamsUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(OverlapParamsUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			OverlapParamsUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(OverlapParamsUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			cloneOverlapParams = "function",
		}

		expect(function()
			for key, value in OverlapParamsUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
