--!strict

local RunService = game:GetService("RunService")

if not plugin or RunService:IsRunning() then
	return
end

local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")

local Constants = require(script.Constants)
local Lexer = require(script.Lexer)
local TokenType = require(script.Lexer.TokenType)
local Token = require(script.Lexer.Token)

type Token = Token.Token

local function onContainerAdd(container: LuaSourceContainer)
	local destroyingConnnection: RBXScriptConnection = nil
	local sourceChangedConnection: RBXScriptConnection = nil

	destroyingConnnection = container.Destroying:Connect(function()
		destroyingConnnection:Disconnect()
		sourceChangedConnection:Disconnect()
	end)

	local newLexer = Lexer.new(container)

	local function onSourceChange()
		local tokens = newLexer:runAnalysis()

		local isSynced = false

		for _, token in tokens do
			if token.type.name == "SINGLE_LINE_COMMENT" then
				if token.text == Constants.postfix then
					isSynced = true

					break
				end
			end
		end

		if not isSynced then
			local resultTokens: { Token } = {}

			local function parseBody(text: string)
				local _, endIndex = text:find("^%-%-%s?@block")
				if endIndex then
					return text:sub(endIndex + 1)
				end
			end

			-- Raw means that this function does not take the options into an account
			local function parseSection(body: string)
				local _, sectionEndIndex = body:find("^:%a+")
				if sectionEndIndex then
					return body:sub(2, sectionEndIndex), body:sub(sectionEndIndex + 1)
				end
			end

			local function parseArguments(rest: string)
				local _, argumentsEndIndex = rest:find("^[%l%-%d:]+")
				if argumentsEndIndex then
					return rest:sub(1, argumentsEndIndex), rest:sub(argumentsEndIndex + 1)
				end
			end

			local function parseFlags(rest: text): { string }?
				local split = rest:split(" ")
				if #split > 1 then
					table.remove(split, 1)

					local flags = {}

					for _, flag in split do
						table.insert(flags, flag)
					end

					return flags
				end
			end

			local function parseSectionPath(flags: { string })
				local path = {}

				for _, flag in flags do
					local _, prefixEndIndex = flag:find("^%-%-")
					if prefixEndIndex then
						local content = flag:sub(prefixEndIndex + 1)
						if content:match("^local") then
							local parent = container

							while true do
								table.insert(path, 1, parent)

								parent = parent.Parent

								if parent == game then
									break
								end
							end
						elseif content:match("^path=") then
							local origin = loadstring(("return game.%s%s"):format(container:GetFullName(), content:sub(6)))()

							while true do
								table.insert(path, 1, origin)

								origin = origin.Parent

								if origin == game then
									break
								end
							end
						end
					end
				end

				return path
			end

			local function shouldHandle()
				return true
			end

			local function _appendHelper(...)
				return select("#", ...), { ... }
			end

			local function parseOrAppendToken(fn: () -> (), token: Token)
				local length, values = _appendHelper(fn())
				if length == 0 then
					table.insert(resultTokens, token)
				else
					return unpack(values, 1, length)
				end
			end

			for tokenIndex, token in tokens do
				if not shouldHandle(token) then
					continue
				end

				if token.type.name == "SINGLE_LINE_COMMENT" then
					local body = parseOrAppendToken(function()
						return parseBody(token.text)
					end, token)
					if not body then
						continue
					end

					local section, rest = parseOrAppendToken(function()
						return parseSection(body)
					end, token)
					if not section then
						continue
					end

					local arguments = parseOrAppendToken(function()
						local inner, innerRest = parseArguments(rest)

						if inner then
							rest = innerRest
						end

						return inner
					end, token)

					local path = nil

					local flags = parseFlags(rest)
					if flags then
						path = parseSectionPath(flags)
					end

					local shouldRemoveBlock = false
					do
						local currentPath = ServerStorage.IgnoreCodeBlocks
						if path then
							for _, nextPath in path do
								currentPath = currentPath:FindFirstChild(nextPath.Name)
								if not currentPath then
									break
								end
							end

							if currentPath then
								shouldRemoveBlock = currentPath:GetAttribute(section)
							end
						else
							shouldRemoveBlock = ServerStorage.IgnoreCodeBlocks:GetAttribute(section)
						end
					end

					if shouldRemoveBlock then
						function shouldHandle(token: Token)
							if token.type.name == "NEW_LINE" then
								function shouldHandle()
									return true
								end
							else
								table.insert(resultTokens, token)
							end

							return false
						end

						if arguments then
							for lastIndex = #resultTokens, 1, -1 do
								local lastToken = resultTokens[lastIndex]
								if lastToken.type.name == "NEW_LINE" then
									if flags then
										if table.find(flags, "--no-lines-preserve") then
											table.remove(resultTokens, lastIndex)
										end
									end

									break
								else
									table.remove(resultTokens, lastIndex)
								end
							end
						else
							for lastIndex = #resultTokens, 1, -1 do
								local lastToken = resultTokens[lastIndex]
								if lastToken.type.name == "SPACE" or lastToken.type.name == "TAB" then
									table.remove(resultTokens, lastIndex)

									continue
								elseif lastToken.type.name == "NEW_LINE" then
									if flags then
										if table.find(flags, "--no-lines-preserve") then
											table.remove(resultTokens, lastIndex)
										end
									end
								end

								break
							end
						end

						if not arguments then
							continue
						end

						local split = arguments:split(":")
						if #split <= 1 then
							continue
						end

						-- removing the empty character
						table.remove(split, 1)

						local firstArgument = split[1]
						if firstArgument == "start" then
							function shouldHandle(token: Token)
								if token.type.name == "SINGLE_LINE_COMMENT" then
									local body = parseBody(token.text)
									if body then
										local endSection = parseSection(body)
										if section == endSection then
											function shouldHandle()
												return true
											end
										end
									end
								elseif token.type.name == "NEW_LINE" then
									return if flags then not table.find(flags, "--no-lines-preserve") else true
								end

								return false
							end
						else
							local lines = tonumber(firstArgument)
							if lines > 0 then
								local currentNewLines = 0

								function shouldHandle(token: Token)
									if token.type.name == "NEW_LINE" then
										currentNewLines += 1

										if currentNewLines == (lines * 2) + 1 then
											function shouldHandle()
												return true
											end
										end

										return if flags then not table.find(flags, "--no-lines-preserve") else true
									end

									return false
								end
							end
						end
					else
						table.insert(resultTokens, token)
					end
					-- TODO: multiple line comments
					-- elseif token.type.name == "MULTIPLE_LINE_COMMENT" then
				else
					table.insert(resultTokens, token)
				end
			end

			local resultString = ""

			for _, token in resultTokens do
				resultString ..= token.text
			end

			resultString ..= "\r" .. Constants.postfix

			container.Source = resultString
		end
	end

	onSourceChange()

	sourceChangedConnection = container:GetPropertyChangedSignal("Source"):Connect(function()
		local deferredSource = container.Source

		task.defer(function()
			if deferredSource == container.Source then
				onSourceChange()
			end
		end)
	end)
end

for _, container in CollectionService:GetTagged("RICBContainer") do
	onContainerAdd(container)
end

local shouldCreateAPI = true

for _, child in ServerStorage:GetChildren() do
	if child.Name == Constants.folderName and child:IsA("ModuleScript") then
		shouldCreateAPI = false

		break
	end
end

if shouldCreateAPI then
	script.IgnoreCodeBlocks:Clone().Parent = ServerStorage
end
