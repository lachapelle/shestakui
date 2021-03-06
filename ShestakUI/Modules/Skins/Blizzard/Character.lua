local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Character skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	CharacterFrame:StripTextures(true)
	CharacterFrame:CreateBackdrop("Transparent")
	CharacterFrame.backdrop:SetPoint("TOPLEFT", 10, -12)
	CharacterFrame.backdrop:SetPoint("BOTTOMRIGHT", -32, 76)

	T.SkinCloseButton(CharacterFrameCloseButton)
	CharacterFrameCloseButton:ClearAllPoints()
	CharacterFrameCloseButton:SetPoint("TOPRIGHT", CharacterFrame, "TOPRIGHT", -36, -16)

	for i = 1, #CHARACTERFRAME_SUBFRAMES do
		local tab = _G["CharacterFrameTab"..i]
		T.SkinTab(tab)
	end

	-- Character Frame
	PaperDollFrame:StripTextures()

	CharacterModelFrame:SetPoint("TOPLEFT", 65, -60)

	PlayerTitleDropDown:SetPoint("TOP", CharacterLevelText, "BOTTOM", 0, -2)
	T.SkinDropDownBox(PlayerTitleDropDown)

	T.SkinRotateButton(CharacterModelFrameRotateLeftButton)
	CharacterModelFrameRotateLeftButton:ClearAllPoints()
	CharacterModelFrameRotateLeftButton:SetPoint("TOPLEFT", 3, -3)

	T.SkinRotateButton(CharacterModelFrameRotateRightButton)
	CharacterModelFrameRotateLeftButton:ClearAllPoints()
	CharacterModelFrameRotateRightButton:SetPoint("TOPLEFT", CharacterModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)

	CharacterAttributesFrame:StripTextures()

	local function FixWidth(self)
		UIDropDownMenu_SetWidth(90, self)
	end

	T.SkinDropDownBox(PlayerStatFrameLeftDropDown)
	PlayerStatFrameLeftDropDown:HookScript("OnShow", FixWidth)

	T.SkinDropDownBox(PlayerStatFrameRightDropDown)
	PlayerStatFrameRightDropDown:HookScript("OnShow", FixWidth)

	-- CharacterResistanceFrame:CreateBackdrop("Default")
	-- CharacterResistanceFrame.backdrop:SetOutside(MagicResFrame1, nil, nil, MagicResFrame5)

	local function HandleResistanceFrame(frameName)
		for i = 1, 5 do
			local frame = _G[frameName..i]

			frame:SetSize(24, 24)
			frame:SetTemplate("Default")

			if i ~= 1 then
				frame:ClearAllPoints()
				frame:SetPoint("TOP", _G[frameName..i-1], "BOTTOM", 0, -3)
			end

			select(1, _G[frameName..i]:GetRegions()):SetInside()
			select(1, _G[frameName..i]:GetRegions()):SetDrawLayer("ARTWORK")
			select(2, _G[frameName..i]:GetRegions()):SetDrawLayer("OVERLAY")
		end
	end

	HandleResistanceFrame("MagicResFrame")

	select(1, MagicResFrame1:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.25, 0.32421875)		-- Arcane
	select(1, MagicResFrame2:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.0234375, 0.09765625)	-- Fire
	select(1, MagicResFrame3:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.13671875, 0.2109375)	-- Nature
	select(1, MagicResFrame4:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.36328125, 0.4375)		-- Frost
	select(1, MagicResFrame5:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.4765625, 0.55078125)	-- Shadow

	local slots = {
		"HeadSlot",
		"NeckSlot",
		"ShoulderSlot",
		"BackSlot",
		"ChestSlot",
		"ShirtSlot",
		"TabardSlot",
		"WristSlot",
		"HandsSlot",
		"WaistSlot",
		"LegsSlot",
		"FeetSlot",
		"Finger0Slot",
		"Finger1Slot",
		"Trinket0Slot",
		"Trinket1Slot",
		"MainHandSlot",
		"SecondaryHandSlot",
		"RangedSlot",
		"AmmoSlot"
	}

	for _, slot in pairs(slots) do
		local icon = _G["Character"..slot.."IconTexture"]
		local cooldown = _G["Character"..slot.."Cooldown"]

		slot = _G["Character"..slot]
		slot:StripTextures()
		slot:StyleButton(false)
		slot:SetTemplate("Default", true, true)

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetInside()

		slot:SetFrameLevel(PaperDollFrame:GetFrameLevel() + 2)

		if(cooldown) then
			T.CreateAuraWatch(cooldown)
		end
	end

	--[[
	for i = 1, #PlayerTitlePickerScrollFrame.buttons do
		-- PlayerTitlePickerScrollFrame.buttons[i].text:FontTemplate()
		PlayerTitlePickerScrollFrame.buttons[i].text:SetFont(C.media.normal_font, 11, nil)
	end

	T.SkinScrollBar(PlayerTitlePickerScrollFrameScrollBar)
	--]]

	--[[
	local function ColorItemBorder()
		if event == "UNIT_INVENTORY_CHANGED" and unit ~= "player" then return end

		for _, slot in pairs(slots) do
			local target = _G["Character"..slot]
			local slotId = GetInventorySlotInfo(slot)
			local itemId = GetInventoryItemTexture("player", slotId)

			if itemId then
				local rarity = GetInventoryItemQuality("player", slotId)
				if rarity and rarity > 1 then
					target:SetBackdropBorderColor(GetItemQualityColor(rarity))
				else
					target:SetBackdropBorderColor(unpack(C.media.backdrop_color))
				end
			else
				target:SetBackdropBorderColor(unpack(C.media.backdrop_color))
			end
		end
	end

	local CheckItemBorderColor = CreateFrame("Frame")
	CheckItemBorderColor:RegisterEvent("UNIT_INVENTORY_CHANGED")
	CheckItemBorderColor:SetScript("OnEvent", ColorItemBorder)
	CharacterFrame:HookScript("OnShow", ColorItemBorder)
	ColorItemBorder()
	--]]

	-- Pet Frame
	PetPaperDollFrame:StripTextures()
	
	T.SkinTab(PetPaperDollCloseButton)

	T.SkinRotateButton(PetModelFrameRotateLeftButton)
	PetModelFrameRotateLeftButton:ClearAllPoints()
	PetModelFrameRotateLeftButton:SetPoint("TOPLEFT", 3, -3)

	T.SkinRotateButton(PetModelFrameRotateRightButton)
	PetModelFrameRotateRightButton:ClearAllPoints()
	PetModelFrameRotateRightButton:SetPoint("TOPLEFT", PetModelFrameRotateLeftButton, "TOPRIGHT", 3, 0)

	PetAttributesFrame:StripTextures()

	-- PetResistanceFrame:CreateBackdrop("Default")
	-- PetResistanceFrame.backdrop:SetOutside(PetMagicResFrame1, nil, nil, PetMagicResFrame5)

	HandleResistanceFrame("PetMagicResFrame")

	select(1, PetMagicResFrame1:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.25, 0.32421875)		-- Arcane
	select(1, PetMagicResFrame2:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.0234375, 0.09765625)	-- Fire
	select(1, PetMagicResFrame3:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.13671875, 0.2109375)	-- Nature
	select(1, PetMagicResFrame4:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.36328125, 0.4375)		-- Frost
	select(1, PetMagicResFrame5:GetRegions()):SetTexCoord(0.21875, 0.8125, 0.4765625, 0.55078125)	-- Shadow

	PetPaperDollFrameExpBar:StripTextures()
	PetPaperDollFrameExpBar:CreateBackdrop("Default")
	PetPaperDollFrameExpBar:SetStatusBarTexture(C.media.blank)

	local function updHappiness(self)
		local happiness = GetPetHappiness()
		local _, isHunterPet = HasPetUI()
		if not happiness or not isHunterPet then return end

		local texture = self:GetRegions()
		if happiness == 1 then
			texture:SetTexCoord(0.41, 0.53, 0.06, 0.30)
		elseif happiness == 2 then
			texture:SetTexCoord(0.22, 0.345, 0.06, 0.30)
		elseif happiness == 3 then
			texture:SetTexCoord(0.04, 0.15, 0.06, 0.30)
		end
	end

	PetPaperDollPetInfo:CreateBackdrop("Default")
	PetPaperDollPetInfo:SetPoint("TOPLEFT", PetModelFrameRotateLeftButton, "BOTTOMLEFT", 9, -3)
	PetPaperDollPetInfo:GetRegions():SetTexCoord(0.04, 0.15, 0.06, 0.30)
	PetPaperDollPetInfo:SetFrameLevel(PetModelFrame:GetFrameLevel() + 2)
	PetPaperDollPetInfo:SetSize(24, 24)

	updHappiness(PetPaperDollPetInfo)
	PetPaperDollPetInfo:RegisterEvent("UNIT_HAPPINESS")
	PetPaperDollPetInfo:SetScript("OnEvent", updHappiness)
	PetPaperDollPetInfo:SetScript("OnShow", updHappiness)

	-- Reputation Frame
	ReputationFrame:StripTextures()

	for i = 1, NUM_FACTIONS_DISPLAYED do
		local bar = _G["ReputationBar"..i]
		local header = _G["ReputationHeader"..i]
		local name = _G["ReputationBar"..i.."FactionName"]
		local war = _G["ReputationBar"..i.."AtWarCheck"]

		bar:StripTextures()
		bar:CreateBackdrop("Default")
		bar:SetStatusBarTexture(C.media.blank)
		bar:SetSize(108, 13)

		if i == 1 then
			bar:SetPoint("TOPLEFT", 190, -86)
		end
		
		name:SetPoint("LEFT", bar, "LEFT", -150, 0)
		name:SetWidth(140)

		header:StripTextures(true)
		header:SetNormalTexture(nil)
		header:SetPoint("TOPLEFT", bar, "TOPLEFT", -170, 0)
		
		header.Text = header:CreateFontString(nil, "OVERLAY")
		header.Text:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		header.Text:SetPoint("LEFT", header, "LEFT", 10, 1)
		header.Text:SetText("-")

		war:StripTextures()
		war:SetPoint("LEFT", bar, "RIGHT", 0, 0)

		war.icon = war:CreateTexture(nil, "OVERLAY")
		war.icon:SetPoint("LEFT", 3, -6)
		war.icon:SetTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	end

	local function UpdateFaction()
		local numFactions = GetNumFactions()
		local offset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		local index, header

		for i = 1, NUM_FACTIONS_DISPLAYED, 1 do
			header = _G["ReputationHeader"..i]
			index = offset + i

			if index <= numFactions then
				if header.isCollapsed then
					header:StripTextures(true)
					header:SetNormalTexture(nil)
					header.Text:SetText("+")
				else
					header:StripTextures(true)
					header:SetNormalTexture(nil)
					header.Text:SetText("-")
				end
			end
		end
	end
	hooksecurefunc("ReputationFrame_Update", UpdateFaction)

	ReputationFrameStandingLabel:SetPoint("TOPLEFT", 223, -59)
	ReputationFrameFactionLabel:SetPoint("TOPLEFT", 55, -59)

	ReputationListScrollFrame:StripTextures()
	T.SkinScrollBar(ReputationListScrollFrameScrollBar)

	ReputationDetailFrame:StripTextures()
	ReputationDetailFrame:SetTemplate("Transparent")
	ReputationDetailFrame:SetPoint("TOPLEFT", ReputationFrame, "TOPRIGHT", -32, -12)

	T.SkinCloseButton(ReputationDetailCloseButton)
	ReputationDetailCloseButton:SetPoint("TOPRIGHT", -4, -4)

	T.SkinCheckBox(ReputationDetailAtWarCheckBox)
	ReputationDetailAtWarCheckBox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-SwordCheck")
	T.SkinCheckBox(ReputationDetailInactiveCheckBox)
	T.SkinCheckBox(ReputationDetailMainScreenCheckBox)

	-- Skill Frame
	SkillFrame:StripTextures()

	SkillFrameExpandButtonFrame:DisableDrawLayer("BACKGROUND")

	SkillFrameCollapseAllButton:SetPoint("LEFT", SkillFrameExpandTabLeft, "RIGHT", -70, -3)

	SkillFrameCollapseAllButton.Text = SkillFrameCollapseAllButton:CreateFontString(nil, "OVERLAY")
	SkillFrameCollapseAllButton.Text:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
	SkillFrameCollapseAllButton.Text:SetPoint("LEFT", SkillFrameCollapseAllButton, "LEFT", 15, 1)
	SkillFrameCollapseAllButton.Text:SetText("-")

	hooksecurefunc(SkillFrameCollapseAllButton, "SetNormalTexture", function(self, texture)
		if string.find(texture, "MinusButton") then
			self:StripTextures()
			SkillFrameCollapseAllButton.Text:SetText("-")
		else
			self:StripTextures()
			SkillFrameCollapseAllButton.Text:SetText("+")
		end
	end)

	SkillFrameCancelButton:SkinButton()

	for i = 1, SKILLS_TO_DISPLAY do
		local bar = _G["SkillRankFrame"..i]
		local label = _G["SkillTypeLabel"..i]
		local border = _G["SkillRankFrame"..i.."Border"]
		local background = _G["SkillRankFrame"..i.."Background"]

		bar:CreateBackdrop("Default")
		bar:SetStatusBarTexture(C.media.blank)

		border:StripTextures()
		background:SetTexture(nil)

		label:StripTextures()

		label:SetPoint("TOPLEFT", bar, "TOPLEFT", -30, 0)

		label.Text = label:CreateFontString(nil, "OVERLAY")
		label.Text:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		label.Text:SetPoint("LEFT", label, "LEFT", 15, 1)
		label.Text:SetText("-")

		hooksecurefunc(label, "SetNormalTexture", function(self, texture)
			if string.find(texture, "MinusButton") then
				self:StripTextures()
			else
				self:StripTextures()
			end
		end)
	end

	SkillListScrollFrame:StripTextures()
	T.SkinScrollBar(SkillListScrollFrameScrollBar)

	SkillDetailScrollFrame:StripTextures()
	T.SkinScrollBar(SkillDetailScrollFrameScrollBar)

	SkillDetailStatusBar:StripTextures()
	SkillDetailStatusBar:CreateBackdrop("Default")
	SkillDetailStatusBar:SetParent(SkillDetailScrollFrame)
	SkillDetailStatusBar:SetStatusBarTexture(C.media.blank)
	-- E:RegisterStatusBar(SkillDetailStatusBar)

	T.SkinNextPrevButton(SkillDetailStatusBarUnlearnButton)
	-- S:SquareButton_SetIcon(SkillDetailStatusBarUnlearnButton, "DELETE")
	SkillDetailStatusBarUnlearnButton:SetSize(24, 24)
	SkillDetailStatusBarUnlearnButton:SetPoint("LEFT", SkillDetailStatusBarBorder, "RIGHT", 5, 0)
	SkillDetailStatusBarUnlearnButton:SetHitRectInsets(0, 0, 0, 0)

	-- PvP Frame
	PVPFrame:StripTextures(true)

	for i = 1, MAX_ARENA_TEAMS do
		local pvpTeam = _G["PVPTeam"..i]

		pvpTeam:StripTextures()
		pvpTeam:CreateBackdrop("Default")
		pvpTeam.backdrop:SetPoint("TOPLEFT", 9, -4)
		pvpTeam.backdrop:SetPoint("BOTTOMRIGHT", -24, 3)

		pvpTeam:HookScript("OnEnter", T.SetModifiedBackdrop)
		pvpTeam:HookScript("OnLeave", T.SetOriginalBackdrop)

		_G["PVPTeam"..i.."Highlight"]:Kill()
	end

	PVPTeamDetails:StripTextures()
	PVPTeamDetails:SetTemplate("Transparent")
	PVPTeamDetails:SetPoint("TOPLEFT", PVPFrame, "TOPRIGHT", -30, -12)

	T.SkinNextPrevButton(PVPFrameToggleButton)
	PVPFrameToggleButton:SetPoint("BOTTOMRIGHT", PVPFrame, "BOTTOMRIGHT", -48, 81)
	PVPFrameToggleButton:SetSize(14, 14)

	for i = 1, 5 do
		local header = _G["PVPTeamDetailsFrameColumnHeader"..i]

		header:StripTextures()
		-- header:StyleButton()
	end

	for i = 1, 10 do
		local button = _G["PVPTeamDetailsButton"..i]

		button:SetWidth(335)
		-- S:HandleButtonHighlight(button)
	end

	PVPTeamDetailsAddTeamMember:SkinButton()

	T.SkinNextPrevButton(PVPTeamDetailsToggleButton)

	T.SkinCloseButton(PVPTeamDetailsCloseButton)
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)