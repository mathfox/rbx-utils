local function getChildrenWhichIsA(parent: Instance, className: string): { Instance }
	local children = parent:GetChildren()
	local arr = table.create(#children)

	for _, child in children do
		if child:IsA(className) then
			table.insert(arr, child)
		end
	end

	return arr
end

return getChildrenWhichIsA
