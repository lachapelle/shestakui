local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.misc.raid_tools ~= true then return end

----------------------------------------------------------------------------------------
--	Raid Utility (by Elv22)
----------------------------------------------------------------------------------------
-- Combat
local RaidUtilityHolder = CreateFrame("Frame", "RaidUtilityHolder", UIParent, "SecureStateHeaderTemplate")
RaidUtilityHolder:SetPoint(unpack(C.position.raid_utility))
RegisterStateDriver(RaidUtilityHolder, "visibility", "[combat] hide; show")

-- Create main frame
local RaidUtilityPanel = CreateFrame("Frame", "RaidUtilityPanel", RaidUtilityHolder)
RaidUtilityPanel:CreatePanel("Transparent", 170, 130, unpack(C.position.raid_utility))
--[[
if GetCVarBool("watchFrameWidth") then
	RaidUtilityPanel:SetPoint(C.position.raid_utility[1], C.position.raid_utility[2], C.position.raid_utility[3], C.position.raid_utility[4] + 100, C.position.raid_utility[5])
end
--]]
RaidUtilityPanel.toggled = false

-- Check if We are Raid Leader or Raid Officer
local function CheckRaidStatus()
	local _, instanceType = IsInInstance()
	if ((GetNumPartyMembers() > 0 and UnitIsPartyLeader("player") and not UnitInRaid("player")) or IsRaidLeader("player") or UnitIsRaidOfficer("player")) and (instanceType ~= "pvp" or instanceType ~= "arena") then
		return true
	else
		return false
	end
end

-- Function to create buttons in this module
local function CreateButton(name, parent, template, width, height, point, relativeto, point2, xOfs, yOfs, text)
	local b = CreateFrame("Button", name, parent, template)
	b:SetWidth(width)
	b:SetHeight(height)
	b:SetPoint(point, relativeto, point2, xOfs, yOfs)
	b:EnableMouse(true)
	if text then
		b.t = b:CreateFontString(nil, "OVERLAY")
		b.t:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		b.t:SetPoint("CENTER")
		b.t:SetJustifyH("CENTER")
		b.t:SetText(text)
	end
	b:SkinButton()
end

-- Show button
CreateButton("RaidUtilityShowButton", RaidUtilityHolder, "UIPanelButtonTemplate, SecureActionButtonTemplate", RaidUtilityPanel:GetWidth() / 1.5, 18, "TOP", RaidUtilityPanel, "TOP", 0, 0, RAID_CONTROL)
-- RaidUtilityShowButton:SetFrameRef("RaidUtilityPanel", RaidUtilityPanel)
-- RaidUtilityShowButton:SetAttribute("_onclick", [=[self:Hide(); self:GetFrameRef("RaidUtilityPanel"):Show();]=])
RaidUtilityShowButton:SetScript("OnMouseUp", function(self, button)
	if button == "RightButton" then
		if CheckRaidStatus() then
			DoReadyCheck()
		end
	elseif button == "LeftButton" and not InCombatLockdown() then
		RaidUtilityPanel.toggled = true
		RaidUtilityShowButton:Hide()
		RaidUtilityPanel:Show()
	end
end)

-- Close button
CreateButton("RaidUtilityCloseButton", RaidUtilityPanel, "UIPanelButtonTemplate, SecureActionButtonTemplate", RaidUtilityPanel:GetWidth() / 1.5, 18, "TOP", RaidUtilityPanel, "BOTTOM", 0, -1, CLOSE)
-- RaidUtilityCloseButton:SetFrameRef("RaidUtilityShowButton", RaidUtilityShowButton)
-- RaidUtilityCloseButton:SetAttribute("_onclick", [=[self:GetParent():Hide(); self:GetFrameRef("RaidUtilityShowButton"):Show();]=])
RaidUtilityCloseButton:SetScript("OnMouseUp", function(self)
	if not InCombatLockdown() then
		RaidUtilityPanel.toggled = false
		RaidUtilityShowButton:Show()
		RaidUtilityPanel:Hide()
	end
end)

-- Disband Group button
CreateButton("RaidUtilityDisbandButton", RaidUtilityPanel, "UIPanelButtonTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOP", RaidUtilityPanel, "TOP", 0, -5, L_RAID_UTIL_DISBAND)
RaidUtilityDisbandButton:SetScript("OnMouseUp", function(self) StaticPopup_Show("DISBAND_RAID") end)

