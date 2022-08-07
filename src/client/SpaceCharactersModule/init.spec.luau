return function()
	local SpaceCharactersModule = require(script.Parent)

	it("should be a table", function()
		expect(SpaceCharactersModule).to.be.a("table")
	end)

	it("should not contain a metatable", function(n)
		expect(getmetatable(SpaceCharactersModule)).to.equal(nil)
	end)
end
