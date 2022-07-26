local StarterGui = game:GetService("StarterGui")

local function setAllCoreGuisEnabledIgnore(enabled: boolean, ingoreList: { Enum.CoreGuiType })
	StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, enabled)

	for _, coreGuiType in ingoreList do
		StarterGui:SetCoreGuiEnabled(coreGuiType, false)
	end
end

return setAllCoreGuisEnabledIgnore
