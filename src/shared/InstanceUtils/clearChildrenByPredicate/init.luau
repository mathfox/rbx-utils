local function clearChildrenByPredicate(parent: Instance, predicate: (Instance, number) -> boolean)
	for index, child in parent:GetChildren() do
		if predicate(child, index) then
			child:Destroy()
		end
	end
end

return clearChildrenByPredicate
