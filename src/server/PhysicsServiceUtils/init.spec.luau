return function()
	local PhysicsServiceUtils = require(script.Parent)

	it("should be a table", function()
		expect(PhysicsServiceUtils).to.be.a("table")
	end)

	it("should not contain a metable", function()
		expect(getmetatable(PhysicsServiceUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			PhysicsServiceUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(PhysicsServiceUtils, {})
		end).to.throw()
	end)
end
