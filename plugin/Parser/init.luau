--!strict

local ExpressionNode = require(script.Parent.Ast.ExpressionNode)
local StatementsNode = require(script.Parent.Ast.StatementsNode)
local TokenType = require(script.Parent.Lexer.TokenType)
local Token = require(script.Parent.Lexer.Token)

type ExpressionNode = ExpressionNode.ExpressionNode
type TokenType = TokenType.TokenType
type Token = Token.Token

type ParserImpl = {
	__index: ParserImpl,

	match: (self: Parser, expected: TokenType) -> Token?,
	require: (self: Parser, expected: TokenType) -> Token,
	parseCode: (self: Parser) -> ExpressionNode,
	parseExpression: (self: Parser) -> ExpressionNode,
	parseComment: (self: Parser) -> ExpressionNode,
}

export type Parser = typeof(setmetatable({} :: {
	tokens: { Token },
	pos: number,
	scope: {},
}, {} :: ParserImpl))

local ParserImpl = {} :: ParserImpl
ParserImpl.__index = ParserImpl

function ParserImpl:match(expected)
	if self.pos < #self.tokens then
		local currentToken = self.tokens[self.pos]
		if currentToken.type.name == expected.name then
			self.pos += 1

			return currentToken
		end
	end

	return nil
end

function ParserImpl:require(expected)
	local token = self:match(expected)
	if not token then
		error("On position " .. self.pos .. " expected on of: " .. ("{%s}"):format(table.concat(expected, " ,")), 2)
	else
		return token
	end
end

function ParserImpl:parseComment()
	return
end

function ParserImpl:parseExpression()
	if self:match(TokenType.tokenTypesList[3]) then
		return self:parseComment()
	end

	return nil
end

function ParserImpl:parseCode()
	local root = StatementsNode.new()

	while self.pos < #self.tokens do
		local commentNode = self:parseExpression()
		if commentNode then
			root:addNode(commentNode)
		end
	end

	return root
end

table.freeze(ParserImpl)

local Parser = {}

function Parser.new(tokens: { Token }, pos: number, scope: {}): Parser
	return setmetatable({
		tokens = tokens,
		pos = pos,
		scope = scope,
	}, ParserImpl)
end

table.freeze(Parser)

return Parser
