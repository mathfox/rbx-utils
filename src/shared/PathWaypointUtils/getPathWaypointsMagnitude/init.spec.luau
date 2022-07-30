return function()
	local getPathWaypointsMagnitude = require(script.Parent)

	it("should expose a function", function()
		expect(getPathWaypointsMagnitude).to.be.a("function")
	end)

	it("should throw an error in case empty table provided", function()
		expect(function()
			getPathWaypointsMagnitude({})
		end).to.throw()
	end)
end
