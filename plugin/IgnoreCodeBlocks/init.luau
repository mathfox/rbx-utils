export type IgnoreCodeBlocksConfig = { [string]: boolean | IgnoreCodeBlocksConfig }

local IgnoreCodeBlocks = {}

--@block:dev:1
-- This function duplicates the provided Container
function IgnoreCodeBlocks.scoped(container: LuaSourceContainer, config: IgnoreCodeBlocksConfig, fn: (LuaSourceContainer) -> ())
	fn(container)

	return
end

--@block:dev:2 --no-preserve-lines
table.freeze(IgnoreCodeBlocks)

--@block:dev:1 --no-preserve-lines

-- ? should we support
--@block:dev:-1:2

--@block:dev:start --no-preserve-lines
--@block:dev:end

--[[
   @block:dev:2
]]

--[[
   @block:dev:-1:2
]]

return IgnoreCodeBlocks
