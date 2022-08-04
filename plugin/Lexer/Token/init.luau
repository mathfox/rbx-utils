--!strict

local TokenType = require(script.Parent.TokenType)

type TokenType = TokenType.TokenType

export type Token = {
	type: TokenType,
	text: string,
	pos: number,
}

local Token = {}

function Token.new(type: TokenType, text: string, pos: number): Token
	return {
		type = type,
		text = text,
		pos = pos,
	}
end

table.freeze(Token)

return Token
