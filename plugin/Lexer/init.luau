--!strict

local TokenType = require(script.TokenType)
local Token = require(script.Token)

type Token = Token.Token

type LexerImpl = {
	__index: LexerImpl,
	lexAnalysis: (self: Lexer) -> { Token },
}

export type Lexer = typeof(setmetatable({} :: {
	code: string,
	pos: number,
}, {} :: LexerImpl))

local LexerImpl = {} :: LexerImpl
LexerImpl.__index = LexerImpl

function LexerImpl:lexAnalysis()
	local tokenList = {}

	while self.pos < #self.code do
		local hasFoundToken = false

		for _, tokenType in TokenType.tokenTypesList do
			local result = tokenType.match(self.code:sub(self.pos))
			if result then
				table.insert(tokenList, Token.new(tokenType, result, self.pos))

				self.pos += #result

				hasFoundToken = true

				break
			end
		end

		if not hasFoundToken then
			error("On the position " .. self.pos, 2)
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
