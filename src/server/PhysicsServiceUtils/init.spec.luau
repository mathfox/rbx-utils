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
			PhysicsServiceUtils.newField = {}
		end).to.throw()

		expect(function()
			setmetatable(PhysicsServiceUtils, {})
		end).to.throw()
	end)

	it("should expose only known APIs", function()
		local knownAPIs = {
			createCollisionGroupIfNotCreated = "function",
			doesCollisionGroupWithIdExist = "function",
			doesCollisionGroupWithNameExist = "function",
		}

		expect(function()
			for key, value in PhysicsServiceUtils do
				assert(type(value) == knownAPIs[key])
			end
		end).never.throw()
	end)
end
