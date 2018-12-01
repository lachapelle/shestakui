local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	QuestGreeting skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local function UpdateGreetingPanel()
		QuestFrameGreetingPanel:StripTextures()
		QuestGreetingScrollFrame:StripTextures()
		QuestFrameGreetingGoodbyeButton:SkinButton()
		GreetingText:SetTextColor(1, 1, 1)
		CurrentQuestsText:SetTextColor(1, 0.8, 0)
		AvailableQuestsText:SetTextColor(1, 0.8, 0)
		QuestGreetingFrameHorizontalBreak:Kill()

		for i = 1, MAX_NUM_QUESTS do
			local button = _G["QuestTitleButton"..i]

			if button:GetFontString() then
				if button:GetFontString():GetText() and button:GetFontString():GetText():find("|cff000000") then
					button:GetFontString():SetText(string.gsub(button:GetFontString():GetText(), "|cff000000", "|cffFFFF00"))
				end
			end
		end
	end

	QuestFrameGreetingPanel:HookScript("OnShow", UpdateGreetingPanel)
	hooksecurefunc("QuestFrameGreetingPanel_OnShow", UpdateGreetingPanel)
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)