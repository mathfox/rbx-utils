--@block:dev:2
-- Returns a total magnitude between waypoints.
-- An error will be thrown in case waypoints in an empty array.
local function getPathWaypointsMagnitude(waypoints: { PathWaypoint })
	local previousPosition, magnitude = waypoints[1].Position, 0

	--@block:dev:1
	-- skip initial waypoint as its magnitude will always be 0
	for index = 2, #waypoints do
		local position = waypoints[index].Position

		--@block:dev:1
		-- increment total path waypoints length (magnitude)
		magnitude += (previousPosition - position).Magnitude

		previousPosition = position
	end

	return magnitude
end

return getPathWaypointsMagnitude
