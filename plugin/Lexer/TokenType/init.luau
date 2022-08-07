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

	TokenType.new("MULTIPLE_LINE_COMMENT", function(code)
		if code:match("^%-%-%[%[") then
			local _, commentEndIndex = code:sub(5):find("%]%]")
			if commentEndIndex then
				return code:sub(1, commentEndIndex)
			end
		end
	end),

	TokenType.new("SINGLE_LINE_COMMENT", function(code)
		local endLineIndex = code:find("[\r\n]")
		if endLineIndex then
			return code:sub(1, endLineIndex - 1):match("^%-%-.*")
		else
			return code:match("^%-%-.*")
		end
	end),

	TokenType.new("CODE", function(code)
		-- first we should check if it's the last line of the code
		local _, lineEndIndex = code:find(".-[\r\n]")
		if lineEndIndex then
			-- the catch here is that our line could contain the comment at this point, so we have to get the actual line without spaces/tabs
			code = code:sub(1, lineEndIndex - 1)
		end

		local commentPrefixStartIndex = code:find("[ \t]*%-%-")
		if commentPrefixStartIndex then
			return code:sub(1, commentPrefixStartIndex - 1)
		end

		return code
	end),
}

table.freeze(tokenTypesList)

TokenType.tokenTypesList = tokenTypesList

table.freeze(TokenType)

return TokenType
