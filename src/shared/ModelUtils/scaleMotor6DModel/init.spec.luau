return function()
	local scaleMotor6DModel = require(script.Parent)

	it("should be a function", function()
		expect(scaleMotor6DModel).to.be.a("function")
	end)
end