-- Convert Group button
CreateButton("RaidUtilityConvertButton", RaidUtilityPanel, "UIPanelButtonTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOP", RaidUtilityDisbandButton, "BOTTOM", 0, -5, UnitInParty("player") and L_COMPATIBILITY_CONVERT_TO_RAID)
RaidUtilityConvertButton:SetScript("OnMouseUp", function(self)
	if UnitInParty("player") then
		ConvertToRaid()
	end
end)

-- MainTank button
CreateButton("RaidUtilityMainTankButton", RaidUtilityPanel, "UIPanelButtonTemplate, SecureActionButtonTemplate", (RaidUtilityPanel:GetWidth() * 0.8 / 2) - 2, 18, "TOPLEFT", RaidUtilityConvertButton, "BOTTOMLEFT", 0, -5, MAINTANK)
RaidUtilityMainTankButton:SetAttribute("type", "maintank")
RaidUtilityMainTankButton:SetAttribute("unit", "target")
RaidUtilityMainTankButton:SetAttribute("action", "toggle")

-- MainAssist button
CreateButton("RaidUtilityMainAssistButton", RaidUtilityPanel, "UIPanelButtonTemplate, SecureActionButtonTemplate", (RaidUtilityPanel:GetWidth() * 0.8 / 2) - 2, 18, "LEFT", RaidUtilityMainTankButton, "RIGHT", 4, 0, MAINASSIST)
RaidUtilityMainAssistButton:SetAttribute("type", "mainassist")
RaidUtilityMainAssistButton:SetAttribute("unit", "target")
RaidUtilityMainAssistButton:SetAttribute("action", "toggle")

-- Ready Check button
CreateButton("RaidUtilityReadyCheckButton", RaidUtilityPanel, "UIPanelButtonTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOPLEFT", RaidUtilityMainTankButton, "BOTTOMLEFT", 0, -5, READY_CHECK)
RaidUtilityReadyCheckButton:SetScript("OnMouseUp", function(self) DoReadyCheck() end)

-- Raid Control Panel
CreateButton("RaidUtilityRaidControlButton", RaidUtilityPanel, "UIPanelButtonTemplate", RaidUtilityPanel:GetWidth() * 0.8, 18, "TOPLEFT", RaidUtilityReadyCheckButton, "BOTTOMLEFT", 0, -5, RAID_CONTROL)
RaidUtilityRaidControlButton:SetScript("OnMouseUp", function(self)
	ToggleFriendsFrame(5)
end)

local function ToggleRaidUtil(self, event)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return
	end

	if CheckRaidStatus() then
		if RaidUtilityPanel.toggled == true then
			RaidUtilityShowButton:Hide()
			RaidUtilityPanel:Show()
		else
			RaidUtilityShowButton:Show()
			RaidUtilityPanel:Hide()
		end
	else
		RaidUtilityShowButton:Hide()
		RaidUtilityPanel:Hide()
	end
	
	if UnitInParty("player") then
		RaidUtilityConvertButton:Hide()
		RaidUtilityMainTankButton:SetPoint("TOPLEFT", RaidUtilityDisbandButton, "BOTTOMLEFT", 0, -5)
		RaidUtilityPanel:SetHeight(130)
	elseif UnitInRaid("player") then
		RaidUtilityConvertButton:Show()
		RaidUtilityMainTankButton:SetPoint("TOPLEFT", RaidUtilityConvertButton, "BOTTOMLEFT", 0, -5)
		RaidUtilityPanel:SetHeight(130)
	end

	if event == "PLAYER_REGEN_ENABLED" then
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end

-- Automatically show/hide the frame if we have Raid Leader or Raid Officer
local LeadershipCheck = CreateFrame("Frame")
LeadershipCheck:RegisterEvent("PLAYER_ENTERING_WORLD")
LeadershipCheck:RegisterEvent("PARTY_MEMBERS_CHANGED")
LeadershipCheck:RegisterEvent("RAID_ROSTER_UPDATE")
LeadershipCheck:RegisterEvent("PLAYER_REGEN_ENABLED")
LeadershipCheck:SetScript("OnEvent", ToggleRaidUtil)

-- Support Aurora
if IsAddOnLoaded("Aurora") then
	local F = unpack(Aurora)
	RaidUtilityPanel:SetBackdropColor(0, 0, 0, 0)
	RaidUtilityPanel:SetBackdropBorderColor(0, 0, 0, 0)
	RaidUtilityPanelInnerBorder:SetBackdropBorderColor(0, 0, 0, 0)
	RaidUtilityPanelOuterBorder:SetBackdropBorderColor(0, 0, 0, 0)
	F.CreateBD(RaidUtilityPanel)
end