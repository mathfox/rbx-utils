local TokenType = require(script.TokenType)

type CommentLexerImpl = {
	__index: CommentLexerImpl,
	lexAnalysis: (self: CommentLexer) -> { CommentToken },
}

export type CommentLexer = typeof(setmetatable({}, {} :: CommentLexerImpl))

local CommentLexerImpl = {} :: CommentLexerImpl
CommentLexerImpl.__index = CommentLexerImpl

function CommentLexerImpl:lexAnalysis()
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
			error(("Could not match the TokenType at %d position"):format(self.pos), 2)
		end
	end

	return tokenList
end

table.freeze(CommentLexerImpl)

local CommentLexer = {}

function CommentLexer.new(code: string): CommentLexer
	return setmetatable({
		code = code,
		pos = 1,
	}, CommentLexerImpl)
end

table.freeze(CommentLexer)

return CommentLexer
