local function loadChildrenFilter(parent: Instance, predicate: (ModuleScript) -> boolean)
	local arr = {}

	for _, child in parent:GetChildren() do
		if child:IsA("ModuleScript") and predicate(child) then
			table.insert(arr, require(child))
		end
	end

	return arr
end

return loadChildrenFilter
