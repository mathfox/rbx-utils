local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local INSTANCE_TO_SOURCE_MAP: { [Instance]: string } = {}

local BOOL_VALUE_NAME = "Strict"

local innerObjectValue = Instance.new("ObjectValue")

local boolValueQueue: { BoolValue } = {}

-- The goal of this function is to maintain all of the connections related to the existing BoolValue's.
-- So as soon as the BoolValue's name is meets the requirements, either Value of inner object must be set directly or queued up.
local function observeChild(child: Instance)
	if child:IsA("BoolValue") then
		local destroyingConnnection: RBXScriptConnection = nil
		local nameChangedConnection: RBXScriptConnection = nil

		do
			local function onNameChange()
				if child.Name == BOOL_VALUE_NAME then
					if not innerObjectValue.Value then
						innerObjectValue.Value = child
					else
						-- There is already BoolValue available, but once it destroyed we should take it's role
						table.insert(boolValueQueue, child)
					end
				elseif innerObjectValue.Value == child then
					innerObjectValue.Value = table.remove(boolValueQueue, 1)
				end
			end

			onNameChange()

			nameChangedConnection = child:GetPropertyChangedSignal("Name"):Connect(onNameChange)
		end

		destroyingConnnection = child.Destroying:Connect(function()
			destroyingConnnection:Disconnect()
			nameChangedConnection:Disconnect()

			if innerObjectValue.Value == child then
				innerObjectValue.Value = table.remove(boolValueQueue, 1)
			end
		end)
	end
end

ServerStorage.ChildAdded:Connect(observeChild)

for _, child in ServerStorage:GetChildren() do
	observeChild(child)
end

local NEW_LINE_PATTERN = "[^\r\n]+"

local function updateSource(source: string)
	local split, truncated = {}, {}

	for _, line in source:split("\n") do
		if line == "\r" then
			table.insert(split, "")
			table.insert(truncated, "")
		else
			local rawLine = line:match(NEW_LINE_PATTERN)

			if rawLine then
				table.insert(split, rawLine)
				local truncStr = rawLine:gsub("\t", ""):gsub(" ", "")
				table.insert(truncated, truncStr)
			else
				table.insert(split, "")
				table.insert(truncated, "")
			end
		end
	end

	local newSource = "-- This file is currently @observed by RbxUtils\n"

	local function runSourceAppend(index: number)
		for startIndex = index, #truncated do
			local startStr = truncated[startIndex]
			if startStr == "--@typeChecksStart" then
				for endIndex = startIndex + 1, #truncated do
					local endStr = truncated[endIndex]
					if endStr == "--@typeChecksEnd" then
						runSourceAppend(endIndex + 1)

						break
					end
				end

				break
			else
				newSource ..= split[startIndex] .. "\n"
			end
		end
	end

	runSourceAppend(1)

	return newSource
end

local SYNCED = "-- This file is the one @synced by Rojo\n"

local function onBoolValueChange(boolValue: BoolValue?)
	if boolValue then
		for _, child in ReplicatedStorage:GetDescendants() do
			if child:IsA("ModuleScript") then
				local source = INSTANCE_TO_SOURCE_MAP[child]
				if not source then
					local destroyingConnnection: RBXScriptConnection = nil
					local sourceChangedConnection: RBXScriptConnection = nil

					destroyingConnnection = child.Destroying:Connect(function()
						destroyingConnnection:Disconnect()
						sourceChangedConnection:Disconnect()

						-- make sure there is no Destroyed instances keys
						INSTANCE_TO_SOURCE_MAP[child] = nil
					end)

					source = SYNCED .. child.Source
					INSTANCE_TO_SOURCE_MAP[child] = source
					child.Source = updateSource(source)

					sourceChangedConnection = child:GetPropertyChangedSignal("Source"):Connect(function()
						if not child.Source:find("@observed") then
							local newSource = child.Source
							if not newSource:find("@synced") then
								newSource = SYNCED .. newSource

								INSTANCE_TO_SOURCE_MAP[child] = newSource
								child.Source = updateSource(newSource)
							end
						end
					end)
				else
					if not source:find("@observed") then
						child.Source = updateSource(source)
					end
				end
			end
		end
	else
		for _, child in ReplicatedStorage:GetDescendants() do
			if child:IsA("ModuleScript") then
				local source = INSTANCE_TO_SOURCE_MAP[child]
				if source then
					child.Source = source
				end
			end
		end
	end
end

onBoolValueChange(innerObjectValue.Value)

innerObjectValue.Changed:Connect(onBoolValueChange)
