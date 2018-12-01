local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	TalentUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	PlayerTalentFrame:StripTextures()
	PlayerTalentFrame:CreateBackdrop("Transparent")
	PlayerTalentFrame.backdrop:SetPoint("TOPLEFT", 13, -12)
	PlayerTalentFrame.backdrop:SetPoint("BOTTOMRIGHT", -31, 76)

	PlayerTalentFramePortrait:Hide()

	T.SkinCloseButton(PlayerTalentFrameCloseButton)
	PlayerTalentFrameCloseButton:SetPoint("TOPRIGHT", -35, -16)

	PlayerTalentFrameCancelButton:Kill()

	for i = 1, 5 do
		T.SkinTab(_G["PlayerTalentFrameTab"..i])
	end

	PlayerTalentFrameScrollFrame:StripTextures()
	PlayerTalentFrameScrollFrame:CreateBackdrop("Default")
	PlayerTalentFrameScrollFrame.backdrop:SetPoint("TOPLEFT", -1, 2)
	PlayerTalentFrameScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 6, -2)

	T.SkinScrollBar(PlayerTalentFrameScrollFrameScrollBar)
	PlayerTalentFrameScrollFrameScrollBar:SetPoint("TOPLEFT", PlayerTalentFrameScrollFrame, "TOPRIGHT", 10, -16)

	PlayerTalentFrameScrollButtonOverlay:Hide()

	PlayerTalentFrameSpentPoints:SetPoint("TOP", 0, -42)
	PlayerTalentFrameTalentPointsText:SetPoint("BOTTOMRIGHT", PlayerTalentFrame, "BOTTOMLEFT", 220, 84)

	for i = 1, MAX_NUM_TALENTS do
		local talent = _G["PlayerTalentFrameTalent"..i]
		local icon = _G["PlayerTalentFrameTalent"..i.."IconTexture"]
		local rank = _G["PlayerTalentFrameTalent"..i.."Rank"]

		if talent then
			talent:StripTextures()
			talent:SetTemplate("Default")
			talent:StyleButton()

			icon:SetInside()
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:SetDrawLayer("ARTWORK")

			rank:SetFont(C.media.pixel_font, C.media.pixel_font_size, C.media.pixel_font_style)
		end
	end
end

T.SkinFuncs["Blizzard_TalentUI"] = LoadSkin