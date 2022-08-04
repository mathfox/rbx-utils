export type TokenType = {
	name: string,
	match: (code: string) -> string?,
}

local TokenType = {}

function TokenType.new(name: string, match: (code: string) -> string?): TokenType
	return {
		name = name,
		match = match,
	}
end

local tokenTypesList = {
	-- TokenType.new("BLOCK_PATH", function(code)
	-- 	return
	-- end),

	-- TokenType.new("BLOCK_NAME", function(code)
	-- 	return
	-- end),

	-- TokenType.new("BLOCK_START", function(code)
	-- 	-- TODO: support the options args
	-- end),

	-- TokenType.new("BLOCK_END", function(code)
	-- 	return
	-- end),

	-- TokenType.new("BLOCK_LENGTH", function(code)
	-- 	return
	-- end),

	-- TokenType.new("BLOCK_OPTION"),

	TokenType.new("LETTER", function(code)
		return code:match(".")
	end),
}

table.freeze(tokenTypesList)

TokenType.tokenTypesList = tokenTypesList

table.freeze(TokenType)

return TokenType
