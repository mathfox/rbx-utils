local StarterGui = game:GetService("StarterGui")

local function setCoreGuisEnabled(enabled: boolean, list: { Enum.CoreGuiType })
	for _, coreGuiType in list do
		StarterGui:SetCoreGuiEnabled(coreGuiType, enabled)
	end
end

return setCoreGuisEnabled
