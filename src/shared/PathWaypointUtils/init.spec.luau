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
			PathWaypointUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(PathWaypointUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			getPathWaypointsMagnitude = "function",
		}

		expect(function()
			for key, value in PathWaypointUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
