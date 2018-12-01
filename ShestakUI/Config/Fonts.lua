local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	ShestakUI fonts configuration file
--	BACKUP THIS FILE BEFORE UPDATING!
----------------------------------------------------------------------------------------
--	Configuration example:
----------------------------------------------------------------------------------------
-- C["font"] = {
--		-- Stats font
--		["stats_font"] = "Interface\\AddOns\\ShestakUI\\Media\\Fonts\\Normal.ttf",
-- 		["stats_font_size"] = 11,
--		["stats_font_style"] = "",
--		["stats_font_shadow"] = true,
-- }
----------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------
--	Fonts options
----------------------------------------------------------------------------------------
local UIFont, UIFontSize, UIFontStyle = C.media.pixel_font, 8, "OUTLINEMONOCHROME"
if C.general.normal_font then
	UIFont = C.media.normal_font
	UIFontSize = 11
	UIFontStyle = "THINOUTLINE"
end

C["font"] = {
	-- Stats font
	["stats_font"] = UIFont,
	["stats_font_size"] = UIFontSize,
	["stats_font_style"] = UIFontStyle,
	["stats_font_shadow"] = false,

	-- Combat text font
	["combat_text_font"] = UIFont,
	["combat_text_font_size"] = 16,
	["combat_text_font_style"] = UIFontStyle,
	["combat_text_font_shadow"] = false,

	-- Chat font
	["chat_font"] = C.media.normal_font,
	["chat_font_style"] = "",
	["chat_font_shadow"] = true,

	-- Chat tabs font
	["chat_tabs_font"] = UIFont,
	["chat_tabs_font_size"] = UIFontSize,
	["chat_tabs_font_style"] = UIFontStyle,
	["chat_tabs_font_shadow"] = false,

	-- Action bars font
	["action_bars_font"] = UIFont,
	["action_bars_font_size"] = UIFontSize,
	["action_bars_font_style"] = UIFontStyle,
	["action_bars_font_shadow"] = false,

	-- Threat meter font
	["threat_meter_font"] = UIFont,
	["threat_meter_font_size"] = UIFontSize,
	["threat_meter_font_style"] = UIFontStyle,
	["threat_meter_font_shadow"] = false,

	-- Raid cooldowns font
	["raid_cooldowns_font"] = UIFont,
	["raid_cooldowns_font_size"] = UIFontSize,
	["raid_cooldowns_font_style"] = UIFontStyle,
	["raid_cooldowns_font_shadow"] = false,

	-- Cooldowns timer font
	["cooldown_timers_font"] = UIFont,
	["cooldown_timers_font_size"] = 16,
	["cooldown_timers_font_style"] = UIFontStyle,
	["cooldown_timers_font_shadow"] = false,

	-- Loot font
	["loot_font"] = UIFont,
	["loot_font_size"] = UIFontSize,
	["loot_font_style"] = UIFontStyle,
	["loot_font_shadow"] = false,

	-- Nameplates font
	["nameplates_font"] = UIFont,
	["nameplates_font_size"] = UIFontSize,
	["nameplates_font_style"] = UIFontStyle,
	["nameplates_font_shadow"] = false,

	-- Unit frames font
	["unit_frames_font"] = UIFont,
	["unit_frames_font_size"] = C.general.normal_font and UIFontSize + 1 or UIFontSize,
	["unit_frames_font_style"] = UIFontStyle,
	["unit_frames_font_shadow"] = false,

	-- Auras font
	["auras_font"] = UIFont,
	["auras_font_size"] = UIFontSize,
	["auras_font_style"] = UIFontStyle,
	["auras_font_shadow"] = false,

	-- Filger font
	["filger_font"] = UIFont,
	["filger_font_size"] = UIFontSize,
	["filger_font_style"] = UIFontStyle,
	["filger_font_shadow"] = false,

	-- Stylization font
	["stylization_font"] = C.media.pixel_font,
	["stylization_font_size"] = 8,
	["stylization_font_style"] = UIFontStyle,
	["stylization_font_shadow"] = false,

	-- Bags font
	["bags_font"] = UIFont,
	["bags_font_size"] = UIFontSize,
	["bags_font_style"] = UIFontStyle,
	["bags_font_shadow"] = false,
}

