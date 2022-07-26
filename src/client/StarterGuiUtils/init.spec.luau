return function()
	local StarterGuiUtils = require(script.Parent)

	it("should be a table", function()
		expect(StarterGuiUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(StarterGuiUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			StarterGuiUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(StarterGuiUtils, {})
		end).to.throw()
	end)
end
