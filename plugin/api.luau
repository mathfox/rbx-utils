type IgnoreCodeBlocksConfig = { [string]: boolean | IgnoreCodeBlocksConfig }

local IgnoreCodeBlocks = {}

function IgnoreCodeBlocks.scoped(container: LuaSourceContainer, config: IgnoreCodeBlocksConfig, fn: (LuaSourceContainer) -> ())
	fn(container)

	return
end

table.freeze(IgnoreCodeBlocks)

return IgnoreCodeBlocks
