local Players = game:GetService("Players")

local function getPlayersInRadiusList(position: Vector3, radius: number, overlapParams: OverlapParams?): { Player }
	local cache: { [Player]: true } = {}

	for _, basePart in workspace:GetPartBoundsInRadius(position, radius, overlapParams) do
		local player: Player? = Players:GetPlayerFromCharacter(basePart.Parent)
		if player and not cache[player] then
			cache[player] = true
		end
	end

	local list = {}

	for player in cache do
		table.insert(list, player)
	end

	return list
end

return getPlayersInRadiusList
