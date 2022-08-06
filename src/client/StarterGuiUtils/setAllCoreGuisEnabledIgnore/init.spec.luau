return function()
	local setAllCoreGuisEnabledIgnore = require(script.Parent)

	it("should be a function", function()
		expect(setAllCoreGuisEnabledIgnore).to.be.a("function")
	end)
end
