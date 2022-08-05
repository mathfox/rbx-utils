local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local StarterPlayer = game:GetService("StarterPlayer")
local ServerStorage = game:GetService("ServerStorage")

local Constants = {
	folderName = "IgnoreCodeBlocks",
	containerLocations = { ReplicatedFirst, ReplicatedStorage, workspace, StarterPlayer, ServerStorage, ServerScriptService },
	postfix = "--@synced",
}

table.freeze(Constants)
table.freeze(Constants.containerLocations)

return Constants
