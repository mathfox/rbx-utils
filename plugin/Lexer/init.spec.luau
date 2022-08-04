return function()
	local Lexer = require(script.Parent)

	it("should be a table", function()
		expect(Lexer).to.be.a("table")
	end)

	it("should not contain a metatable", function(n)
		expect(getmetatable(Lexer)).to.equal(nil)
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Lexer._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Lexer, {})
		end).to.throw()
	end)
end
