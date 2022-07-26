--[[
	A 'Symbol' is an opaque marker type that can be used to signify unique
	statuses. Symbols have the type 'table', but when printed to the console,
	the name of the symbol is shown.

   reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Symbol
]]

local Types = require(script.Parent.Types)

export type Symbol = Types.Symbol

local function SymbolConstructor(name: string?): Symbol
	local symbol = {}
	local symbolMetatable = {
		__tostring = if name
			then function()
				return "Symbol(" .. name .. ")"
			end
			else function()
				return "Symbol()"
			end,
	}

	setmetatable(symbol, symbolMetatable)

	--@block:dev:3 --no-lines-preserve
	table.freeze(symbolMetatable)
	table.freeze(symbol)

	return symbol
end

return SymbolConstructor
