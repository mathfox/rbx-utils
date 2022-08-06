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

	describe(":runAnalysis()", function()
		it("should properly parse single-line comments", function()
			local code = [[--single line comment]]
			local tokens = Lexer.new(code):runAnalysis()

			expect(#tokens).to.equal(1)
			expect(tokens[1].text).to.equal(code)
		end)
	end)
end
