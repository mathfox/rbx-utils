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
	local token = {
		type = type,
		text = text,
		pos = pos,
	}

	table.freeze(token)

	return token
end

table.freeze(Token)

return Token
