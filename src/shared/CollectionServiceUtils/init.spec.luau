return function()
	local CollectionServiceUtils = require(script.Parent)

	it("should be a table", function()
		expect(CollectionServiceUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(CollectionServiceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			CollectionServiceUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(CollectionServiceUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			findFirstAncestorOfTag = "function",
			hasTags = "function",
			removeAllTags = "function",
		}

		expect(function()
			for key, value in CollectionServiceUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
