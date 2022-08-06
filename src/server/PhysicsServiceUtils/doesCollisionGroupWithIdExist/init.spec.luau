return function()
	local doesCollisionGroupWithIdExist = require(script.Parent)

	it("should be a function", function()
		expect(doesCollisionGroupWithIdExist).to.be.a("function")
	end)
end
