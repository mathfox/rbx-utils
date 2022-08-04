--!strict

local ExpressionNode = require(script.Parent.ExpressionNode)

type ExpressionNode = ExpressionNode.ExpressionNode

type StatementsNodeImpl = {
	__index: StatementsNodeImpl,
	addNode: (self: StatementsNode, node: ExpressionNode) -> (),
}

export type StatementsNode = typeof(setmetatable({} :: {
	codeStrings: { ExpressionNode },
}, {} :: StatementsNodeImpl))

local StatementsNodeImpl = {} :: StatementsNodeImpl
StatementsNodeImpl.__index = StatementsNodeImpl

function StatementsNodeImpl:addNode(node)
	table.insert(self.codeStrings, node)
end

local StatementsNode = {}

function StatementsNode.new(): StatementsNode
	return setmetatable({
		codeStrings = {},
	}, StatementsNodeImpl)
end

table.freeze(StatementsNode)

return StatementsNode