----------------------------------------------------------------------------------------
--	Font replace for zhTW and zhCN client
----------------------------------------------------------------------------------------
if T.client == "zhTW" then
	C["media"].normal_font = "Fonts\\bLEI00D.ttf"
	C["media"].pixel_font = "Fonts\\bLEI00D.ttf"
	C["media"].pixel_font_style = "OUTLINE"
	C["media"].pixel_font_size = 11

	C["font"].stats_font = "Fonts\\bLEI00D.ttf"
	C["font"].stats_font_size = 12
	C["font"].stats_font_style = "OUTLINE"
	C["font"].stats_font_shadow = true

	C["font"].combat_text_font = "Fonts\\bLEI00D.ttf"
	C["font"].combat_text_font_size = 16
	C["font"].combat_text_font_style = "OUTLINE"
	C["font"].combat_text_font_shadow = true

	C["font"].chat_font = "Fonts\\bLEI00D.ttf"
	C["font"].chat_font_style = "OUTLINE"
	C["font"].chat_font_shadow = true

	C["font"].chat_tabs_font = "Fonts\\bLEI00D.ttf"
	C["font"].chat_tabs_font_size = 12
	C["font"].chat_tabs_font_style = "OUTLINE"
	C["font"].chat_tabs_font_shadow = true

	C["font"].action_bars_font = "Fonts\\bLEI00D.ttf"
	C["font"].action_bars_font_size = 12
	C["font"].action_bars_font_style = "OUTLINE"
	C["font"].action_bars_font_shadow = true

	C["font"].threat_meter_font = "Fonts\\bLEI00D.ttf"
	C["font"].threat_meter_font_size = 12
	C["font"].threat_meter_font_style = "OUTLINE"
	C["font"].threat_meter_font_shadow = true

	C["font"].raid_cooldowns_font = "Fonts\\bLEI00D.ttf"
	C["font"].raid_cooldowns_font_size = 12
	C["font"].raid_cooldowns_font_style = "OUTLINE"
	C["font"].raid_cooldowns_font_shadow = true

	C["font"].cooldown_timers_font = "Fonts\\bLEI00D.ttf"
	C["font"].cooldown_timers_font_size = 13
	C["font"].cooldown_timers_font_style = "OUTLINE"
	C["font"].cooldown_timers_font_shadow = true

	C["font"].loot_font = "Fonts\\bLEI00D.ttf"
	C["font"].loot_font_size = 13
	C["font"].loot_font_style = "OUTLINE"
	C["font"].loot_font_shadow = true

	C["font"].nameplates_font = "Fonts\\bLEI00D.ttf"
	C["font"].nameplates_font_size = 13
	C["font"].nameplates_font_style = "OUTLINE"
	C["font"].nameplates_font_shadow = true

	C["font"].unit_frames_font = "Fonts\\bLEI00D.ttf"
	C["font"].unit_frames_font_size = 12
	C["font"].unit_frames_font_style = "OUTLINE"
	C["font"].unit_frames_font_shadow = true

	C["font"].auras_font = "Fonts\\bLEI00D.ttf"
	C["font"].auras_font_size = 11
	C["font"].auras_font_style = "OUTLINE"
	C["font"].auras_font_shadow = true

	C["font"].filger_font = "Fonts\\bLEI00D.ttf"
	C["font"].filger_font_size = 14
	C["font"].filger_font_style = "OUTLINE"
	C["font"].filger_font_shadow = true

	C["font"].stylization_font = "Fonts\\bLEI00D.ttf"
	C["font"].stylization_font_size = 12
	C["font"].stylization_font_style = ""
	C["font"].stylization_font_shadow = true

	C["font"].bags_font = "Fonts\\bLEI00D.ttf"
	C["font"].bags_font_size = 11
	C["font"].bags_font_style = "OUTLINE"
	C["font"].bags_font_shadow = true
