return function()
	local doesCollisionGroupWithNameExist = require(script.Parent)

	it("should be a function", function()
		expect(doesCollisionGroupWithNameExist).to.be.a("function")
	end)
end
