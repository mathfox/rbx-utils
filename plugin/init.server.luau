--!strict

local ServerStorage = game:GetService("ServerStorage")

local Constants = require(script.Constants)
local Lexer = require(script.Lexer)
local TokenType = require(script.Lexer.TokenType)

local function onContainerAdd(container: LuaSourceContainer)
	local destroyingConnnection: RBXScriptConnection = nil
	local sourceChangedConnection: RBXScriptConnection = nil

	destroyingConnnection = container.Destroying:Connect(function()
		destroyingConnnection:Disconnect()
		sourceChangedConnection:Disconnect()
	end)

	local function onSourceChange()
		local newLexer = Lexer.new(container.Source)
		local tokens = newLexer:lexAnalysis()

		local isSynced = false

		for _, token in tokens do
			if token.type.name == "SINGLE_LINE_COMMENT" or token.type.name == "MULTIPLE_LINE_COMMENT" then
				if token.text:match(Constants.postfixes.synced) then
					isSynced = true

					break
				end
			end
		end

		if not isSynced then
			local resultTokens = {}

			local function runAppend(startIndex: number)
				for tokenIndex = startIndex, #tokens do
					local token = tokens[tokenIndex]

					if token.type.name == "SINGLE_LINE_COMMENT" then
						local blockStartMatch = token.text:match("^%-%-%s?@block[-%a]*:[%a]+:?[%a%d]+")

						local blockSplit = blockStartMatch:split(":")
						local blockName = blockSplit[2]

						local shouldRemoveBlock = false

						-- basically an array indicating the path
						local location = blockStartMatch:match("[%a]+-[-%a]+")
						if location then
							location = location:split("-")

							local currentPath = ServerStorage.IgnoreCodeBlocks

							for pathDepth = 2, #location do
								currentPath = currentPath:FindFirstChild(location[pathDepth])
								if not currentPath then
									break
								end
							end

							shouldRemoveBlock = if currentPath then currentPath:GetAttribute(blockName) else false
						else
							shouldRemoveBlock = ServerStorage.IgnoreCodeBlocks:GetAttribute(blockName)
						end

						if shouldRemoveBlock then
							local blockAction = blockSplit[3]

							if blockAction == "start" then
								local blockEndStr = ("--@block:%s:end"):format(blockName)

								for endIndex = tokenIndex + 1, #tokens do
									local endToken = tokens[endIndex]
									if endToken.text == blockEndStr then
										runAppend(endIndex + 1)

										break
									else
										table.insert(resultTokens, { text = "\n" })
									end
								end

								break
							else
								local linesAmount = tonumber(blockAction)

								if linesAmount and linesAmount ~= 0 then
									local nextIndex = startIndex + 1 + linesAmount
									if nextIndex < #tokens then
										for _ = 1, linesAmount do
											table.insert(resultTokens, { text = "\n" })
										end

										runAppend(nextIndex)
									end

									break
								end
							end
						end
					-- elseif token.type.name == "MULTIPLE_LINE_COMMENT" then
					else
						table.insert(resultTokens, token)
					end
				end
			end

			runAppend(1)

			local resultString = ""

			for _, token in resultTokens do
				resultString ..= token.text
			end

			resultString ..= "\n" .. Constants.postfixes.synced

			container.Source = resultString
		end
	end

	onSourceChange()

	sourceChangedConnection = container:GetPropertyChangedSignal("Source"):Connect(onSourceChange)
end

for _, location in Constants.containerLocations do
	location.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("LuaSourceContainer") then
			onContainerAdd(descendant)
		end
	end)

	for _, container in location:GetDescendants() do
		if container:IsA("LuaSourceContainer") then
			onContainerAdd(container)
		end
	end
end

local shouldCreateAPI = true

for _, child in ServerStorage:GetChildren() do
	if child.Name == Constants.folderName and child:IsA("ModuleScript") then
		shouldCreateAPI = false

		break
	end
end

if shouldCreateAPI then
	script.IgnoreCodeBlocks.Parent = ServerStorage
end

plugin.Unloading:Connect(function()
	return
end)
