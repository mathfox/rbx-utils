-- refactored version of: https://github.com/howmanysmall/enumerator

local Types = require(script.Parent.Types)

export type EnumeratorItem<T = string> = Types.EnumeratorItem<T>
export type Enumerator<T = string> = Types.Enumerator<T>

local function EnumeratorConstructor<T>(enumeratorName: string, enumeratorValues: { string } | { [string]: T }): Enumerator<T>
	local enumerator = {}
	local valuesToEnumeratorItems: { [T]: EnumeratorItem<T> } = {}

	function enumerator.fromRawValue(rawValue): EnumeratorItem<T>?
		return valuesToEnumeratorItems[rawValue]
	end

	function enumerator.isEnumeratorItem(value)
		if typeof(value) ~= "table" then
			return false
		end

		for _, enumeratorItem in valuesToEnumeratorItems do
			if enumeratorItem == value then
				return true
			end
		end

		return false
	end

	function enumerator.getEnumeratorItems(): { EnumeratorItem<T> }
		local enumeratorItems = {}

		for _, enumeratorItem in valuesToEnumeratorItems do
			table.insert(enumeratorItems, enumeratorItem)
		end

		return enumeratorItems
	end

	if #enumeratorValues == 0 then
		local keysToEnumeratorItems: { [string]: EnumeratorItem<T> } = {}

		for key, value in enumeratorValues :: { [string]: T } do
			local enumeratorItem: EnumeratorItem<T> = { name = key, value = value, type = enumerator }
			local enumeratorItemMetatable = {
				__tostring = function()
					return ("%s.%s"):format(enumeratorName, key)
				end,
			}

			setmetatable(enumeratorItem, enumeratorItemMetatable)

			--@block:dev:start
			table.freeze(enumeratorItemMetatable)
			table.freeze(enumeratorItem)
			--@block:dev:end

			keysToEnumeratorItems[key] = enumeratorItem
			valuesToEnumeratorItems[value] = enumeratorItem
		end

		local enumeratorMetatable = {
			__index = keysToEnumeratorItems,
			__tostring = function()
				return enumeratorName
			end,
		}

		setmetatable(enumerator, enumeratorMetatable)

		--@block:dev:start
		table.freeze(enumeratorMetatable)
		table.freeze(enumerator)
		--@block:dev:end

		return enumerator
	else
		for index, value in enumeratorValues :: { string } do
			local enumeratorItem: EnumeratorItem = { name = value, value = value, type = enumerator }
			local enumeratorItemMetatable = {
				__tostring = function()
					return ("%s.%s"):format(enumeratorName, value)
				end,
			}

			setmetatable(enumeratorItem, enumeratorItemMetatable)

			--@block:dev:start
			table.freeze(enumeratorItemMetatable)
			table.freeze(enumeratorItem)
			--@block:dev:end

			valuesToEnumeratorItems[value] = enumeratorItem
		end

		local enumeratorMetatable = {
			__index = valuesToEnumeratorItems,
			__tostring = function()
				return enumeratorName
			end,
		}

		setmetatable(enumerator, enumeratorMetatable)

		--@block:dev:start
		table.freeze(enumeratorMetatable)
		table.freeze(enumerator)
		--@block:dev:end

		return enumerator
	end
end

return EnumeratorConstructor
