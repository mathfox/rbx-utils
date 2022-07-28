local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")

local CONTAINERS = { ServerScriptService, workspace, Players, StarterPlayer.StarterPlayerScripts, ReplicatedFirst }
local INSTANCE_TO_SOURCE_MAP: { [Instance]: string } = {}

local FOLDER_NAME = "IgnoreScriptBlocks"

local innerObjectValue = Instance.new("ObjectValue")

local queue: { BoolValue } = {}

local function observeChild(child: Instance)
	if child:IsA("Folder") then
		local destroyingConnnection: RBXScriptConnection = nil
		local nameChangedConnection: RBXScriptConnection = nil

		do
			local function onNameChange()
				if child.Name == FOLDER_NAME then
					if not innerObjectValue.Value then
						innerObjectValue.Value = child
					else
						table.insert(queue, child)
					end
				elseif innerObjectValue.Value == child then
					innerObjectValue.Value = table.remove(queue, 1)
				end
			end

			onNameChange()

			nameChangedConnection = child:GetPropertyChangedSignal("Name"):Connect(onNameChange)
		end

		destroyingConnnection = child.Destroying:Connect(function()
			destroyingConnnection:Disconnect()
			nameChangedConnection:Disconnect()

			if innerObjectValue.Value == child then
				innerObjectValue.Value = table.remove(queue, 1)
			end
		end)
	end
end

ServerStorage.ChildAdded:Connect(observeChild)

for _, child in ServerStorage:GetChildren() do
	observeChild(child)
end

local NEW_LINE_PATTERN = "[^\r\n]+"

local function updateSource(source: string, blocks: { [string]: boolean })
	local split = {}

	for _, line in source:split("\n") do
		table.insert(split, if line == "\r" then "" else table.insert(split, line:match(NEW_LINE_PATTERN) or ""))
	end

	local newSource = "-- This file is currently @observed by RbxUtils\n"

	local function runSourceAppend(index: number)
		for startIndex = index, #split do
			local startStr = split[startIndex]:gsub("\t", ""):gsub(" ", "")
			local blockStartMatch = startStr:match("--@block:[%a]+:start")
			if blockStartMatch then
				local blockName = blockStartMatch:split(":")[2]
				local blockEndStr = ("--@block:%s:end"):format(blockName)

				if blocks[blockName] then
					for endIndex = startIndex + 1, #split do
						local endStr = split[endIndex]:gsub("\t", ""):gsub(" ", "")
						if endStr == blockEndStr then
							runSourceAppend(endIndex + 1)

							break
						end
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

local function onValueChange(folder: Folder?)
	if folder then
		local attributes = folder:GetAttributes()

		for _, container in CONTAINERS do
			for _, child in ReplicatedStorage:GetDescendants() do
				if child:IsA("LuaSourceContainer") then
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
						child.Source = updateSource(source, attributes)

						sourceChangedConnection = child:GetPropertyChangedSignal("Source"):Connect(function()
							if not child.Source:find("@observed") then
								local newSource = child.Source
								if not newSource:find("@synced") then
									newSource = SYNCED .. newSource

									INSTANCE_TO_SOURCE_MAP[child] = newSource
									child.Source = updateSource(newSource, attributes)
								end
							end
						end)
					else
						if not source:find("@observed") then
							child.Source = updateSource(source, attributes)
						end
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

onValueChange(innerObjectValue.Value)

innerObjectValue.Changed:Connect(onValueChange)
