return function()
	local PathWaypointUtils = require(script.Parent)

	it("should be a table", function()
		expect(PathWaypointUtils).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(PathWaypointUtils)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			PathWaypointUtils.NEW_FIELD = {}
		end).to.throw()

		expect(function()
			setmetatable(PathWaypointUtils, {})
		end).to.throw()
	end)
end
