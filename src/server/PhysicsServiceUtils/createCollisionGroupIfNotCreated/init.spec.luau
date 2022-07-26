return function()
	local createCollisionGroupIfNotCreated = require(script.Parent)

	it("should be a function", function()
		expect(createCollisionGroupIfNotCreated).to.be.a("function")
	end)
end
