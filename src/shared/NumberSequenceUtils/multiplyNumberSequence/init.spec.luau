return function()
	local multiplyNumberSequence = require(script.Parent)

	it("should be a function", function()
		expect(multiplyNumberSequence).to.be.a("function")
	end)
end
