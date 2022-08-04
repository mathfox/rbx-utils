return function()
	local TokenType = require(script.Parent)

	it("should be a table", function()
		expect(TokenType).to.be.a("table")
	end)

	it("should not contain a metatable", function()
		expect(getmetatable(TokenType)).to.equal(nil)
	end)

	it("should expose constructor function", function()
		expect(TokenType.new).to.be.a("function")
	end)

	it("should throw an error on attempt to modify the export table", function()
		expect(function()
			TokenType._ = {}
		end).to.throw()

		expect(function()
			setmetatable(TokenType, {})
		end).to.throw()
	end)

	describe("TokenType", function()
		it("should throw an error on attempt to modify the constructed table", function()
			local tokenType = TokenType.new("Test", function() end)

			expect(function()
				tokenType._ = {}
			end).to.throw()

			expect(function()
				setmetatable(tokenType, {})
			end).to.throw()
		end)
	end)

	describe("tokenTypesList", function()
		it("should be a table", function()
			expect(TokenType.tokenTypesList).to.be.a("table")
		end)

		it("should not contain a metatable", function()
			expect(getmetatable(TokenType.tokenTypesList)).to.equal(nil)
		end)
	end)
end
