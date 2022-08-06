--!strict

local Token = require(script.Parent.Parent.Lexer.Token)

type Token = Token.Token

export type CommentNode = {
	comment: Token,
}

local CommentNode = {}

function CommentNode.new(comment: Token): CommentNode
	return {
		comment = comment,
	}
end

table.freeze(CommentNode)

return CommentNode
