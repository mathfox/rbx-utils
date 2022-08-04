--!strict

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
	TokenType.new("SPACE", function(code)
		return code:match("^%s")
	end),

	TokenType.new("CODE", function(code)
		if not code:match("^%-%-") then
			return code:match("^[ \t%w%p]+")
		end
	end),

	TokenType.new("MULTIPLE_LINE_COMMENT", function(code)
		return code:match("^%-%-%[%[.*%]%]")
	end),

	TokenType.new("SINGLE_LINE_COMMENT", function(code)
		local endLineIndex = code:find("[\r\n]")
		if endLineIndex then
			local trimmed = code:sub(1, endLineIndex - 1)

			return trimmed:match("^%-%-.*")
		else
			return code:match("^%-%-.*")
		end
	end),
	-- TokenType.new("PREFIX", "^[[-]+[-]+]-(.+)(@block)"),
	-- TokenType.new("ACTION", ":[%a]+:"),
	-- TokenType.new("OPTION", ""),
}

table.freeze(tokenTypesList)

TokenType.tokenTypesList = tokenTypesList

table.freeze(TokenType)

return TokenType
