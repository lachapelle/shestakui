local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	WorldMap skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	if IsAddOnLoaded("Mapster") then return end

	WorldMapFrame:StripTextures()
	WorldMapPositioningGuide:CreateBackdrop("Transparent")

	T.SkinDropDownBox(WorldMapZoneMinimapDropDown)
	T.SkinDropDownBox(WorldMapContinentDropDown)
	T.SkinDropDownBox(WorldMapZoneDropDown)

	WorldMapZoneDropDown:SetPoint("LEFT", WorldMapContinentDropDown, "RIGHT", -24, 0)
	WorldMapZoomOutButton:SetPoint("LEFT", WorldMapZoneDropDown, "RIGHT", -4, 3)

	WorldMapZoomOutButton:SkinButton()

	T.SkinCloseButton(WorldMapFrameCloseButton)
	WorldMapFrameCloseButton:SetPoint("TOPRIGHT", WorldMapPositioningGuide, "TOPRIGHT", -2, -2)

	WorldMapDetailFrame:CreateBackdrop("Default")

	WorldMapFrameAreaLabel:SetFont(C.media.normal_font, 50)
	WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
	WorldMapFrameAreaLabel:SetTextColor(0.9, 0.82, 0.64)

	WorldMapFrameAreaDescription:SetFont(C.media.normal_font, 40)
	WorldMapFrameAreaDescription:SetShadowOffset(1, -1)

	WorldMapFrame:RegisterEvent("PLAYER_LOGIN")
	WorldMapFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	WorldMapFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	WorldMapFrame:HookScript("OnEvent", function(self, event)
		if event == "PLAYER_LOGIN" then
			WorldMapFrame:Show()
			WorldMapFrame:Hide()
		elseif event == "PLAYER_REGEN_DISABLED" then
			if WorldMapFrame:IsShown() then
				HideUIPanel(WorldMapFrame)
			end
		end
	end)
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)