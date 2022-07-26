return function()
	local evaluateNumberSequence = require(script.Parent)

	it("should be a function", function()
		expect(evaluateNumberSequence).to.be.a("function")
	end)
end
