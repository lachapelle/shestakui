local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
-- Learn all available skills (TrainAll by SDPhantom)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_TrainerUI" then
		local button = CreateFrame("Button", "ClassTrainerTrainAllButton", ClassTrainerFrame, "UIPanelButtonTemplate")
		-- button:SetText(ACHIEVEMENTFRAME_FILTER_ALL)
		button:SetText(TRAIN.." "..ALL)
		if C.skins.blizzard_frames == true then
			button:SkinButton()
			-- button:SetPoint("TOPRIGHT", ClassTrainerTrainButton, "TOPLEFT", -3, 0)
			button:SetPoint("BOTTOM", ClassTrainerTrainButton, "BOTTOM", 0, -40)
		else
			-- button:SetPoint("TOPRIGHT", ClassTrainerTrainButton, "TOPLEFT", 0, 0)
			button:SetPoint("BOTTOM", ClassTrainerTrainButton, "BOTTOM", 0, -40)
		end
		button:SetWidth(min(150, button:GetTextWidth() + 15))
		button:SetHeight(20)
		button:SetScript("OnClick", function()
			for i = 1, GetNumTrainerServices() do
				if select(3, GetTrainerServiceInfo(i)) == "available" then
					BuyTrainerService(i)
				end
			end
		end)
		hooksecurefunc("ClassTrainerFrame_Update", function()
			for i = 1, GetNumTrainerServices() do
				if ClassTrainerTrainButton:IsEnabled() and select(3, GetTrainerServiceInfo(i)) == "available" then
					button:Enable()
					return
				end
			end
			button:Disable()
		end)
	end
end)