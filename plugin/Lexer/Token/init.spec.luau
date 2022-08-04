return function()
	local TokenType = require(script.Parent.Parent.TokenType)

	local Token = require(script.Parent)

	it("should be a table", function()
		expect(Token).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(Token)).to.equal(nil)
	end)

	it("should expose constructor function", function()
		expect(Token.new).to.be.a("function")
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			Token._ = {}
		end).to.throw()

		expect(function()
			setmetatable(Token, {})
		end).to.throw()
	end)

	describe("Token", function()
		it("should throw an error on attempt to modify the constructred token", function()
			local token = Token.new(TokenType.new("Test", function() end), "", 1)

			expect(function()
				token._ = {}
			end).to.throw()

			expect(function()
				setmetatable(token, {})
			end).to.throw()
		end)
	end)
end
