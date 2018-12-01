local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Based on tekticles(by Tekkub)
----------------------------------------------------------------------------------------
local SetFont = function(obj, font, size, style, r, g, b, sr, sg, sb, sox, soy)
	obj:SetFont(font, size, style)
	if sr and sg and sb then obj:SetShadowColor(sr, sg, sb) end
	if sox and soy then obj:SetShadowOffset(sox, soy) end
	if r and g and b then obj:SetTextColor(r, g, b) end
end

local frame = CreateFrame("Frame", nil, UIParent)
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if addon ~= "ShestakUI" or addon == "tekticles" then return end

	local NORMAL = C.media.normal_font
	local BLANK = C.media.blank_font

	UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = 12
	CHAT_FONT_HEIGHTS = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20}

	UNIT_NAME_FONT = NORMAL
	STANDARD_TEXT_FONT = NORMAL
	DAMAGE_TEXT_FONT = NORMAL
	NAMEPLATE_FONT = NORMAL

	-- Base fonts
	SetFont(SystemFont, NORMAL, 13)
	SetFont(DialogButtonNormalText, NORMAL, 13)
	SetFont(ChatFontNormal, NORMAL, 13)
	SetFont(ChatFontSmall, NORMAL, 12)
	SetFont(CombatLogFont, NORMAL, 13)
	SetFont(InvoiceTextFontNormal, NORMAL, 13, nil, 0.15, 0.09, 0.04)
	SetFont(InvoiceTextFontSmall, NORMAL, 11, nil, 0.15, 0.09, 0.04)
	SetFont(MailTextFontNormal, NORMAL, 15, nil, 0, 0, 0, 0, 0, 0, C.skins.blizzard_frames and 1, C.skins.blizzard_frames and -1)
	SetFont(NumberFontNormalSmall, NORMAL, 13, "OUTLINE")
	SetFont(NumberFontNormalHuge, NORMAL, 30, "THICKOUTLINE", 30)
	SetFont(NumberFontNormalLarge, NORMAL, 17, "OUTLINE")
	SetFont(NumberFontNormal, NORMAL, 15, "OUTLINE")
	SetFont(CombatTextFont, NORMAL, 22, "THINOUTLINE")
	SetFont(QuestFont, NORMAL, 14)
	SetFont(QuestFontHighlight, NORMAL, 14)
	SetFont(QuestTitleFont, NORMAL, 18, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(TextStatusBarText, NORMAL, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(TextStatusBarTextSmall, NORMAL, 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(SubSpellFont, NORMAL, 11)
	SetFont(GameFontNormalHuge, NORMAL, 20)
	SetFont(GameFontNormalLarge, NORMAL, 17)
	SetFont(GameFontNormal, NORMAL, 13)
	SetFont(GameFontBlack, NORMAL, 14, nil, 0.15, 0.09, 0.04)
	SetFont(GameFontHighlightSmallOutline, NORMAL, 12, "OUTLINE")
	SetFont(GameFontNormalSmall, NORMAL, 11)
	SetFont(GameTooltipHeaderText, NORMAL, GetLocale() == "zhTW" and 14 or 13, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipText, NORMAL, GetLocale() == "zhTW" and 12 or 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(GameTooltipTextSmall, NORMAL, GetLocale() == "zhTW" and 12 or 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(ItemTextFontNormal, NORMAL, GetLocale() == "zhTW" and 12 or 11, nil, nil, nil, nil, 0, 0, 0, 1, -1)
	SetFont(ZoneTextFont, NORMAL, 32, "OUTLINE")
	SetFont(SubZoneTextFont, NORMAL, 25, "OUTLINE")
	SetFont(PVPInfoTextFont, NORMAL, 22, "THINOUTLINE")

	-- Derived fonts
	SetFont(BossEmoteNormalHuge, NORMAL, 27, "THICKOUTLINE")
	SetFont(ErrorFont, NORMAL, 16)
	SetFont(QuestFontNormalSmall, NORMAL, 13, nil, nil, nil, nil, 0.54, 0.4, 0.1)
	SetFont(WorldMapTextFont, NORMAL, 31, "THICKOUTLINE", nil, nil, nil, 0, 0, 0, 1, -1)

	-- Channel list
	for i = 1, MAX_CHANNEL_BUTTONS do
		local f = _G["ChannelButton"..i.."Text"]
		f:SetFontObject(GameFontNormalSmall)
	end

	-- Player title
	for i = 1, PlayerTitleDropDown.titleCount do info.text:SetFontObject(GameFontHighlightSmall) end
end)

-- Registering fonts in LibSharedMedia
local LSM = LibStub and LibStub:GetLibrary("LibSharedMedia-3.0", true)
local LOCALE_MASK = 0
if GetLocale() == "koKR" then
	LOCALE_MASK = 1
elseif GetLocale() == "ruRU" then
	LOCALE_MASK = 2
elseif GetLocale() == "zhCN" then
	LOCALE_MASK = 4
elseif GetLocale() == "zhTW" then
	LOCALE_MASK = 8
else
	LOCALE_MASK = 128
end

if LSM then
	LSM:Register(LSM.MediaType.FONT, "Calibri", C.media.normal_font, LOCALE_MASK)
	LSM:Register(LSM.MediaType.FONT, "Hooge", C.media.pixel_font, LOCALE_MASK)
	LSM:Register(LSM.MediaType.STATUSBAR, "Smooth", C.media.texture)
end