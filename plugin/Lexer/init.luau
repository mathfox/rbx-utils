--!strict

local TokenType = require(script.TokenType)
local Token = require(script.Token)

type Token = Token.Token

type LexerImpl = {
	__index: LexerImpl,

	runAnalysis: (self: Lexer) -> { Token },
}

export type Lexer = typeof(setmetatable({} :: {
	code: string,
	pos: number,
}, {} :: LexerImpl))

local LexerImpl = {} :: LexerImpl
LexerImpl.__index = LexerImpl

function LexerImpl:runAnalysis()
	local tokenList = {}

	while self.pos <= #self.code do
		local hasMatchedTokenType = false

		for _, tokenType in TokenType.tokenTypesList do
			local result = tokenType.match(self.code:sub(self.pos))
			if result then
				table.insert(tokenList, Token.new(tokenType, result, self.pos))

				self.pos += #result

				hasMatchedTokenType = true

				break
			end
		end

		if not hasMatchedTokenType then
			error(("Could not match any TokenType at the %d position"):format(self.pos), 2)
		end
	end

	return tokenList
end

local Lexer = {}

function Lexer.new(code: string): Lexer
	return setmetatable({
		code = code,
		pos = 1,
	}, LexerImpl)
end

table.freeze(Lexer)

return Lexer
