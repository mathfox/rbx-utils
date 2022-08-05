--!strict

export type TokenType = {
	name: string,
	match: (code: string) -> string?,
}

local TokenType = {}

function TokenType.new(name: string, match: (code: string) -> string?): TokenType
	local tokenType = {
		name = name,
		match = match,
	}

	table.freeze(tokenType)

	return tokenType
end

local tokenTypesList = {
	TokenType.new("NEW_LINE", function(code)
		return code:match("^[\r\n]")
	end),

	TokenType.new("SPACE", function(code)
		return code:match("^ ")
	end),

	TokenType.new("TAB", function(code)
		return code:match("^\t")
	end),

	TokenType.new("CODE", function(code)
		local commentStartIndex = code:find("%-%-")
		if commentStartIndex then
			return code:sub(1, commentStartIndex - 1):match("^[ \t%w%p]+")
		else
			return code:match("^[ \t%w%p]+")
		end
	end),

	TokenType.new("MULTIPLE_LINE_COMMENT", function(code)
		return code:match("^%-%-%[%[.*%]%]")
	end),

	TokenType.new("SINGLE_LINE_COMMENT", function(code)
		local endLineIndex = code:find("[\r\n]")
		if endLineIndex then
			return code:sub(1, endLineIndex - 1):match("^%-%-.*")
		else
			return code:match("^%-%-.*")
		end
	end),
}

table.freeze(tokenTypesList)

TokenType.tokenTypesList = tokenTypesList

table.freeze(TokenType)

return TokenType
