local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Kill all stuff on default UI that we don't need
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if C.unitframe.enable and (SavedOptions and (SavedOptions.RaidLayout == "HEAL" or SavedOptions.RaidLayout == "DPS")) then
		InterfaceOptionsFrameCategoriesButton10:SetScale(0.00001)
		InterfaceOptionsFrameCategoriesButton10:SetAlpha(0)
		--[[
		if not InCombatLockdown() then
			CompactRaidFrameManager:Kill()
			CompactRaidFrameContainer:Kill()
		end
		--]]
		-- ShowPartyFrame = T.dummy
		-- HidePartyFrame = T.dummy
		-- CompactUnitFrameProfiles_ApplyProfile = T.dummy
		-- CompactRaidFrameManager_UpdateShown = T.dummy
		-- CompactRaidFrameManager_UpdateOptionsFlowContainer = T.dummy
	end

	-- Advanced_UseUIScale:Kill()
	VideoOptionsResolutionPanelUseUIScale:Kill()
	-- Advanced_UIScaleSlider:Kill()
	VideoOptionsResolutionPanelUIScaleSlider:Kill()
	TutorialFrameAlertButton:Kill()
	-- HelpOpenTicketButtonTutorial:Kill()
	-- TalentMicroButtonAlert:Kill()
	-- CollectionsMicroButtonAlert:Kill()
	-- ReagentBankHelpBox:Kill()
	-- BagHelpBox:Kill()
	-- EJMicroButtonAlert:Kill()
	-- PremadeGroupsPvETutorialAlert:Kill()
	-- SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_WORLD_MAP_FRAME, true)
	-- SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_PET_JOURNAL, true)
	-- SetCVarBitfield("closedInfoFrames", LE_FRAME_TUTORIAL_GARRISON_BUILDING, true)

	-- SetCVar("countdownForCooldowns", 0)
	-- InterfaceOptionsActionBarsPanelCountdownCooldowns:Kill()

	if C.chat.enable then
		SetCVar("chatStyle", "im")
	end

	if C.unitframe.enable then
		InterfaceOptionsCombatPanelTargetOfTarget:Kill()
		SetCVar("showPartyBackground", 0)
	end

	if C.actionbar.enable then
		InterfaceOptionsActionBarsPanelBottomLeft:Kill()
		InterfaceOptionsActionBarsPanelBottomRight:Kill()
		InterfaceOptionsActionBarsPanelRight:Kill()
		InterfaceOptionsActionBarsPanelRightTwo:Kill()
		InterfaceOptionsActionBarsPanelAlwaysShowActionBars:Kill()
	end

	if C.nameplate.enable then
		SetCVar("ShowClassColorInNameplate", 1)
	end

	if C.minimap.enable then
		InterfaceOptionsDisplayPanelRotateMinimap:Kill()
	end

	--[[
	if C.bag.enable then
		SetSortBagsRightToLeft(true)
		SetInsertItemsLeftToRight(false)
	end
	--]]
end)