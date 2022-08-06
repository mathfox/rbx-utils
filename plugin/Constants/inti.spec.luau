return function()
	local Constants = require(script.Parent)

	it("should be a table", function()
		expect(Constants).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(Constants)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Constants._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Constants, {})
		end).to.throw()
	end)
end
