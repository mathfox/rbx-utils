--!strict

local TokenType = require(script.TokenType)
local Token = require(script.Token)

type Token = Token.Token

type LexerImpl = {
	__index: LexerImpl,

	runAnalysis: (self: Lexer) -> { Token },
}

export type Lexer = typeof(setmetatable({} :: {
	container: LuaSourceContainer,
}, {} :: LexerImpl))

local LexerImpl = {} :: LexerImpl
LexerImpl.__index = LexerImpl

function LexerImpl:runAnalysis()
	local code = self.container.Source
	local pos = 1
	local tokenList = {}

	while pos <= #code do
		local hasMatchedTokenType = false

		for _, tokenType in TokenType.tokenTypesList do
			local result = tokenType.match(code:sub(pos))
			if result then
				table.insert(tokenList, Token.new(tokenType, result, pos))

				pos += #result

				hasMatchedTokenType = true

				break
			end
		end

		if not hasMatchedTokenType then
			error(("Could not match any TokenType at the %d position"):format(pos), 2)
		end
	end

	return tokenList
end

local Lexer = {}

function Lexer.new(container: LuaSourceContainer): Lexer
	local lexer = setmetatable({
		container = container,
	}, LexerImpl)

	table.freeze(lexer)

	return lexer
end

table.freeze(Lexer)

return Lexer
