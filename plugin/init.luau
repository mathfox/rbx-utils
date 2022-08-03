local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ServerStorage = game:GetService("ServerStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local Players = game:GetService("Players")

local CONTAINERS = { ReplicatedStorage, ServerScriptService, workspace, Players, StarterPlayer.StarterPlayerScripts, ReplicatedFirst }
local INSTANCE_TO_SOURCE_MAP: { [Instance]: string } = {}

local FOLDER_NAME = "IgnoreCodeBlocks"

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
local SYNCED = "\n-- This file is the one @synced by Rojo"
local OBSERVED_POSTFIX = "-- This file is currently @observed by RbxUtils"

local function updateSource(source: string, folder: Folder)
	local split = {}

	for _, line in source:split("\n") do
		table.insert(split, if line == "\r" then "" else table.insert(split, line:match(NEW_LINE_PATTERN) or ""))
	end

	local newSource = ""

	local function runSourceAppend(index: number)
		for startIndex = index, #split do
			local startStr = split[startIndex]:gsub("\t", ""):gsub(" ", "")
			local blockStartMatch = startStr:match("--@block[-%a]*:[%a]+:[%a%d]+")
			if blockStartMatch then
				local blockSplit = blockStartMatch:split(":")
				local blockName = blockSplit[2]

				local shouldRemoveBlock = false

				-- basically an array indicating the path
				local location = blockStartMatch:match("[%a]+-[-%a]+")
				if location then
					location = location:split("-")

					local currentPath = folder

					for pathDepth = 2, #location do
						currentPath = currentPath:FindFirstChild(location[pathDepth])
						if not currentPath then
							break
						end
					end

					shouldRemoveBlock = if currentPath then currentPath:GetAttribute(blockName) else false
				else
					shouldRemoveBlock = folder:GetAttribute(blockName)
				end

				newSource ..= "\n"

				if shouldRemoveBlock then
					local blockAction = blockSplit[3]

					if blockAction == "start" then
						local blockEndStr = ("--@block:%s:end"):format(blockName)

						for endIndex = startIndex + 1, #split do
							local endStr = split[endIndex]:gsub("\t", ""):gsub(" ", "")
							if endStr == blockEndStr then
								runSourceAppend(endIndex + 1)

								break
							else
								newSource ..= "\n"
							end
						end

						break
					else
						local linesAmount = tonumber(blockAction)

						if linesAmount and linesAmount ~= 0 then
							local nextIndex = startIndex + 1 + linesAmount
							if nextIndex < #split then
								newSource ..= string.rep("\n", linesAmount)

								runSourceAppend(nextIndex)
							end

							break
						end
					end
				end
			else
				newSource ..= split[startIndex] .. "\n"
			end
		end
	end

	runSourceAppend(1)

	newSource ..= OBSERVED_POSTFIX

	return newSource
end

local function onValueChange(folder: Folder?)
	if folder then
		local function attachHandlerRecursive(parent: Folder)
			parent.AttributeChanged:Connect(function(attribute)
				for _, container in CONTAINERS do
					for _, child in container:GetDescendants() do
						if child:IsA("LuaSourceContainer") and INSTANCE_TO_SOURCE_MAP[child] then
							child.Source = updateSource(INSTANCE_TO_SOURCE_MAP[child], folder)
						end
					end
				end
			end)

			for _, child in parent:GetChildren() do
				attachHandlerRecursive(child)
			end
		end

		attachHandlerRecursive(folder)

		for _, container in CONTAINERS do
			for _, child in container:GetDescendants() do
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

						source = child.Source .. SYNCED
						INSTANCE_TO_SOURCE_MAP[child] = source
						child.Source = updateSource(source, folder)

						sourceChangedConnection = child:GetPropertyChangedSignal("Source"):Connect(function()
							if not child.Source:find("@observed") then
								local newSource = child.Source
								if not newSource:find("@synced") then
									INSTANCE_TO_SOURCE_MAP[child] = newSource .. SYNCED
									child.Source = updateSource(newSource .. SYNCED, folder)
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
