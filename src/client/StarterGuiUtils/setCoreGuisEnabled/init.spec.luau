return function()
	local setCoreGuisEnabled = require(script.Parent)

	it("should be a function", function()
		expect(setCoreGuisEnabled).to.be.a("function")
	end)
end
