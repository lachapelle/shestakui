local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

local _G = _G
local ipairs = ipairs
local find = string.find

local InCombatLockdown = InCombatLockdown

----------------------------------------------------------------------------------------
--	Options skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	-- Game Menu Interface/Tabs
	for i = 1, 2 do
		local tab = _G["InterfaceOptionsFrameTab"..i]

		tab:StripTextures()
		T.SkinTab(tab)

		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:SetPoint("TOPLEFT", 10, -6)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -10, 1)
	end

	InterfaceOptionsFrameTab1:ClearAllPoints()
	InterfaceOptionsFrameTab1:SetPoint("BOTTOMLEFT", InterfaceOptionsFrameCategories, "TOPLEFT", -11, -2)

	-- Game Menu Plus / Minus Buttons
	local maxButtons = (InterfaceOptionsFrameAddOns:GetHeight() - 8) / InterfaceOptionsFrameAddOns.buttonHeight
	for i = 1, maxButtons do
		local buttonToggle = _G["InterfaceOptionsFrameAddOnsButton"..i.."Toggle"]
		buttonToggle:SetNormalTexture("")
		buttonToggle.SetNormalTexture = T.dummy
		buttonToggle:SetPushedTexture("")
		buttonToggle.SetPushedTexture = T.dummy
		buttonToggle:SetHighlightTexture(nil)

		buttonToggle.Text = buttonToggle:CreateFontString(nil, "OVERLAY")
		buttonToggle.Text:SetFont(C.media.normal_font, 22, nil)
		buttonToggle.Text:SetPoint("CENTER")
		buttonToggle.Text:SetText("+")

		hooksecurefunc(buttonToggle, "SetNormalTexture", function(self, texture)
			if find(texture, "MinusButton") then
				self.Text:SetText("-")
			else
				self.Text:SetText("+")
			end
		end)
	end

	-- Interface Options Frame
	InterfaceOptionsFrame:SetTemplate("Transparent")
	InterfaceOptionsFrame:SetClampedToScreen(true)
	InterfaceOptionsFrame:SetMovable(true)
	InterfaceOptionsFrame:EnableMouse(true)
	InterfaceOptionsFrame:RegisterForDrag("LeftButton", "RightButton")
	InterfaceOptionsFrame:SetScript("OnDragStart", function(self)
		if InCombatLockdown() then return end

		self:StartMoving()
		self.isMoving = true
	end)
	InterfaceOptionsFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
		self.isMoving = false
	end)

	local skins = {
		"OptionsFrame",
		"OptionsFrameDisplay",
		"OptionsFrameBrightness",
		"OptionsFrameWorldAppearance",
		"OptionsFramePixelShaders",
		"OptionsFrameMiscellaneous",
		"AudioOptionsFrame",
		"SoundOptionsFramePlayback",
		"SoundOptionsFrameHardware",
		"SoundOptionsFrameVolume",
	}
	for i = 1, #skins do
		_G[skins[i]]:SetTemplate("Transparent")
	end

	local BlizzardHeader = {
		"InterfaceOptionsFrame",
		"AudioOptionsFrame",
		"OptionsFrame",
	}
	for i = 1, #BlizzardHeader do
		local title = _G[BlizzardHeader[i].."Header"]
		if title then
			title:SetTexture("")
			title:ClearAllPoints()
			title:SetPoint("TOP", BlizzardHeader[i], 0, 0)
		end
	end

	local BlizzardButtons = {
		"OptionsFrameOkay",
		"OptionsFrameCancel",
		"OptionsFrameDefaults",
		"SoundOptionsFrameOkay",
		"SoundOptionsFrameCancel",
		"SoundOptionsFrameDefaults",
		"InterfaceOptionsFrameDefaults",
		"InterfaceOptionsFrameOkay",
		"InterfaceOptionsFrameCancel",
	}
	for i = 1, #BlizzardButtons do
		local ShestakUIButtons = _G[BlizzardButtons[i]]
		if ShestakUIButtons then
			ShestakUIButtons:SkinButton()
		end
	end

	local frames = {
		"OptionsFrameCategoryFrame",
		"OptionsFramePanelContainer",
		"OptionsResolutionPanelBrightness",
		"SoundOptionsFrameCategoryFrame",
		"SoundOptionsFramePanelContainer",
		"InterfaceOptionsFrameCategories",
		"InterfaceOptionsFramePanelContainer",
		"InterfaceOptionsFrameAddOns",
		"SoundOptionsSoundPanelPlayback",
		"SoundOptionsSoundPanelVolume",
		"SoundOptionsSoundPanelHardware",
		"OptionsEffectsPanelQuality",
		"OptionsEffectsPanelShaders",
	}
	for i = 1, #frames do
		local SkinFrames = _G[frames[i]]
		if SkinFrames then
			SkinFrames:StripTextures()
			SkinFrames:CreateBackdrop("Transparent")
			if SkinFrames ~= _G["OptionsFramePanelContainer"] and SkinFrames ~= _G["InterfaceOptionsFramePanelContainer"] then
				SkinFrames.backdrop:SetPoint("TOPLEFT",-1,0)
				SkinFrames.backdrop:SetPoint("BOTTOMRIGHT",0,1)
			else
				SkinFrames.backdrop:SetPoint("TOPLEFT", 0, 0)
				SkinFrames.backdrop:SetPoint("BOTTOMRIGHT", 0, 0)
			end
		end
	end

	OptionsFrameCancel:ClearAllPoints()
	OptionsFrameCancel:SetPoint("BOTTOMLEFT", OptionsFrame, "BOTTOMRIGHT", -105, 15)

	OptionsFrameOkay:ClearAllPoints()
	OptionsFrameOkay:SetPoint("RIGHT", OptionsFrameCancel, "LEFT", -4, 0)

	SoundOptionsFrameOkay:ClearAllPoints()
	SoundOptionsFrameOkay:SetPoint("RIGHT", SoundOptionsFrameCancel, "LEFT", -4, 0)

	InterfaceOptionsFrameCancel:ClearAllPoints()
	InterfaceOptionsFrameCancel:SetPoint("TOPRIGHT", InterfaceOptionsFramePanelContainer, "BOTTOMRIGHT", 0,- 6)

	InterfaceOptionsFrameOkay:ClearAllPoints()
	InterfaceOptionsFrameOkay:SetPoint("RIGHT", InterfaceOptionsFrameCancel, "LEFT", -4, 0)

	InterfaceOptionsFrameDefaults:ClearAllPoints()
	InterfaceOptionsFrameDefaults:SetPoint("TOPLEFT", InterfaceOptionsFrameCategories, "BOTTOMLEFT", -1, -5)

	InterfaceOptionsFrameCategoriesList:StripTextures()

	T.SkinScrollBar(InterfaceOptionsFrameCategoriesListScrollBar)

	InterfaceOptionsFrameAddOnsList:StripTextures()

	T.SkinScrollBar(InterfaceOptionsFrameAddOnsListScrollBar)

	OptionsFrameDefaults:ClearAllPoints()
	OptionsFrameDefaults:SetPoint("TOPLEFT", OptionsFrame, "BOTTOMLEFT", 15, 36)

	local interfacecheckbox = {
		"ControlsPanelStickyTargeting",
		"ControlsPanelFixInputLag",
		"ControlsPanelAutoDismount",
		"ControlsPanelAutoClearAFK",
		"ControlsPanelBlockTrades",
		"ControlsPanelLootAtMouse",
		"ControlsPanelAutoLootCorpse",
		"CombatPanelAttackOnAssist",
		"CombatPanelAutoRange",
		"CombatPanelStopAutoAttack",
		"CombatPanelAutoSelfCast",
		"CombatPanelTargetOfTarget",
		"CombatPanelEnemyCastBarsOnPortrait",
		"CombatPanelEnemyCastBarsOnNameplates",
		"DisplayPanelShowCloak",
		"DisplayPanelShowHelm",
		"DisplayPanelDetailedLootInfo",
		"DisplayPanelShowFreeBagSpace",
		"DisplayPanelRotateMinimap",
		"DisplayPanelScreenEdgeFlash",
		"DisplayPanelShowClock",
		"DisplayPanelBuffDurations",
		"QuestsPanelInstantQuestText",
		"QuestsPanelAutoQuestTracking",
		"SocialPanelProfanityFilter",
		"SocialPanelSpamFilter",
		"SocialPanelChatBubbles",
		"SocialPanelPartyChat",
		"SocialPanelChatHoverDelay",
		"SocialPanelGuildMemberAlert",
		"SocialPanelGuildRecruitment",
		"SocialPanelShowChatIcons",
		"SocialPanelSimpleChat",
		"SocialPanelLockChatSettings",
		"ActionBarsPanelLockActionBars",
		"ActionBarsPanelSecureAbilityToggle",
		"ActionBarsPanelAlwaysShowActionBars",
		"ActionBarsPanelBottomLeft",
		"ActionBarsPanelBottomRight",
		"ActionBarsPanelRight",
		"ActionBarsPanelRightTwo",
		"NamesPanelMyName",
		"NamesPanelCompanions",
		"NamesPanelFriendlyPlayerNames",
		"NamesPanelFriendlyPetsMinions",
		"NamesPanelFriendlyCreations",
		"NamesPanelGuilds",
		"NamesPanelNPCNames",
		"NamesPanelTitles",
		"NamesPanelEnemyPlayerNames",
		"NamesPanelEnemyPetsMinions",
		"NamesPanelEnemyCreations",
		"CombatTextPanelTargetDamage",
		"CombatTextPanelPeriodicDamage",
		"CombatTextPanelPetDamage",
		"CombatTextPanelHealing",
		"CombatTextPanelEnableFCT",
		"CombatTextPanelDodgeParryMiss",
		"CombatTextPanelDamageReduction",
		"CombatTextPanelRepChanges",
		"CombatTextPanelReactiveAbilities",
		"CombatTextPanelFriendlyHealerNames",
		"CombatTextPanelCombatState",
		"CombatTextPanelComboPoints",
		"CombatTextPanelLowManaHealth",
		"CombatTextPanelEnergyGains",
		"CombatTextPanelHonorGains",
		"CombatTextPanelAuras",
		"CameraPanelFollowTerrain",
		"CameraPanelHeadBob",
		"CameraPanelWaterCollision",
		"CameraPanelSmartPivot",
		"MousePanelInvertMouse",
		"MousePanelClickToMove",
		"HelpPanelTutorials",
		"HelpPanelLoadingScreenTips",
		"HelpPanelEnhancedTooltips",
		"HelpPanelBeginnerTooltips",
		"HelpPanelShowLuaErrors",
		"StatusTextPanelPlayer",
		"StatusTextPanelPet",
		"StatusTextPanelParty",
		"StatusTextPanelTarget",
		"StatusTextPanelPercentages",
		"StatusTextPanelXP",
		"PartyRaidPanelPartyBackground",
		"PartyRaidPanelPartyInRaid",
		"PartyRaidPanelPartyPets",
		"PartyRaidPanelDispellableDebuffs",
		"PartyRaidPanelCastableBuffs",
		"PartyRaidPanelRaidRange"
	}
	for i = 1, #interfacecheckbox do
		local icheckbox = _G["InterfaceOptions"..interfacecheckbox[i]]
		if icheckbox then
			T.SkinCheckBox(icheckbox)
		end
	end
	local interfacedropdown ={
		"ControlsPanelAutoLootKeyDropDown",
		"CombatPanelTOTDropDown",
		"CombatPanelFocusCastKeyDropDown",
		"CombatPanelSelfCastKeyDropDown",
		"DisplayPanelAggroWarningDisplay",
		"DisplayPanelWorldPVPObjectiveDisplay",
		"SocialPanelChatStyle",
		"SocialPanelTimestamps",
		"CombatTextPanelFCTDropDown",
		"CameraPanelStyleDropDown",
		"MousePanelClickMoveStyleDropDown",
		"LanguagesPanelLocaleDropDown"
	}
	for i = 1, #interfacedropdown do
		local idropdown = _G["InterfaceOptions"..interfacedropdown[i]]
		if idropdown then
			-- T.SkinCheckBox(idropdown)
		end
	end

	InterfaceOptionsHelpPanelResetTutorials:SkinButton()

	local optioncheckbox = {
		"OptionsFrameCheckButton1",
		"OptionsFrameCheckButton2",
		"OptionsFrameCheckButton3",
		"OptionsFrameCheckButton4",
		"OptionsFrameCheckButton5",
		"OptionsFrameCheckButton6",
		"OptionsFrameCheckButton7",
		"OptionsFrameCheckButton8",
		"OptionsFrameCheckButton9",
		"OptionsFrameCheckButton10",
		"OptionsFrameCheckButton11",
		"OptionsFrameCheckButton12",
		"OptionsFrameCheckButton13",
		"OptionsFrameCheckButton14",
		"OptionsFrameCheckButton15",
		"OptionsFrameCheckButton16",
		"OptionsFrameCheckButton17",
		"OptionsFrameCheckButton18",
		"OptionsFrameCheckButton19",
		"SoundOptionsFrameCheckButton1",
		"SoundOptionsFrameCheckButton2",
		"SoundOptionsFrameCheckButton3",
		"SoundOptionsFrameCheckButton4",
		"SoundOptionsFrameCheckButton5",
		"SoundOptionsFrameCheckButton6",
		"SoundOptionsFrameCheckButton7",
		"SoundOptionsFrameCheckButton8",
		"SoundOptionsFrameCheckButton9",
		"SoundOptionsFrameCheckButton10",
		"SoundOptionsFrameCheckButton11"
	}
	for i = 1, #optioncheckbox do
		local ocheckbox = _G[optioncheckbox[i]]
		if ocheckbox then
			T.SkinCheckBox(ocheckbox)
		end
	end

	SoundOptionsFrameCheckButton1:SetPoint("TOPLEFT", "SoundOptionsFrame", "TOPLEFT", 16, -15)

	local optiondropdown = {
		"OptionsFrameResolutionDropDown",
		"OptionsFrameRefreshDropDown",
		"OptionsFrameMultiSampleDropDown",
		"SoundOptionsOutputDropDown",
	}
	for i = 1, #optiondropdown do
		local odropdown = _G[optiondropdown[i]]
		if odropdown then
			T.SkinDropDownBox(odropdown, i == 3 and 195 or 165)
		end
	end

	T.SkinSlider(InterfaceOptionsCameraPanelMaxDistanceSlider)
	T.SkinSlider(InterfaceOptionsCameraPanelFollowSpeedSlider)
	T.SkinSlider(InterfaceOptionsMousePanelMouseSensitivitySlider)
	T.SkinSlider(InterfaceOptionsMousePanelMouseLookSpeedSlider)

	-- Video Options Sliders
	for i = 1, 11 do
		T.SkinSlider(_G["OptionsFrameSlider"..i])
	end

	-- Sound Options Sliders
	for i = 1, 6 do
		T.SkinSlider(_G["SoundOptionsFrameSlider"..i])
	end

	-- Chat Config
	ChatConfigFrame:StripTextures()
	ChatConfigFrame:SetTemplate("Transparent")
	ChatConfigCategoryFrame:SetTemplate("Transparent")
	ChatConfigBackgroundFrame:SetTemplate("Transparent")

	ChatConfigCombatSettingsFilters:SetTemplate("Transparent")

	ChatConfigCombatSettingsFiltersScrollFrame:StripTextures()

	T.SkinScrollBar(ChatConfigCombatSettingsFiltersScrollFrameScrollBar)
	ChatConfigCombatSettingsFiltersScrollFrameScrollBarBorder:Kill()

	ChatConfigCombatSettingsFiltersDeleteButton:SkinButton()
	ChatConfigCombatSettingsFiltersDeleteButton:SetPoint("TOPRIGHT", ChatConfigCombatSettingsFilters, "BOTTOMRIGHT", 0, -1)

	ChatConfigCombatSettingsFiltersAddFilterButton:SkinButton()
	ChatConfigCombatSettingsFiltersAddFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersDeleteButton, "LEFT", -1, 0)

	ChatConfigCombatSettingsFiltersCopyFilterButton:SkinButton()
	ChatConfigCombatSettingsFiltersCopyFilterButton:SetPoint("RIGHT", ChatConfigCombatSettingsFiltersAddFilterButton, "LEFT", -1, 0)

	T.SkinNextPrevButton(ChatConfigMoveFilterUpButton, true)
	-- S:SquareButton_SetIcon(ChatConfigMoveFilterUpButton, "UP")
	ChatConfigMoveFilterUpButton:SetSize(26, 26)
	ChatConfigMoveFilterUpButton:SetPoint("TOPLEFT", ChatConfigCombatSettingsFilters, "BOTTOMLEFT", 3, -1)
	ChatConfigMoveFilterUpButton:SetHitRectInsets(0, 0, 0, 0)

	T.SkinNextPrevButton(ChatConfigMoveFilterDownButton, true)
	ChatConfigMoveFilterDownButton:SetSize(26, 26)
	ChatConfigMoveFilterDownButton:SetPoint("LEFT", ChatConfigMoveFilterUpButton, "RIGHT", 1, 0)
	ChatConfigMoveFilterDownButton:SetHitRectInsets(0, 0, 0, 0)

	CombatConfigColorsHighlighting:StripTextures()
	CombatConfigColorsColorizeUnitName:StripTextures()
	CombatConfigColorsColorizeSpellNames:StripTextures()

	CombatConfigColorsColorizeDamageNumber:StripTextures()
	CombatConfigColorsColorizeDamageSchool:StripTextures()
	CombatConfigColorsColorizeEntireLine:StripTextures()

	T.SkinEditBox(CombatConfigSettingsNameEditBox)

	CombatConfigSettingsSaveButton:SkinButton()

	local combatConfigCheck = {
		"CombatConfigColorsHighlightingLine",
		"CombatConfigColorsHighlightingAbility",
		"CombatConfigColorsHighlightingDamage",
		"CombatConfigColorsHighlightingSchool",
		"CombatConfigColorsColorizeUnitNameCheck",
		"CombatConfigColorsColorizeSpellNamesCheck",
		"CombatConfigColorsColorizeSpellNamesSchoolColoring",
		"CombatConfigColorsColorizeDamageNumberCheck",
		"CombatConfigColorsColorizeDamageNumberSchoolColoring",
		"CombatConfigColorsColorizeDamageSchoolCheck",
		"CombatConfigColorsColorizeEntireLineCheck",
		"CombatConfigFormattingShowTimeStamp",
		"CombatConfigFormattingShowBraces",
		"CombatConfigFormattingUnitNames",
		"CombatConfigFormattingSpellNames",
		"CombatConfigFormattingItemNames",
		"CombatConfigFormattingFullText",
		"CombatConfigSettingsShowQuickButton",
		"CombatConfigSettingsSolo",
		"CombatConfigSettingsParty",
		"CombatConfigSettingsRaid"
	}

	for i = 1, #combatConfigCheck do
		T.SkinCheckBox(_G[combatConfigCheck[i]])
	end

	for i = 1, 5 do
		local tab = _G["CombatConfigTab"..i]
		tab:StripTextures()

		tab:CreateBackdrop("Default", true)
		tab.backdrop:SetPoint("TOPLEFT", 1, -10)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -1, 2)

		tab:HookScript("OnEnter", T.SetModifiedBackdrop)
		tab:HookScript("OnLeave", T.SetOriginalBackdrop)
	end

	ChatConfigFrameDefaultButton:SkinButton()
	ChatConfigFrameDefaultButton:SetPoint("BOTTOMLEFT", 12, 8)
	ChatConfigFrameDefaultButton:SetWidth(125)

	CombatLogDefaultButton:SkinButton()

	ChatConfigFrameCancelButton:SkinButton()
	ChatConfigFrameCancelButton:SetPoint("BOTTOMRIGHT", -11, 8)

	ChatConfigFrameOkayButton:SkinButton()

	hooksecurefunc("ChatConfig_CreateCheckboxes", function(frame, checkBoxTable, checkBoxTemplate)
		local checkBoxNameString = frame:GetName().."CheckBox"
		if checkBoxTemplate == "ChatConfigCheckBoxTemplate" then
			frame:SetTemplate("Transparent")
			for index, _ in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index
				local checkbox = _G[checkBoxName]
				if not checkbox.backdrop then
					checkbox:StripTextures()
					checkbox:CreateBackdrop()
					checkbox.backdrop:SetPoint("TOPLEFT", 3, -1)
					checkbox.backdrop:SetPoint("BOTTOMRIGHT", -3, 1)
					checkbox.backdrop:SetFrameLevel(checkbox:GetParent():GetFrameLevel() + 1)

					T.SkinCheckBox(_G[checkBoxName.."Check"])
				end
			end
		elseif(checkBoxTemplate == "ChatConfigCheckBoxWithSwatchTemplate") or (checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate") then
			frame:SetTemplate("Transparent")
			for index, _ in ipairs(checkBoxTable) do
				local checkBoxName = checkBoxNameString..index
				local checkbox = _G[checkBoxName]
				if not checkbox.backdrop then
					checkbox:StripTextures()
					checkbox:CreateBackdrop()
					checkbox.backdrop:SetPoint("TOPLEFT", 3, -1)
					checkbox.backdrop:SetPoint("BOTTOMRIGHT", -3, 1)
					checkbox.backdrop:SetFrameLevel(checkbox:GetParent():GetFrameLevel() + 1)

					T.SkinCheckBox(_G[checkBoxName.."Check"])

					if checkBoxTemplate == "ChatConfigCheckBoxWithSwatchAndClassColorTemplate" then
						T.SkinCheckBox(_G[checkBoxName.."ColorClasses"])
					end
				end
			end
		end
	end)

	hooksecurefunc("ChatConfig_CreateTieredCheckboxes", function(frame, checkBoxTable)
		local checkBoxNameString = frame:GetName().."CheckBox"
		for index, value in ipairs(checkBoxTable) do
			local checkBoxName = checkBoxNameString..index
			if _G[checkBoxName] then
				T.SkinCheckBox(_G[checkBoxName])
				if value.subTypes then
					local subCheckBoxNameString = checkBoxName.."_"
					for k, _ in ipairs(value.subTypes) do
						local subCheckBoxName = subCheckBoxNameString..k
						if _G[subCheckBoxName] then
							T.SkinCheckBox(_G[subCheckBoxNameString..k])
						end
					end
				end
			end
		end
	end)

	hooksecurefunc("ChatConfig_CreateColorSwatches", function(frame, swatchTable)
		frame:SetTemplate("Transparent")
		local nameString = frame:GetName().."Swatch"
		for index, _ in ipairs(swatchTable) do
			local swatchName = nameString..index
			local swatch = _G[swatchName]
			if not swatch.backdrop then
				swatch:StripTextures()
				swatch:CreateBackdrop()
				swatch.backdrop:SetPoint("TOPLEFT", 3, -1)
				swatch.backdrop:SetPoint("BOTTOMRIGHT", -3, 1)
				swatch.backdrop:SetFrameLevel(swatch:GetParent():GetFrameLevel() + 1)
			end
		end
	end)

	-- Mac Options
	if IsMacClient() then
		GameMenuButtonMacOptions:SkinButton()

		-- Skin main frame and reposition the header
		MacOptionsFrame:SetTemplate("Default", true)
		MacOptionsFrameHeader:SetTexture("")
		MacOptionsFrameHeader:ClearAllPoints()
		MacOptionsFrameHeader:SetPoint("TOP", MacOptionsFrame, 0, 0)

		T.SkinDropDownBox(MacOptionsFrameResolutionDropDown)
		T.SkinDropDownBox(MacOptionsFrameFramerateDropDown)
		T.SkinDropDownBox(MacOptionsFrameCodecDropDown)

		T.SkinSlider(MacOptionsFrameQualitySlider)

		for i = 1, 8 do
			T.SkinCheckBox(_G["MacOptionsFrameCheckButton"..i])
		end

		--Skin internal frames
		MacOptionsFrameMovieRecording:SetTemplate("Default", true)
		MacOptionsITunesRemote:SetTemplate("Default", true)

		--Skin buttons
		MacOptionsFrameCancel:SkinButton()
		MacOptionsFrameOkay:SkinButton()
		MacOptionsButtonKeybindings:SkinButton()
		MacOptionsFrameDefaults:SkinButton()
		MacOptionsButtonCompress:SkinButton()

		--Reposition and resize buttons
		local tPoint, tRTo, tRP, _, tY = MacOptionsButtonCompress:GetPoint()
		MacOptionsButtonCompress:SetWidth(136)
		MacOptionsButtonCompress:ClearAllPoints()
		MacOptionsButtonCompress:SetPoint(tPoint, tRTo, tRP, 4, tY)

		MacOptionsFrameCancel:SetWidth(96)
		MacOptionsFrameCancel:SetHeight(22)
		tPoint, tRTo, tRP, _, tY = MacOptionsFrameCancel:GetPoint()
		MacOptionsFrameCancel:ClearAllPoints()
		MacOptionsFrameCancel:SetPoint(tPoint, tRTo, tRP, -14, tY)

		MacOptionsFrameOkay:ClearAllPoints()
		MacOptionsFrameOkay:SetWidth(96)
		MacOptionsFrameOkay:SetHeight(22)
		MacOptionsFrameOkay:SetPoint("LEFT",MacOptionsFrameCancel, -99,0)

		MacOptionsButtonKeybindings:ClearAllPoints()
		MacOptionsButtonKeybindings:SetWidth(96)
		MacOptionsButtonKeybindings:SetHeight(22)
		MacOptionsButtonKeybindings:SetPoint("LEFT",MacOptionsFrameOkay, -99,0)

		MacOptionsFrameDefaults:SetWidth(96)
		MacOptionsFrameDefaults:SetHeight(22)

		MacOptionsCompressFrame:SetTemplate("Default", true)

		MacOptionsCompressFrameHeader:SetTexture("")
		MacOptionsCompressFrameHeader:ClearAllPoints()
		MacOptionsCompressFrameHeader:SetPoint("TOP", MacOptionsCompressFrame, 0, 0)

		MacOptionsCompressFrameDelete:SkinButton()
		MacOptionsCompressFrameSkip:SkinButton()
		MacOptionsCompressFrameCompress:SkinButton()

		MacOptionsCancelFrame:SetTemplate("Default", true)

		MacOptionsCancelFrameHeader:SetTexture("")
		MacOptionsCancelFrameHeader:ClearAllPoints()
		MacOptionsCancelFrameHeader:SetPoint("TOP", MacOptionsCancelFrame, 0, 0)

		MacOptionsCancelFrameNo:SkinButton()
		MacOptionsCancelFrameYes:SkinButton()
	end
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)