elseif T.client == "zhCN" then
	C["media"].normal_font = "Fonts\\ARKai_T.ttf"
	C["media"].pixel_font = "Fonts\\ARKai_C.ttf"
	C["media"].pixel_font_style = "OUTLINE"
	C["media"].pixel_font_size = 11

	C["font"].stats_font = "Fonts\\ARKai_T.ttf"
	C["font"].stats_font_size = 12
	C["font"].stats_font_style = "OUTLINE"
	C["font"].stats_font_shadow = true

	C["font"].combat_text_font = "Fonts\\ARKai_T.ttf"
	C["font"].combat_text_font_size = 16
	C["font"].combat_text_font_style = "OUTLINE"
	C["font"].combat_text_font_shadow = true

	C["font"].chat_font = "Fonts\\ARKai_T.ttf"
	C["font"].chat_font_style = "OUTLINE"
	C["font"].chat_font_shadow = true

	C["font"].chat_tabs_font = "Fonts\\ARKai_T.ttf"
	C["font"].chat_tabs_font_size = 12
	C["font"].chat_tabs_font_style = "OUTLINE"
	C["font"].chat_tabs_font_shadow = true

	C["font"].action_bars_font = "Fonts\\ARKai_T.ttf"
	C["font"].action_bars_font_size = 12
	C["font"].action_bars_font_style = "OUTLINE"
	C["font"].action_bars_font_shadow = true

	C["font"].threat_meter_font = "Fonts\\ARKai_T.ttf"
	C["font"].threat_meter_font_size = 12
	C["font"].threat_meter_font_style = "OUTLINE"
	C["font"].threat_meter_font_shadow = true

	C["font"].raid_cooldowns_font = "Fonts\\ARKai_T.ttf"
	C["font"].raid_cooldowns_font_size = 12
	C["font"].raid_cooldowns_font_style = "OUTLINE"
	C["font"].raid_cooldowns_font_shadow = true

	C["font"].cooldown_timers_font = "Fonts\\ARKai_T.ttf"
	C["font"].cooldown_timers_font_size = 13
	C["font"].cooldown_timers_font_style = "OUTLINE"
	C["font"].cooldown_timers_font_shadow = true

	C["font"].loot_font = "Fonts\\ARKai_T.ttf"
	C["font"].loot_font_size = 13
	C["font"].loot_font_style = "OUTLINE"
	C["font"].loot_font_shadow = true

	C["font"].nameplates_font = "Fonts\\ARKai_T.ttf"
	C["font"].nameplates_font_size = 13
	C["font"].nameplates_font_style = "OUTLINE"
	C["font"].nameplates_font_shadow = true

	C["font"].unit_frames_font = "Fonts\\ARKai_T.ttf"
	C["font"].unit_frames_font_size = 12
	C["font"].unit_frames_font_style = "OUTLINE"
	C["font"].unit_frames_font_shadow = true

	C["font"].auras_font = "Fonts\\ARKai_T.ttf"
	C["font"].auras_font_size = 11
	C["font"].auras_font_style = "OUTLINE"
	C["font"].auras_font_shadow = true

	C["font"].filger_font = "Fonts\\ARKai_T.ttf"
	C["font"].filger_font_size = 14
	C["font"].filger_font_style = "OUTLINE"
	C["font"].filger_font_shadow = true

	C["font"].stylization_font = "Fonts\\ARKai_T.ttf"
	C["font"].stylization_font_size = 12
	C["font"].stylization_font_style = ""
	C["font"].stylization_font_shadow = true

	C["font"].bags_font = "Fonts\\ARKai_T.ttf"
	C["font"].bags_font_size = 11
	C["font"].bags_font_style = "OUTLINE"
	C["font"].bags_font_shadow = true
end