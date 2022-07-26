return function()
	local scaleModel = require(script.Parent)

	it("should be a function", function()
		expect(scaleModel).to.be.a("function")
	end)
end
