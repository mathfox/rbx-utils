local function loadChildren(parent: Instance)
	local arr = {}

	for _, child in parent:GetChildren() do
		if child:IsA("ModuleScript") then
			table.insert(arr, require(child))
		end
	end

	return arr
end

return loadChildren
