--!strict

local Token = require(script.Parent.Parent.Lexer.Token)

type Token = Token.Token

local CommentNode = {}

function CommentNode.new(comment: Token)
	return { comment = comment }
end

table.freeze(CommentNode)

return CommentNode
