local function clearDescendantsByPredicate(parent: Instance, predicate: (Instance, number) -> boolean)
	for index, descendant in parent:GetDescendants() do
		if predicate(descendant, index) then
			descendant:Destroy()
		end
	end
end

return clearDescendantsByPredicate
