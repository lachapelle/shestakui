----------------------------------------------------------------------------------------
--	GUI for ShestakUI(by Fernir, Tukz and Tohveli)
----------------------------------------------------------------------------------------
local realm = GetRealmName()
local name = UnitName("player")
local GlobalHeight = 545

local ALLOWED_GROUPS = {
	["general"] = 1,
	["misc"] = 2,
	["announcements"] = 3,
	["automation"] = 4,
	["skins"] = 5,
	["combattext"] = 6,
	["reminder"] = 7,
	["raidcooldown"] = 8,
	["enemycooldown"] = 9,
	["pulsecooldown"] = 10,
	["threat"] = 11,
	["tooltip"] = 12,
	["chat"] = 13,
	["bag"] = 14,
	["minimap"] = 15,
	["map"] = 16,
	["loot"] = 17,
	["nameplate"] = 18,
	["actionbar"] = 19,
	["aura"] = 20,
	["filger"] = 21,
	["unitframe"] = 22,
	["unitframe_class_bar"] = 23,
	["raidframe"] = 24,
	["toppanel"] = 25,
	["stats"] = 26,
	["error"] = 27,
}

local function Local(o)
	local T, C, L, _ = unpack(ShestakUI)
	-- General options
	if o == "UIConfig_general" then o = L_COMPATIBILITY_GENERAL_LABEL end
	if o == "UIConfig_generalauto_scale" then o = L_GUI_GENERAL_AUTOSCALE end
	if o == "UIConfig_generalnormal_font" then o = L_GUI_GENERAL_NORMALFONT end
	if o == "UIConfig_generaluiscale" then o = L_GUI_GENERAL_UISCALE end
	if o == "UIConfig_generalwelcome_message" then o = L_GUI_GENERAL_WELCOME_MESSAGE end

	-- Miscellaneous options
	if o == "UIConfig_misc" then o = OTHER end
	if o == "UIConfig_miscshift_marking" then o = L_GUI_MISC_MARKING end
	if o == "UIConfig_miscinvite_keyword" then o = L_GUI_MISC_INVKEYWORD end
	if o == "UIConfig_miscafk_spin_camera" then o = L_GUI_MISC_SPIN_CAMERA end
	if o == "UIConfig_miscquest_auto_button" then o = L_GUI_MISC_QUEST_AUTOBUTTON end
	if o == "UIConfig_miscraid_tools" then o = L_GUI_MISC_RAID_TOOLS end
	if o == "UIConfig_miscprofession_tabs" then o = L_GUI_MISC_PROFESSION_TABS end
	if o == "UIConfig_mischide_bg_spam" then o = L_GUI_MISC_HIDE_BG_SPAM end
	if o == "UIConfig_miscitem_level" then o = L_GUI_MISC_ITEM_LEVEL end
	if o == "UIConfig_miscalready_known" then o = L_GUI_MISC_ALREADY_KNOWN end
	if o == "UIConfig_miscdisenchanting" then o = L_GUI_MISC_DISENCHANTING end
	if o == "UIConfig_miscsum_buyouts" then o = L_GUI_MISC_SUM_BUYOUTS end
	if o == "UIConfig_miscclick_cast" then o = L_GUI_MISC_CLICK_CAST end
	if o == "UIConfig_miscclick_cast_filter" then o = L_GUI_MISC_CLICK_CAST_FILTER end
	if o == "UIConfig_miscmove_blizzard" then o = L_GUI_MISC_MOVE_BLIZZARD end
	if o == "UIConfig_misccolor_picker" then o = L_GUI_MISC_COLOR_PICKER end
	if o == "UIConfig_miscchars_currency" then o = L_GUI_MISC_CHARS_CURRENCY end
	if o == "UIConfig_miscmerchant_itemlevel" then o = L_GUI_MISC_MERCHANT_ITEMLEVEL end
	if o == "UIConfig_miscminimize_mouseover" then o = L_GUI_MISC_MINIMIZE_MOUSEOVER end

	-- Announcements options
	if o == "UIConfig_announcements" then o = L_GUI_ANNOUNCEMENTS end
	if o == "UIConfig_announcementsdrinking" then o = L_GUI_ANNOUNCEMENTS_DRINKING end
	if o == "UIConfig_announcementsinterrupts" then o = L_GUI_ANNOUNCEMENTS_INTERRUPTS end
	if o == "UIConfig_announcementsspells" then o = L_GUI_ANNOUNCEMENTS_SPELLS end
	if o == "UIConfig_announcementsspells_from_all" then o = L_GUI_ANNOUNCEMENTS_SPELLS_FROM_ALL end
	if o == "UIConfig_announcementstoys" then o = L_GUI_ANNOUNCEMENTS_TOY_TRAIN end
	if o == "UIConfig_announcementssays_thanks" then o = L_GUI_ANNOUNCEMENTS_SAYS_THANKS end
	if o == "UIConfig_announcementspull_countdown" then o = L_GUI_ANNOUNCEMENTS_PULL_COUNTDOWN end
	if o == "UIConfig_announcementsflask_food" then o = L_GUI_ANNOUNCEMENTS_FLASK_FOOD end
	if o == "UIConfig_announcementsflask_food_auto" then o = L_GUI_ANNOUNCEMENTS_FLASK_FOOD_AUTO end
	if o == "UIConfig_announcementsflask_food_raid" then o = L_GUI_ANNOUNCEMENTS_FLASK_FOOD_RAID end
	if o == "UIConfig_announcementsfeasts" then o = L_GUI_ANNOUNCEMENTS_FEASTS end
	if o == "UIConfig_announcementsportals" then o = L_GUI_ANNOUNCEMENTS_PORTALS end
	if o == "UIConfig_announcementsbad_gear" then o = L_GUI_ANNOUNCEMENTS_BAD_GEAR end

	-- Automation options
	if o == "UIConfig_automation" then o = L_GUI_AUTOMATION end
	if o == "UIConfig_automationrelease" then o = L_GUI_AUTOMATION_RELEASE end
	if o == "UIConfig_automationaccept_invite" then o = L_GUI_AUTOMATION_ACCEPT_INVITE end
	if o == "UIConfig_automationdecline_duel" then o = L_GUI_AUTOMATION_DECLINE_DUEL end
	if o == "UIConfig_automationaccept_quest" then o = L_GUI_AUTOMATION_ACCEPT_QUEST end
	if o == "UIConfig_automationauto_collapse" then o = L_GUI_AUTOMATION_AUTO_COLLAPSE end
	if o == "UIConfig_automationauto_collapse_reload" then o = L_GUI_AUTOMATION_AUTO_COLLAPSE_RELOAD end
	if o == "UIConfig_automationcancel_bad_buffs" then o = L_GUI_AUTOMATION_CANCEL_BAD_BUFFS end
	if o == "UIConfig_automationtab_binder" then o = L_GUI_AUTOMATION_TAB_BINDER end
	if o == "UIConfig_automationlogging_combat" then o = L_GUI_AUTOMATION_LOGGING_COMBAT end
	if o == "UIConfig_automationcurrency_cap" then o = L_GUI_AUTOMATION_CURRENCY_CAP end
	if o == "UIConfig_automationbuff_on_scroll" then o = L_GUI_AUTOMATION_BUFF_ON_SCROLL end
	if o == "UIConfig_automationopen_items" then o = L_GUI_AUTOMATION_OPEN_ITEMS end

	-- Skins options
	if o == "UIConfig_skins" then o = L_GUI_SKINS end
	if o == "UIConfig_skinsblizzard_frames" then o = L_GUI_SKINS_BLIZZARD end
	if o == "UIConfig_skinsminimap_buttons" then o = L_GUI_SKINS_MINIMAP_BUTTONS end
	if o == "UIConfig_skinsbigwigs" then o = L_GUI_SKINS_BW end
	if o == "UIConfig_skinsdbm" then o = L_GUI_SKINS_DBM end
	if o == "UIConfig_skinsdbm_movable" then o = L_GUI_SKINS_DBM_MOVABLE end
	if o == "UIConfig_skinsdxe" then o = L_GUI_SKINS_DXE end
	if o == "UIConfig_skinsomen" then o = L_GUI_SKINS_OMEN end
	if o == "UIConfig_skinsrecount" then o = L_GUI_SKINS_RECOUNT end
	if o == "UIConfig_skinsdominos" then o = L_GUI_SKINS_DOMINOS end
	if o == "UIConfig_skinsnug_running" then o = L_GUI_SKINS_NUG_RUNNING end
	if o == "UIConfig_skinsovale" then o = L_GUI_SKINS_OVALE end
	if o == "UIConfig_skinsclique" then o = L_GUI_SKINS_CLIQUE end
	if o == "UIConfig_skinsace3" then o = L_GUI_SKINS_ACE3 end
	if o == "UIConfig_skinscapping" then o = L_GUI_SKINS_CAPPING end
	if o == "UIConfig_skinscool_line" then o = L_GUI_SKINS_COOL_LINE end
	if o == "UIConfig_skinsatlasloot" then o = L_GUI_SKINS_ATLASLOOT end
	if o == "UIConfig_skinstiny_dps" then o = L_GUI_SKINS_TINY_DPS end
	if o == "UIConfig_skinsnpcscan" then o = L_GUI_SKINS_NPCSCAN end
	if o == "UIConfig_skinsvanaskos" then o = L_GUI_SKINS_VANASKOS end
	if o == "UIConfig_skinsweak_auras" then o = L_GUI_SKINS_WEAK_AURAS end
	if o == "UIConfig_skinsskada" then o = L_GUI_SKINS_SKADA end
	if o == "UIConfig_skinspostal" then o = L_GUI_SKINS_POSTAL end
	if o == "UIConfig_skinsopie" then o = L_GUI_SKINS_OPIE end

	-- Combat text options
	if o == "UIConfig_combattext" then o = L_GUI_COMBATTEXT end
	if o == "UIConfig_combattextenable" then o = L_GUI_COMBATTEXT_ENABLE end
	if o == "UIConfig_combattextblizz_head_numbers" then o = L_GUI_COMBATTEXT_BLIZZ_HEAD_NUMBERS end
	if o == "UIConfig_combattextdamage_style" then o = L_GUI_COMBATTEXT_DAMAGE_STYLE end
	if o == "UIConfig_combattextdamage" then o = L_GUI_COMBATTEXT_DAMAGE end
	if o == "UIConfig_combattexthealing" then o = L_GUI_COMBATTEXT_HEALING end
	if o == "UIConfig_combattextshow_hots" then o = L_GUI_COMBATTEXT_HOTS end
	if o == "UIConfig_combattextshow_overhealing" then o = L_GUI_COMBATTEXT_OVERHEALING end
	if o == "UIConfig_combattextpet_damage" then o = L_GUI_COMBATTEXT_PET_DAMAGE end
	if o == "UIConfig_combattextdot_damage" then o = L_GUI_COMBATTEXT_DOT_DAMAGE end
	if o == "UIConfig_combattextdamage_color" then o = L_GUI_COMBATTEXT_DAMAGE_COLOR end
	if o == "UIConfig_combattextcrit_prefix" then o = L_GUI_COMBATTEXT_CRIT_PREFIX end
	if o == "UIConfig_combattextcrit_postfix" then o = L_GUI_COMBATTEXT_CRIT_POSTFIX end
	if o == "UIConfig_combattexticons" then o = L_GUI_COMBATTEXT_ICONS end
	if o == "UIConfig_combattexticon_size" then o = L_GUI_COMBATTEXT_ICON_SIZE end
	if o == "UIConfig_combattextthreshold" then o = L_GUI_COMBATTEXT_THRESHOLD end
	if o == "UIConfig_combattextheal_threshold" then o = L_GUI_COMBATTEXT_HEAL_THRESHOLD end
	if o == "UIConfig_combattextscrollable" then o = L_GUI_COMBATTEXT_SCROLLABLE end
	if o == "UIConfig_combattextmax_lines" then o = L_GUI_COMBATTEXT_MAX_LINES end
	if o == "UIConfig_combattexttime_visible" then o = L_GUI_COMBATTEXT_TIME_VISIBLE end
	if o == "UIConfig_combattextdk_runes" then o = L_GUI_COMBATTEXT_DK_RUNES end
	if o == "UIConfig_combattextkillingblow" then o = L_GUI_COMBATTEXT_KILLINGBLOW end
	if o == "UIConfig_combattextmerge_aoe_spam" then o = L_GUI_COMBATTEXT_MERGE_AOE_SPAM end
	if o == "UIConfig_combattextmerge_melee" then o = L_GUI_COMBATTEXT_MERGE_MELEE end
	if o == "UIConfig_combattextdispel" then o = L_GUI_COMBATTEXT_DISPEL end
	if o == "UIConfig_combattextinterrupt" then o = L_GUI_COMBATTEXT_INTERRUPT end
	if o == "UIConfig_combattextdirection" then o = L_GUI_COMBATTEXT_DIRECTION end
	if o == "UIConfig_combattextshort_numbers" then o = L_GUI_COMBATTEXT_SHORT_NUMBERS end

	-- Buffs reminder options
	if o == "UIConfig_reminder" then o = L_GUI_REMINDER end
	if o == "UIConfig_remindersolo_buffs_enable" then o = L_GUI_REMINDER_SOLO_ENABLE end
	if o == "UIConfig_remindersolo_buffs_sound" then o = L_GUI_REMINDER_SOLO_SOUND end
	if o == "UIConfig_remindersolo_buffs_size" then o = L_GUI_REMINDER_SOLO_SIZE end
	if o == "UIConfig_reminderraid_buffs_enable" then o = L_GUI_REMINDER_RAID_ENABLE end
	if o == "UIConfig_reminderraid_buffs_always" then o = L_GUI_REMINDER_RAID_ALWAYS end
	if o == "UIConfig_reminderraid_buffs_size" then o = L_GUI_REMINDER_RAID_SIZE end
	if o == "UIConfig_reminderraid_buffs_alpha" then o = L_GUI_REMINDER_RAID_ALPHA end

	-- Raid cooldowns options
	if o == "UIConfig_raidcooldown" then o = L_GUI_COOLDOWN_RAID end
	if o == "UIConfig_raidcooldownenable" then o = L_GUI_COOLDOWN_RAID_ENABLE end
	if o == "UIConfig_raidcooldownheight" then o = L_GUI_COOLDOWN_RAID_HEIGHT end
	if o == "UIConfig_raidcooldownwidth" then o = L_GUI_COOLDOWN_RAID_WIDTH end
	if o == "UIConfig_raidcooldownupwards" then o = L_GUI_COOLDOWN_RAID_SORT end
	if o == "UIConfig_raidcooldownexpiration" then o = L_GUI_COOLDOWN_RAID_EXPIRATION end
	if o == "UIConfig_raidcooldownshow_self" then o = L_GUI_COOLDOWN_RAID_SHOW_SELF end
	if o == "UIConfig_raidcooldownshow_icon" then o = L_GUI_COOLDOWN_RAID_ICONS end
	if o == "UIConfig_raidcooldownshow_inraid" then o = L_GUI_COOLDOWN_RAID_IN_RAID end
	if o == "UIConfig_raidcooldownshow_inparty" then o = L_GUI_COOLDOWN_RAID_IN_PARTY end
	if o == "UIConfig_raidcooldownshow_inarena" then o = L_GUI_COOLDOWN_RAID_IN_ARENA end

	-- Enemy cooldowns options
	if o == "UIConfig_enemycooldown" then o = L_GUI_COOLDOWN_ENEMY end
	if o == "UIConfig_enemycooldownenable" then o = L_GUI_COOLDOWN_ENEMY_ENABLE end
	if o == "UIConfig_enemycooldownsize" then o = L_GUI_COOLDOWN_ENEMY_SIZE end
	if o == "UIConfig_enemycooldowndirection" then o = L_GUI_COOLDOWN_ENEMY_DIRECTION end
	if o == "UIConfig_enemycooldownshow_always" then o = L_GUI_COOLDOWN_ENEMY_EVERYWHERE end
	if o == "UIConfig_enemycooldownshow_inpvp" then o = L_GUI_COOLDOWN_ENEMY_IN_BG end
	if o == "UIConfig_enemycooldownshow_inarena" then o = L_GUI_COOLDOWN_ENEMY_IN_ARENA end

	-- Pulse cooldown options
	if o == "UIConfig_pulsecooldown" then o = L_GUI_COOLDOWN_PULSE end
	if o == "UIConfig_pulsecooldownenable" then o = L_GUI_COOLDOWN_PULSE_ENABLE end
	if o == "UIConfig_pulsecooldownsize" then o = L_GUI_COOLDOWN_PULSE_SIZE end
	if o == "UIConfig_pulsecooldownsound" then o = L_GUI_COOLDOWN_PULSE_SOUND end
	if o == "UIConfig_pulsecooldownanim_scale" then o = L_GUI_COOLDOWN_PULSE_ANIM_SCALE end
	if o == "UIConfig_pulsecooldownhold_time" then o = L_GUI_COOLDOWN_PULSE_HOLD_TIME end
	if o == "UIConfig_pulsecooldownthreshold" then o = L_GUI_COOLDOWN_PULSE_THRESHOLD end

	-- Threat options
	if o == "UIConfig_threat" then o = L_GUI_THREAT end
	if o == "UIConfig_threatenable" then o = L_GUI_THREAT_ENABLE end
	if o == "UIConfig_threatheight" then o = L_GUI_THREAT_HEIGHT end
	if o == "UIConfig_threatwidth" then o = L_GUI_THREAT_WIDTH end
	if o == "UIConfig_threatbar_rows" then o = L_GUI_THREAT_ROWS end
	if o == "UIConfig_threathide_solo" then o = L_GUI_THREAT_HIDE_SOLO end

	-- Tooltip options
	if o == "UIConfig_tooltip" then o = L_GUI_TOOLTIP end
	if o == "UIConfig_tooltipenable" then o = L_GUI_TOOLTIP_ENABLE end
	if o == "UIConfig_tooltipshift_modifer" then o = L_GUI_TOOLTIP_SHIFT end
	if o == "UIConfig_tooltipcursor" then o = L_GUI_TOOLTIP_CURSOR end
	if o == "UIConfig_tooltipitem_icon" then o = L_GUI_TOOLTIP_ICON end
	if o == "UIConfig_tooltiphealth_value" then o = L_GUI_TOOLTIP_HEALTH end
	if o == "UIConfig_tooltiphidebuttons" then o = L_GUI_TOOLTIP_HIDE end
	if o == "UIConfig_tooltiphide_combat" then o = L_GUI_TOOLTIP_HIDE_COMBAT end
	if o == "UIConfig_tooltiptalents" then o = L_GUI_TOOLTIP_TALENTS end
	if o == "UIConfig_tooltiptarget" then o = L_GUI_TOOLTIP_TARGET end
	if o == "UIConfig_tooltiptitle" then o = L_GUI_TOOLTIP_TITLE end
	if o == "UIConfig_tooltiprealm" then o = L_GUI_TOOLTIP_REALM end
	if o == "UIConfig_tooltiprank" then o = L_GUI_TOOLTIP_RANK end
	if o == "UIConfig_tooltiparena_experience" then o = L_GUI_TOOLTIP_ARENA_EXPERIENCE end
	if o == "UIConfig_tooltipspell_id" then o = L_GUI_TOOLTIP_SPELL_ID end
	if o == "UIConfig_tooltipaverage_lvl" then o = L_COMPATIBILITY_STAT_AVERAGE_ITEM_LEVEL end
	if o == "UIConfig_tooltipraid_icon" then o = L_GUI_TOOLTIP_RAID_ICON end
	if o == "UIConfig_tooltipwho_targetting" then o = L_GUI_TOOLTIP_WHO_TARGETTING end
	if o == "UIConfig_tooltipitem_count" then o = L_GUI_TOOLTIP_ITEM_COUNT end
	if o == "UIConfig_tooltipunit_role" then o = L_GUI_TOOLTIP_UNIT_ROLE end

	-- Chat options
	if o == "UIConfig_chat" then o = SOCIALS end
	if o == "UIConfig_chatenable" then o = L_GUI_CHAT_ENABLE end
	if o == "UIConfig_chatbackground" then o = L_GUI_CHAT_BACKGROUND end
	if o == "UIConfig_chatbackground_alpha" then o = L_GUI_CHAT_BACKGROUND_ALPHA end
	if o == "UIConfig_chatfilter" then o = L_GUI_CHAT_SPAM end
	if o == "UIConfig_chatspam" then o = L_GUI_CHAT_GOLD end
	if o == "UIConfig_chatwidth" then o = L_GUI_CHAT_WIDTH end
	if o == "UIConfig_chatheight" then o = L_GUI_CHAT_HEIGHT end
	if o == "UIConfig_chatchat_bar" then o = L_GUI_CHAT_BAR end
	if o == "UIConfig_chatchat_bar_mouseover" then o = L_GUI_CHAT_BAR_MOUSEOVER end
	if o == "UIConfig_chattime" then o = L_GUI_CHAT_TIMESTAMP end
	if o == "UIConfig_chattime_24" then o = L_GUI_CHAT_TIMESTAMP_24 end
	if o == "UIConfig_chattime_seconds" then o = L_GUI_CHAT_TIMESTAMP_SECONDS end
	if o == "UIConfig_chattime_color" then o = L_GUI_CHAT_TIMESTAMP_COLOR end
	if o == "UIConfig_chatwhisp_sound" then o = L_GUI_CHAT_WHISP end
	if o == "UIConfig_chatbubbles" then o = L_GUI_CHAT_SKIN_BUBBLE end
	if o == "UIConfig_chatcombatlog" then o = L_GUI_CHAT_CL_TAB end
	if o == "UIConfig_chattabs_mouseover" then o = L_GUI_CHAT_TABS_MOUSEOVER end
	if o == "UIConfig_chatsticky" then o = L_GUI_CHAT_STICKY end
	if o == "UIConfig_chatdamage_meter_spam" then o = L_GUI_CHAT_DAMAGE_METER_SPAM end

	-- Bag options
	if o == "UIConfig_bag" then o = L_GUI_BAGS end
	if o == "UIConfig_bagenable" then o = L_GUI_BAGS_ENABLE end
	if o == "UIConfig_bagilvl" then o = L_GUI_BAGS_ILVL end
	if o == "UIConfig_bagbutton_size" then o = L_GUI_BAGS_BUTTON_SIZE end
	if o == "UIConfig_bagbutton_space" then o = L_GUI_BAGS_BUTTON_SPACE end
	if o == "UIConfig_bagbank_columns" then o = L_GUI_BAGS_BANK end
	if o == "UIConfig_bagbag_columns" then o = L_GUI_BAGS_BAG end

	-- Minimap options
	if o == "UIConfig_minimap" then o = MINIMAP_LABEL end
	if o == "UIConfig_minimapenable" then o = L_GUI_MINIMAP_ENABLE end
	if o == "UIConfig_minimaptracking_icon" then o = L_GUI_MINIMAP_ICON end
	if o == "UIConfig_minimapsize" then o = L_GUI_MINIMAP_SIZE end
	if o == "UIConfig_minimaphide_combat" then o = L_GUI_MINIMAP_HIDE_COMBAT end
	if o == "UIConfig_minimaptoggle_menu" then o = L_GUI_MINIMAP_TOGGLE_MENU end

	-- Map options
	if o == "UIConfig_map" then o = WORLD_MAP end
	if o == "UIConfig_mapbg_map_stylization" then o = L_GUI_MAP_BG_STYLIZATION end
	if o == "UIConfig_mapfog_of_war" then o = L_GUI_MAP_FOG_OF_WAR end

	-- Loot options
	if o == "UIConfig_loot" then o = LOOT end
	if o == "UIConfig_lootlootframe" then o = L_GUI_LOOT_ENABLE end
	if o == "UIConfig_lootrolllootframe" then o = L_GUI_LOOT_ROLL_ENABLE end
	if o == "UIConfig_looticon_size" then o = L_GUI_LOOT_ICON_SIZE end
	if o == "UIConfig_lootwidth" then o = L_GUI_LOOT_WIDTH end
	if o == "UIConfig_lootauto_greed" then o = L_GUI_LOOT_AUTOGREED end
	if o == "UIConfig_lootauto_confirm_de" then o = L_GUI_LOOT_AUTODE end

	-- Nameplate options
	if o == "UIConfig_nameplate" then o = L_COMPATIBILITY_UNIT_NAMEPLATES end
	if o == "UIConfig_nameplateenable" then o = L_GUI_NAMEPLATE_ENABLE end
	if o == "UIConfig_nameplateheight" then o = L_GUI_NAMEPLATE_HEIGHT end
	if o == "UIConfig_nameplatewidth" then o = L_GUI_NAMEPLATE_WIDTH end
	if o == "UIConfig_nameplatead_height" then o = L_GUI_NAMEPLATE_AD_HEIGHT end
	if o == "UIConfig_nameplatead_width" then o = L_GUI_NAMEPLATE_AD_WIDTH end
	if o == "UIConfig_nameplatecombat" then o = L_GUI_NAMEPLATE_COMBAT end
	if o == "UIConfig_nameplatehealth_value" then o = L_GUI_NAMEPLATE_HEALTH end
	if o == "UIConfig_nameplateshow_castbar" then o = L_GUI_NAMEPLATE_CASTBAR end
	if o == "UIConfig_nameplateshow_castbar_name" then o = L_GUI_NAMEPLATE_CASTBAR_NAME end
	if o == "UIConfig_nameplateenhance_threat" then o = L_GUI_NAMEPLATE_THREAT end
	if o == "UIConfig_nameplateclass_icons" then o = L_GUI_NAMEPLATE_CLASS_ICON end
	if o == "UIConfig_nameplatename_abbrev" then o = L_GUI_NAMEPLATE_NAME_ABBREV end
	if o == "UIConfig_nameplategood_color" then o = L_GUI_NAMEPLATE_GOOD_COLOR end
	if o == "UIConfig_nameplatenear_color" then o = L_GUI_NAMEPLATE_NEAR_COLOR end
	if o == "UIConfig_nameplatebad_color" then o = L_GUI_NAMEPLATE_BAD_COLOR end
	if o == "UIConfig_nameplateofftank_color" then o = L_GUI_NAMEPLATE_OFFTANK_COLOR end
	if o == "UIConfig_nameplatetrack_auras" then o = L_GUI_NAMEPLATE_SHOW_DEBUFFS end
	if o == "UIConfig_nameplatetrack_buffs" then o = L_GUI_NAMEPLATE_SHOW_BUFFS end
	if o == "UIConfig_nameplateauras_size" then o = L_GUI_NAMEPLATE_DEBUFFS_SIZE end
	if o == "UIConfig_nameplatehealer_icon" then o = L_GUI_NAMEPLATE_HEALER_ICON end
	if o == "UIConfig_nameplatetotem_icons" then o = L_GUI_NAMEPLATE_TOTEM_ICONS end

	-- ActionBar options
	if o == "UIConfig_actionbar" then o = ACTIONBAR_LABEL end
	if o == "UIConfig_actionbarenable" then o = L_GUI_ACTIONBAR_ENABLE end
	if o == "UIConfig_actionbarhotkey" then o = L_GUI_ACTIONBAR_HOTKEY end
	if o == "UIConfig_actionbarmacro" then o = L_GUI_ACTIONBAR_MACRO end
	if o == "UIConfig_actionbarshow_grid" then o = L_GUI_ACTIONBAR_GRID end
	if o == "UIConfig_actionbarbutton_size" then o = L_GUI_ACTIONBAR_BUTTON_SIZE end
	if o == "UIConfig_actionbarbutton_space" then o = L_GUI_ACTIONBAR_BUTTON_SPACE end
	if o == "UIConfig_actionbarsplit_bars" then o = L_GUI_ACTIONBAR_SPLIT_BARS end
	if o == "UIConfig_actionbarclasscolor_border" then o = L_GUI_ACTIONBAR_CLASSCOLOR_BORDER end
	if o == "UIConfig_actionbartoggle_mode" then o = L_GUI_ACTIONBAR_TOGGLE_MODE end
	if o == "UIConfig_actionbarbottombars" then o = L_GUI_ACTIONBAR_BOTTOMBARS end
	if o == "UIConfig_actionbarrightbars" then o = L_GUI_ACTIONBAR_RIGHTBARS end
	if o == "UIConfig_actionbarrightbars_mouseover" then o = L_GUI_ACTIONBAR_RIGHTBARS_MOUSEOVER end
	if o == "UIConfig_actionbarpetbar_hide" then o = L_GUI_ACTIONBAR_PETBAR_HIDE end
	if o == "UIConfig_actionbarpetbar_horizontal" then o = L_GUI_ACTIONBAR_PETBAR_HORIZONTAL end
	if o == "UIConfig_actionbarpetbar_mouseover" then o = L_GUI_ACTIONBAR_PETBAR_MOUSEOVER end
	if o == "UIConfig_actionbarstancebar_hide" then o = L_GUI_ACTIONBAR_STANCEBAR_HIDE end
	if o == "UIConfig_actionbarstancebar_horizontal" then o = L_GUI_ACTIONBAR_STANCEBAR_HORIZONTAL end
	if o == "UIConfig_actionbarstancebar_mouseover" then o = L_GUI_ACTIONBAR_STANCEBAR_MOUSEOVER end
	if o == "UIConfig_actionbarmicromenu" then o = L_GUI_ACTIONBAR_MICROMENU end
	if o == "UIConfig_actionbarmicromenu_mouseover" then o = L_GUI_ACTIONBAR_MICROMENU_MOUSEOVER end

	-- Auras/Buffs/Debuffs
	if o == "UIConfig_aura" then o = L_COMPATIBILITY_BUFFOPTIONS_LABEL end
	if o == "UIConfig_auraplayer_buff_size" then o = L_GUI_AURA_PLAYER_BUFF_SIZE end
	if o == "UIConfig_aurashow_spiral" then o = L_GUI_AURA_SHOW_SPIRAL end
	if o == "UIConfig_aurashow_timer" then o = L_GUI_AURA_SHOW_TIMER end
	if o == "UIConfig_auraplayer_auras" then o = L_GUI_AURA_PLAYER_AURAS end
	if o == "UIConfig_auratarget_auras" then o = L_GUI_AURA_TARGET_AURAS end
	if o == "UIConfig_aurafocus_debuffs" then o = L_GUI_AURA_FOCUS_DEBUFFS end
	if o == "UIConfig_aurafot_debuffs" then o = L_GUI_AURA_FOT_DEBUFFS end
	if o == "UIConfig_aurapet_debuffs" then o = L_GUI_AURA_PET_DEBUFFS end
	if o == "UIConfig_auratot_debuffs" then o = L_GUI_AURA_TOT_DEBUFFS end
	if o == "UIConfig_auraboss_buffs" then o = L_GUI_AURA_BOSS_BUFFS end
	if o == "UIConfig_auraplayer_aura_only" then o = L_GUI_AURA_PLAYER_AURA_ONLY end
	if o == "UIConfig_auradebuff_color_type" then o = L_GUI_AURA_DEBUFF_COLOR_TYPE end
	if o == "UIConfig_auraclasscolor_border" then o = L_GUI_AURA_CLASSCOLOR_BORDER end

	-- Filger
	if o == "UIConfig_filger" then o = L_GUI_FILGER end
	if o == "UIConfig_filgerenable" then o = L_GUI_FILGER_ENABLE end
	if o == "UIConfig_filgertest_mode" then o = L_GUI_FILGER_TEST_MODE end
	if o == "UIConfig_filgermax_test_icon" then o = L_GUI_FILGER_MAX_TEST_ICON end
	if o == "UIConfig_filgershow_tooltip" then o = L_GUI_FILGER_SHOW_TOOLTIP end
	if o == "UIConfig_filgerdisable_cd" then o = L_GUI_FILGER_DISABLE_CD end
	if o == "UIConfig_filgerbuffs_size" then o = L_GUI_FILGER_BUFFS_SIZE end
	if o == "UIConfig_filgercooldown_size" then o = L_GUI_FILGER_COOLDOWN_SIZE end
	if o == "UIConfig_filgerpvp_size" then o = L_GUI_FILGER_PVP_SIZE end

	-- Unit Frames options
	if o == "UIConfig_unitframe" then o = L_COMPATIBILITY_UNITFRAME_LABEL end
	if o == "UIConfig_unitframeenable" then o = L_GUI_UF_ENABLE end
	if o == "UIConfig_unitframeown_color" then o = L_GUI_UF_OWN_COLOR end
	if o == "UIConfig_unitframeuf_color" then o = L_GUI_UF_UF_COLOR end
	if o == "UIConfig_unitframeenemy_health_color" then o = L_GUI_UF_ENEMY_HEALTH_COLOR end
	if o == "UIConfig_unitframeshow_total_value" then o = L_GUI_UF_TOTAL_VALUE end
	if o == "UIConfig_unitframecolor_value" then o = L_GUI_UF_COLOR_VALUE end
	if o == "UIConfig_unitframebar_color_value" then o = L_GUI_UF_BAR_COLOR_VALUE end
	if o == "UIConfig_unitframelines" then o = L_GUI_UF_LINES end
	if o == "UIConfig_unitframeunit_castbar" then o = L_GUI_UF_UNIT_CASTBAR end
	if o == "UIConfig_unitframecastbar_icon" then o = L_GUI_UF_CASTBAR_ICON end
	if o == "UIConfig_unitframecastbar_latency" then o = L_GUI_UF_CASTBAR_LATENCY end
	if o == "UIConfig_unitframecastbar_ticks" then o = L_GUI_UF_CASTBAR_TICKS end
	if o == "UIConfig_unitframeshow_pet" then o = L_GUI_UF_SHOW_PET end
	if o == "UIConfig_unitframeshow_focus" then o = L_GUI_UF_SHOW_FOCUS end
	if o == "UIConfig_unitframeshow_target_target" then o = L_GUI_UF_SHOW_TOT end
	if o == "UIConfig_unitframeshow_boss" then o = L_GUI_UF_SHOW_BOSS end
	if o == "UIConfig_unitframeboss_on_right" then o = L_GUI_UF_BOSS_RIGHT end
	if o == "UIConfig_unitframeshow_arena" then o = L_GUI_UF_SHOW_ARENA end
	if o == "UIConfig_unitframearena_on_right" then o = L_GUI_UF_ARENA_RIGHT end
	if o == "UIConfig_unitframeboss_debuffs" then o = L_GUI_UF_BOSS_DEBUFFS end
	if o == "UIConfig_unitframeboss_buffs" then o = L_GUI_UF_BOSS_BUFFS end
	if o == "UIConfig_unitframeicons_pvp" then o = L_GUI_UF_ICONS_PVP end
	if o == "UIConfig_unitframeicons_combat" then o = L_GUI_UF_ICONS_COMBAT end
	if o == "UIConfig_unitframeicons_resting" then o = L_GUI_UF_ICONS_RESTING end
	if o == "UIConfig_unitframeportrait_enable" then o = L_GUI_UF_PORTRAIT_ENABLE end
	if o == "UIConfig_unitframeportrait_classcolor_border" then o = L_GUI_UF_PORTRAIT_CLASSCOLOR_BORDER end
	if o == "UIConfig_unitframeportrait_height" then o = L_GUI_UF_PORTRAIT_HEIGHT end
	if o == "UIConfig_unitframeportrait_width" then o = L_GUI_UF_PORTRAIT_WIDTH end
	if o == "UIConfig_unitframeplugins_gcd" then o = L_GUI_UF_PLUGINS_GCD end
	if o == "UIConfig_unitframeplugins_swing" then o = L_GUI_UF_PLUGINS_SWING end
	if o == "UIConfig_unitframeplugins_reputation_bar" then o = L_GUI_UF_PLUGINS_REPUTATION_BAR end
	if o == "UIConfig_unitframeplugins_experience_bar" then o = L_GUI_UF_PLUGINS_EXPERIENCE_BAR end
	if o == "UIConfig_unitframeplugins_smooth_bar" then o = L_GUI_UF_PLUGINS_SMOOTH_BAR end
	if o == "UIConfig_unitframeplugins_enemy_spec" then o = L_GUI_UF_PLUGINS_ENEMY_SPEC end
	if o == "UIConfig_unitframeplugins_combat_feedback" then o = L_GUI_UF_PLUGINS_COMBAT_FEEDBACK end
	if o == "UIConfig_unitframeplugins_fader" then o = L_GUI_UF_PLUGINS_FADER end
	if o == "UIConfig_unitframeplugins_diminishing" then o = L_GUI_UF_PLUGINS_DIMINISHING end

	-- Unit Frames Class bar options
	if o == "UIConfig_unitframe_class_bar" then o = L_GUI_UF_PLUGINS_CLASS_BAR end
	if o == "UIConfig_unitframe_class_barcombo" then o = L_GUI_UF_PLUGINS_COMBO_BAR end
	if o == "UIConfig_unitframe_class_barcombo_always" then o = L_GUI_UF_PLUGINS_COMBO_BAR_ALWAYS end
	if o == "UIConfig_unitframe_class_barcombo_old" then o = L_GUI_UF_PLUGINS_COMBO_BAR_OLD end
	if o == "UIConfig_unitframe_class_bartotem" then o = L_GUI_UF_PLUGINS_TOTEM_BAR end

	-- Raid Frames options
	if o == "UIConfig_raidframe" then o = L_COMPATIBILITY_RAID_FRAMES_LABEL end
	if o == "UIConfig_raidframeby_role" then o = L_GUI_UF_BY_ROLE end
	if o == "UIConfig_raidframeaggro_border" then o = L_GUI_UF_AGGRO_BORDER end
	if o == "UIConfig_raidframedeficit_health" then o = L_GUI_UF_DEFICIT_HEALTH end
	if o == "UIConfig_raidframeshow_party" then o = L_GUI_UF_SHOW_PARTY end
	if o == "UIConfig_raidframeshow_raid" then o = L_GUI_UF_SHOW_RAID end
	if o == "UIConfig_raidframevertical_health" then o = L_GUI_UF_VERTICAL_HEALTH end
	if o == "UIConfig_raidframealpha_health" then o = L_GUI_UF_ALPHA_HEALTH end
	if o == "UIConfig_raidframeshow_range" then o = L_GUI_UF_SHOW_RANGE end
	if o == "UIConfig_raidframerange_alpha" then o = L_GUI_UF_RANGE_ALPHA end
	if o == "UIConfig_raidframesolo_mode" then o = L_GUI_UF_SOLO_MODE end
	if o == "UIConfig_raidframeplayer_in_party" then o = L_GUI_UF_PLAYER_PARTY end
	if o == "UIConfig_raidframeraid_tanks" then o = L_GUI_UF_SHOW_TANK end
	if o == "UIConfig_raidframeraid_tanks_tt" then o = L_GUI_UF_SHOW_TANK_TT end
	if o == "UIConfig_raidframeraid_groups" then o = L_GUI_UF_RAID_GROUP end
	if o == "UIConfig_raidframeraid_groups_vertical" then o = L_GUI_UF_RAID_VERTICAL_GROUP end
	if o == "UIConfig_raidframeicons_leader" then o = L_GUI_UF_ICONS_LEADER end
	if o == "UIConfig_raidframeicons_role" then o = L_GUI_UF_ICONS_ROLE end
	if o == "UIConfig_raidframeicons_raid_mark" then o = L_GUI_UF_ICONS_RAID_MARK end
	if o == "UIConfig_raidframeicons_ready_check" then o = L_GUI_UF_ICONS_READY_CHECK end
	if o == "UIConfig_raidframeplugins_debuffhighlight_icon" then o = L_GUI_UF_PLUGINS_DEBUFFHIGHLIGHT_ICON end
	if o == "UIConfig_raidframeplugins_aura_watch" then o = L_GUI_UF_PLUGINS_AURA_WATCH end
	if o == "UIConfig_raidframeplugins_aura_watch_timer" then o = L_GUI_UF_PLUGINS_AURA_WATCH_TIMER end
	if o == "UIConfig_raidframeplugins_pvp_debuffs" then o = L_GUI_UF_PLUGINS_PVP_DEBUFFS end
	if o == "UIConfig_raidframeplugins_healcomm" then o = L_GUI_UF_PLUGINS_HEALCOMM end
	if o == "UIConfig_raidframeplugins_auto_resurrection" then o = L_GUI_UF_PLUGINS_AUTO_RESURRECTION end

	-- Panel options
	if o == "UIConfig_toppanel" then o = L_GUI_TOP_PANEL end
	if o == "UIConfig_toppanelenable" then o = L_GUI_TOP_PANEL_ENABLE end
	if o == "UIConfig_toppanelmouseover" then o = L_GUI_TOP_PANEL_MOUSE end
	if o == "UIConfig_toppanelheight" then o = L_GUI_TOP_PANEL_HEIGHT end
	if o == "UIConfig_toppanelwidth" then o = L_GUI_TOP_PANEL_WIDTH end

	-- Stats options
	if o == "UIConfig_stats" then o = L_GUI_STATS end
	if o == "UIConfig_statsbattleground" then o = L_GUI_STATS_BG end
	if o == "UIConfig_statsclock" then o = L_GUI_STATS_CLOCK end
	if o == "UIConfig_statslatency" then o = L_GUI_STATS_LATENCY end
	if o == "UIConfig_statsmemory" then o = L_GUI_STATS_MEMORY end
	if o == "UIConfig_statsfps" then o = L_GUI_STATS_FPS end
	if o == "UIConfig_statsfriend" then o = FRIENDS end
	if o == "UIConfig_statsguild" then o = GUILD end
	if o == "UIConfig_statsdurability" then o = L_COMPATIBILITY_DURABILITY end
	if o == "UIConfig_statsexperience" then o = L_GUI_STATS_EXPERIENCE end
	if o == "UIConfig_statscoords" then o = L_GUI_STATS_COORDS end
	if o == "UIConfig_statslocation" then o = L_GUI_STATS_LOCATION end
	if o == "UIConfig_statscurrency_raid" then o = L_GUI_STATS_CURRENCY_RAID end
	if o == "UIConfig_statscurrency_pvp" then o = L_GUI_STATS_CURRENCY_PVP end
	if o == "UIConfig_statscurrency_misc" then o = L_GUI_STATS_CURRENCY_MISCELLANEOUS end

	-- Error options
	if o == "UIConfig_error" then o = L_GUI_ERROR end
	if o == "UIConfig_errorblack" then o = L_GUI_ERROR_BLACK end
	if o == "UIConfig_errorwhite" then o = L_GUI_ERROR_WHITE end
	if o == "UIConfig_errorcombat" then o = L_GUI_ERROR_HIDE_COMBAT end

	T.option = o
end

local NewButton = function(text, parent)
	local T, C, L, _ = unpack(ShestakUI)

	local result = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	local label = result:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetText(text)
	label:SetPoint("LEFT", result, "LEFT", 2, 0)
	label:SetPoint("RIGHT", result, "RIGHT", -2, 0)
	label:SetJustifyH("LEFT")
	result:SetWidth(label:GetWidth())
	result:SetHeight(label:GetHeight())
	result:SetFontString(label)
	result:SetNormalTexture("")
	result:SetHighlightTexture("")
	result:SetPushedTexture("")

	return result
end

local NormalButton = function(text, parent)
	local T, C, L, _ = unpack(ShestakUI)

	local result = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	local label = result:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	label:SetJustifyH("LEFT")
	label:SetText(text)
	result:SetWidth(100)
	result:SetHeight(23)
	result:SetFontString(label)
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.Reskin(result)
	else
		result:SkinButton()
	end

	return result
end

StaticPopupDialogs.PERCHAR = {
	text = L_GUI_PER_CHAR,
	OnAccept = function()
		if UIConfigAllCharacters:GetChecked() then
			GUIConfigAll[realm][name] = true
		else
			GUIConfigAll[realm][name] = false
		end
		ReloadUI()
	end,
	OnCancel = function()
		UIConfigCover:Hide()
		if UIConfigAllCharacters:GetChecked() then
			UIConfigAllCharacters:SetChecked(false)
		else
			UIConfigAllCharacters:SetChecked(true)
		end
	end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 5,
}

StaticPopupDialogs.RESET_PERCHAR = {
	text = L_GUI_RESET_CHAR,
	OnAccept = function()
		GUIConfig = GUIConfigSettings
		ReloadUI()
	end,
	OnCancel = function() if UIConfig and UIConfig:IsShown() then UIConfigCover:Hide() end end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 5,
}

StaticPopupDialogs.RESET_ALL = {
	text = L_GUI_RESET_ALL,
	OnAccept = function()
		GUIConfigSettings = nil
		GUIConfig = nil
		ReloadUI()
	end,
	OnCancel = function() UIConfigCover:Hide() end,
	button1 = ACCEPT,
	button2 = CANCEL,
	timeout = 0,
	whileDead = 1,
	preferredIndex = 5,
}

local function SetValue(group, option, value)
	local mergesettings
	if GUIConfig == GUIConfigSettings then
		mergesettings = true
	else
		mergesettings = false
	end

	if GUIConfigAll[realm][name] == true then
		if not GUIConfig then GUIConfig = {} end
		if not GUIConfig[group] then GUIConfig[group] = {} end
		GUIConfig[group][option] = value
	else
		if mergesettings == true then
			if not GUIConfig then GUIConfig = {} end
			if not GUIConfig[group] then GUIConfig[group] = {} end
			GUIConfig[group][option] = value
		end

		if not GUIConfigSettings then GUIConfigSettings = {} end
		if not GUIConfigSettings[group] then GUIConfigSettings[group] = {} end
		GUIConfigSettings[group][option] = value
	end
end

local VISIBLE_GROUP = nil
local lastbutton = nil
local function ShowGroup(group, button)
	local T, C, L, _ = unpack(ShestakUI)

	if lastbutton then
		lastbutton:SetText(lastbutton:GetText().sub(lastbutton:GetText(), 11, -3))
	end
	if VISIBLE_GROUP then
		_G["UIConfig_"..VISIBLE_GROUP]:Hide()
	end
	if _G["UIConfig_"..group] then
		local o = "UIConfig_"..group
		Local(o)
		_G["UIConfigTitle"]:SetText(T.option)
		_G["UIConfig_"..group]:Show()
		local height = _G["UIConfig_"..group]:GetHeight()
		local scrollMax = GlobalHeight
		local scrollMin = scrollMax - 10
		local max = height > scrollMax and height - scrollMin or 1

		if max == 1 then
			_G["UIConfigGroupSlider"]:SetValue(0)
			_G["UIConfigGroupSlider"]:Hide()
		else
			_G["UIConfigGroupSlider"]:SetMinMaxValues(0, max)
			_G["UIConfigGroupSlider"]:SetValue(1)
			_G["UIConfigGroupSlider"]:Show()
		end
		_G["UIConfigGroup"]:SetScrollChild(_G["UIConfig_"..group])

		local x
		if UIConfigGroupSlider:IsShown() then
			_G["UIConfigGroup"]:EnableMouseWheel(true)
			_G["UIConfigGroup"]:SetScript("OnMouseWheel", function(self, delta)
				if UIConfigGroupSlider:IsShown() then
					if delta == -1 then
						x = _G["UIConfigGroupSlider"]:GetValue()
						_G["UIConfigGroupSlider"]:SetValue(x + 10)
					elseif delta == 1 then
						x = _G["UIConfigGroupSlider"]:GetValue()
						_G["UIConfigGroupSlider"]:SetValue(x - 30)
					end
				end
			end)
		else
			_G["UIConfigGroup"]:EnableMouseWheel(false)
		end

		VISIBLE_GROUP = group
		lastbutton = button
	end
end

local loaded
function CreateUIConfig()
	if InCombatLockdown() and not loaded then print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return end
	local T, C, L, _ = unpack(ShestakUI)

	if UIConfigMain then
		ShowGroup("general")
		UIConfigMain:Show()
		return
	end

	-- Main Frame
	local UIConfigMain = CreateFrame("Frame", "UIConfigMain", UIParent)
	UIConfigMain:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, 200)
	UIConfigMain:SetWidth(780)
	UIConfigMain:SetHeight(GlobalHeight + 120)
	if IsAddOnLoaded("Aurora") then
		local F = unpack(Aurora)
		F.CreateBD(UIConfigMain)
	else
		UIConfigMain:SetTemplate("Transparent")
	end
	UIConfigMain:SetFrameStrata("DIALOG")
	UIConfigMain:SetFrameLevel(20)
	UIConfigMain:SetClampedToScreen(true)
	tinsert(UISpecialFrames, "UIConfigMain")

	-- Version Title
	local TitleBoxVer = CreateFrame("Frame", "TitleBoxVer", UIConfigMain)
	TitleBoxVer:SetWidth(180)
	TitleBoxVer:SetHeight(26)
	TitleBoxVer:SetPoint("TOPLEFT", UIConfigMain, "TOPLEFT", 23, -15)

	local TitleBoxVerText = TitleBoxVer:CreateFontString("UIConfigTitleVer", "OVERLAY", "GameFontNormal")
	TitleBoxVerText:SetPoint("CENTER")
	TitleBoxVerText:SetText("ShestakUI "..T.version)

	-- Main Frame Title
	local TitleBox = CreateFrame("Frame", "TitleBox", UIConfigMain)
	TitleBox:SetWidth(540)
	TitleBox:SetHeight(26)
	TitleBox:SetPoint("TOPLEFT", TitleBoxVer, "TOPRIGHT", 15, 0)

	local TitleBoxText = TitleBox:CreateFontString("UIConfigTitle", "OVERLAY", "GameFontNormal")
	TitleBoxText:SetPoint("LEFT", TitleBox, "LEFT", 15, 0)

	-- Options Frame
	local UIConfig = CreateFrame("Frame", "UIConfig", UIConfigMain)
	UIConfig:SetPoint("TOPLEFT", TitleBox, "BOTTOMLEFT", 10, -15)
	UIConfig:SetWidth(520)
	UIConfig:SetHeight(GlobalHeight)

	local UIConfigBG = CreateFrame("Frame", "UIConfigBG", UIConfig)
	UIConfigBG:SetPoint("TOPLEFT", -10, 10)
	UIConfigBG:SetPoint("BOTTOMRIGHT", 10, -10)

	-- Group Frame
	local groups = CreateFrame("ScrollFrame", "UIConfigCategoryGroup", UIConfig)
	groups:SetPoint("TOPLEFT", TitleBoxVer, "BOTTOMLEFT", 10, -15)
	groups:SetWidth(160)
	groups:SetHeight(GlobalHeight)

	local groupsBG = CreateFrame("Frame", "groupsBG", UIConfig)
	groupsBG:SetPoint("TOPLEFT", groups, -10, 10)
	groupsBG:SetPoint("BOTTOMRIGHT", groups, 10, -10)

	local UIConfigCover = CreateFrame("Frame", "UIConfigCover", UIConfigMain)
	UIConfigCover:SetPoint("TOPLEFT", 0, 0)
	UIConfigCover:SetPoint("BOTTOMRIGHT", 0, 0)
	UIConfigCover:SetFrameLevel(UIConfigMain:GetFrameLevel() + 20)
	UIConfigCover:EnableMouse(true)
	UIConfigCover:SetScript("OnMouseDown", function(self) print(L_GUI_MAKE_SELECTION) end)
	UIConfigCover:Hide()

	-- Group Scroll
	local slider = CreateFrame("Slider", "UIConfigCategorySlider", groups)
	slider:SetPoint("TOPRIGHT", 0, 0)
	slider:SetWidth(20)
	slider:SetHeight(GlobalHeight)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self, value) groups:SetVerticalScroll(value) end)

	if not slider.bg then
		slider.bg = CreateFrame("Frame", nil, slider)
		slider.bg:SetPoint("TOPLEFT", slider:GetThumbTexture(), "TOPLEFT", 10, -7)
		slider.bg:SetPoint("BOTTOMRIGHT", slider:GetThumbTexture(), "BOTTOMRIGHT", -7, 7)
		slider.bg:SetTemplate("Overlay")
		slider:GetThumbTexture():SetAlpha(0)
	end

	local function sortMyTable(a, b)
		return ALLOWED_GROUPS[a] < ALLOWED_GROUPS[b]
	end
	local function pairsByKey(t)
		local a = {}
		for n in pairs(t) do table.insert(a, n) end
		table.sort(a, sortMyTable)
		local i = 0
		local iter = function()
			i = i + 1
			if a[i] == nil then return nil
			else return a[i], t[a[i]]
			end
		end
		return iter
	end

	local GetOrderedIndex = function(t)
		local OrderedIndex = {}

		for key in pairs(t) do table.insert(OrderedIndex, key) end
		table.sort(OrderedIndex)
		return OrderedIndex
	end

	local OrderedNext = function(t, state)
		local Key

		if (state == nil) then
			t.OrderedIndex = GetOrderedIndex(t)
			Key = t.OrderedIndex[1]
			return Key, t[Key]
		end

		Key = nil
		for i = 1, #t.OrderedIndex do
			if (t.OrderedIndex[i] == state) then Key = t.OrderedIndex[i + 1] end
		end

		if Key then return Key, t[Key] end
		t.OrderedIndex = nil
		return
	end

	local PairsByKeys = function(t) return OrderedNext, t, nil end

	local child = CreateFrame("Frame", nil, groups)
	child:SetPoint("TOPLEFT")
	local offset = 5
	for i in pairsByKey(ALLOWED_GROUPS) do
		local o = "UIConfig_"..i
		Local(o)
		local button = NewButton(T.option, child)
		button:SetHeight(20)
		button:SetWidth(150)
		button:SetPoint("TOPLEFT", 5, -offset)
		button:SetScript("OnClick", function(self) ShowGroup(i, button) self:SetText("|cff00ff00"..T.option.."|r") end)
		offset = offset + 20
	end
	child:SetWidth(150)
	child:SetHeight(offset)

	local height = offset
	local scrollMax = GlobalHeight
	local scrollMin = scrollMax - 3
	local max = height > scrollMax and height - scrollMin or 1
	if max == 1 then
		slider:SetValue(0)
		slider:Hide()
	else
		slider:SetMinMaxValues(0, max)
		slider:SetValue(1)
		slider:Show()
	end
	groups:SetScrollChild(child)

	local x
	_G["UIConfigCategoryGroup"]:EnableMouseWheel(true)
	_G["UIConfigCategoryGroup"]:SetScript("OnMouseWheel", function(self, delta)
		if _G["UIConfigCategorySlider"]:IsShown() then
			if delta == -1 then
				x = _G["UIConfigCategorySlider"]:GetValue()
				_G["UIConfigCategorySlider"]:SetValue(x + 10)
			elseif delta == 1 then
				x = _G["UIConfigCategorySlider"]:GetValue()
				_G["UIConfigCategorySlider"]:SetValue(x - 20)
			end
		end
	end)

	local group = CreateFrame("ScrollFrame", "UIConfigGroup", UIConfig)
	group:SetPoint("TOPLEFT", 0, 5)
	group:SetWidth(520)
	group:SetHeight(GlobalHeight)

	-- Options Scroll
	local slider = CreateFrame("Slider", "UIConfigGroupSlider", group)
	slider:SetPoint("TOPRIGHT", 0, 0)
	slider:SetWidth(20)
	slider:SetHeight(GlobalHeight)
	slider:SetThumbTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
	slider:SetOrientation("VERTICAL")
	slider:SetValueStep(20)
	slider:SetScript("OnValueChanged", function(self, value) group:SetVerticalScroll(value) end)

	if not slider.bg then
		slider.bg = CreateFrame("Frame", nil, slider)
		slider.bg:SetPoint("TOPLEFT", slider:GetThumbTexture(), "TOPLEFT", 10, -7)
		slider.bg:SetPoint("BOTTOMRIGHT", slider:GetThumbTexture(), "BOTTOMRIGHT", -7, 7)
		slider.bg:SetTemplate("Overlay")
		slider:GetThumbTexture():SetAlpha(0)
	end

	for i in pairs(ALLOWED_GROUPS) do
		local frame = CreateFrame("Frame", "UIConfig_"..i, UIConfigGroup)
		frame:SetPoint("TOPLEFT")
		frame:SetWidth(225)

		local offset = 5

		if type(C[i]) ~= "table" then error(i.." GroupName not found in config table.") return end
		for j, value in PairsByKeys(C[i]) do
			if type(value) == "boolean" then
				local button = CreateFrame("CheckButton", "UIConfig_"..i..j, frame, "InterfaceOptionsCheckButtonTemplate")
				if IsAddOnLoaded("Aurora") then
					local F = unpack(Aurora)
					F.ReskinCheck(button)
				else
					-- T.SkinCheckBox(button)
				end
				local o = "UIConfig_"..i..j
				Local(o)
				_G["UIConfig_"..i..j.."Text"]:SetText(T.option)
				_G["UIConfig_"..i..j.."Text"]:SetFontObject(GameFontHighlight)
				_G["UIConfig_"..i..j.."Text"]:SetWidth(460)
				_G["UIConfig_"..i..j.."Text"]:SetJustifyH("LEFT")
				button:SetChecked(value)
				button:SetScript("OnClick", function(self) SetValue(i, j, (self:GetChecked() and true or false)) end)
				button:SetPoint("TOPLEFT", 5, -offset)
				offset = offset + 25
			elseif type(value) == "number" or type(value) == "string" then
				local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				local o = "UIConfig_"..i..j
				Local(o)
				label:SetText(T.option)
				label:SetWidth(460)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -offset)

				local editbox = CreateFrame("EditBox", nil, frame)
				editbox:SetAutoFocus(false)
				editbox:SetMultiLine(false)
				editbox:SetWidth(220)
				editbox:SetHeight(20)
				editbox:SetMaxLetters(255)
				editbox:SetTextInsets(3, 0, 0, 0)
				editbox:SetFontObject(GameFontHighlight)
				editbox:SetPoint("TOPLEFT", 8, -(offset + 20))
				editbox:SetText(value)
				if IsAddOnLoaded("Aurora") then
					local F = unpack(Aurora)
					F.CreateBD(editbox)
				else
					editbox:SetTemplate("Overlay")
				end

				local okbutton = CreateFrame("Button", nil, frame)
				okbutton:SetHeight(editbox:GetHeight())
				okbutton:SkinButton()
				okbutton:SetPoint("LEFT", editbox, "RIGHT", 2, 0)

				local oktext = okbutton:CreateFontString(nil, "OVERLAY", "GameFontNormal")
				oktext:SetText(OKAY)
				oktext:SetPoint("CENTER", okbutton, "CENTER", -1, 0)
				okbutton:SetWidth(oktext:GetWidth() + 5)
				okbutton:Hide()

				if type(value) == "number" then
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(i, j, tonumber(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(i, j, tonumber(editbox:GetText())) end)
				else
					editbox:SetScript("OnEscapePressed", function(self) okbutton:Hide() self:ClearFocus() self:SetText(value) end)
					editbox:SetScript("OnChar", function(self) okbutton:Show() end)
					editbox:SetScript("OnEnterPressed", function(self) okbutton:Hide() self:ClearFocus() SetValue(i, j, tostring(self:GetText())) end)
					okbutton:SetScript("OnMouseDown", function(self) editbox:ClearFocus() self:Hide() SetValue(i, j, tostring(editbox:GetText())) end)
				end

				offset = offset + 45
			elseif type(value) == "table" then
				local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				local o = "UIConfig_"..i..j
				Local(o)
				label:SetText(T.option)
				label:SetWidth(440)
				label:SetHeight(20)
				label:SetJustifyH("LEFT")
				label:SetPoint("TOPLEFT", 5, -offset)

				colorbuttonname = (label:GetText().."ColorPicker")

				local colorbutton = CreateFrame("Button", colorbuttonname, frame)
				colorbutton:SetHeight(20)
				colorbutton:SetTemplate("Transparent")
				colorbutton:SetBackdropBorderColor(unpack(value))
				colorbutton:SetBackdropColor(value[1], value[2], value[3], 0.3)
				colorbutton:SetPoint("LEFT", label, "RIGHT", 2, 0)

				local colortext = colorbutton:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
				colortext:SetText(COLOR)
				colortext:SetPoint("CENTER")
				colortext:SetJustifyH("CENTER")
				colorbutton:SetWidth(colortext:GetWidth() + 5)

				local function round(number, decimal)
					return (("%%.%df"):format(decimal)):format(number)
				end

				colorbutton:SetScript("OnMouseDown", function(self)
					if ColorPickerFrame:IsShown() then return end
					local newR, newG, newB, newA
					local fired = 0

					local r, g, b, a = self:GetBackdropBorderColor()
					r, g, b, a = round(r, 2), round(g, 2), round(b, 2), round(a, 2)
					local originalR, originalG, originalB, originalA = r, g, b, a

					local function ShowColorPicker(r, g, b, a, changedCallback)
						ColorPickerFrame.func, ColorPickerFrame.opacityFunc, ColorPickerFrame.cancelFunc = changedCallback, changedCallback, changedCallback
						ColorPickerFrame:SetColorRGB(r, g, b)
						a = tonumber(a)
						ColorPickerFrame.hasOpacity = (a ~= nil and a ~= 1)
						ColorPickerFrame.opacity = a
						ColorPickerFrame.previousValues = {originalR, originalG, originalB, originalA}
						ColorPickerFrame:Hide()
						ColorPickerFrame:Show()
					end

					local function myColorCallback(restore)
						fired = fired + 1
						if restore ~= nil then
							-- The user bailed, we extract the old color from the table created by ShowColorPicker
							newR, newG, newB, newA = unpack(restore)
						else
							-- Something changed
							newA, newR, newG, newB = OpacitySliderFrame:GetValue(), ColorPickerFrame:GetColorRGB()
						end

						value = {newR, newG, newB, newA}
						SetValue(i, j, (value))
						self:SetBackdropBorderColor(newR, newG, newB, newA)
						self:SetBackdropColor(newR, newG, newB, 0.3)
					end

					ShowColorPicker(originalR, originalG, originalB, originalA, myColorCallback)
				end)

				offset = offset + 25
			end
		end

		frame:SetHeight(offset)
		frame:Hide()
	end

	local reset = NormalButton(DEFAULT, UIConfigMain)
	reset:SetPoint("TOPLEFT", UIConfig, "BOTTOMLEFT", -10, -25)
	reset:SetScript("OnClick", function(self)
		UIConfigCover:Show()
		if GUIConfigAll[realm][name] == true then
			StaticPopup_Show("RESET_PERCHAR")
		else
			StaticPopup_Show("RESET_ALL")
		end
	end)

	local close = NormalButton(CLOSE, UIConfigMain)
	close:SetPoint("TOPRIGHT", UIConfig, "BOTTOMRIGHT", 10, -25)
	close:SetScript("OnClick", function(self) PlaySound("igMainMenuOption") UIConfigMain:Hide() end)

	local load = NormalButton(L_COMPATIBILITY_APPLY, UIConfigMain)
	load:SetPoint("RIGHT", close, "LEFT", -4, 0)
	load:SetScript("OnClick", function(self) ReloadUI() end)

	local totalreset = NormalButton(L_GUI_BUTTON_RESET, UIConfigMain)
	totalreset:SetWidth(180)
	totalreset:SetPoint("TOPLEFT", groupsBG, "BOTTOMLEFT", 0, -15)
	totalreset:SetScript("OnClick", function(self)
		StaticPopup_Show("RESET_UI")
		GUIConfig = {}
		if GUIConfigAll[realm][name] == true then
			GUIConfigAll[realm][name] = {}
		end
		GUIConfigSettings = {}
	end)

	if GUIConfigAll then
		local button = CreateFrame("CheckButton", "UIConfigAllCharacters", TitleBox, "InterfaceOptionsCheckButtonTemplate")
		button:SetScript("OnClick", function(self) StaticPopup_Show("PERCHAR") UIConfigCover:Show() end)
		button:SetPoint("RIGHT", TitleBox, "RIGHT", -3, 0)
		button:SetHitRectInsets(0, 0, 0, 0)
		if IsAddOnLoaded("Aurora") then
			local F = unpack(Aurora)
			F.ReskinCheck(button)
		else
			T.SkinCheckBox(button)
		end

		local label = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
		label:SetText(L_GUI_SET_SAVED_SETTTINGS)
		label:SetPoint("RIGHT", button, "LEFT")

		if GUIConfigAll[realm][name] == true then
			button:SetChecked(true)
		else
			button:SetChecked(false)
		end
	end

	local bgskins = {TitleBox, TitleBoxVer, UIConfigBG, groupsBG}
	for _, sb in pairs(bgskins) do
		if IsAddOnLoaded("Aurora") then
			local F = unpack(Aurora)
			F.CreateBD(sb)
		else
			sb:SetTemplate("Overlay")
		end
	end

	ShowGroup("general")
	loaded = true
end

do
	function SlashCmdList.CONFIG()
		if not UIConfigMain or not UIConfigMain:IsShown() then
			PlaySound("igMainMenuOption")
			CreateUIConfig()
			HideUIPanel(GameMenuFrame)
		else
			PlaySound("igMainMenuOption")
			UIConfigMain:Hide()
		end
	end
	SLASH_CONFIG1 = "/config"
	SLASH_CONFIG2 = "/cfg"
	SLASH_CONFIG3 = "/configui"

	function SlashCmdList.RESETCONFIG()
		if UIConfigMain and UIConfigMain:IsShown() then UIConfigCover:Show() end

		if GUIConfigAll[realm][name] == true then
			StaticPopup_Show("RESET_PERCHAR")
		else
			StaticPopup_Show("RESET_ALL")
		end
	end
	SLASH_RESETCONFIG1 = "/resetconfig"
end

do
	local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
	frame:Hide()

	frame.name = "ShestakUI"
	frame:SetScript("OnShow", function(self)
		if self.show then return end
		local T, C, L, _ = unpack(ShestakUI)
		local title = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title:SetPoint("TOPLEFT", 8, -8)
		title:SetText("Info:")

		local subtitle = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		subtitle:SetWidth(370)
		subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
		subtitle:SetJustifyH("LEFT")
		subtitle:SetText("UI Site: |cff298F00http//shestak.org|r\nGitHub: |cff298F00https://github.com/Shestak/ShestakUI|r\nCurse: |cff298F00http://wow.curseforge.com/addons/shestakui/|r\nWoWInterface: |cff298F00http://www.wowinterface.com/downloads/info19033-ShestakUI.html|r\nChange Log: |cff298F00https://github.com/Shestak/ShestakUI/commits/master/|r")

		local title2 = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title2:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
		title2:SetText("Credits:")

		local subtitle2 = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		subtitle2:SetWidth(370)
		subtitle2:SetPoint("TOPLEFT", title2, "BOTTOMLEFT", 0, -4)
		subtitle2:SetJustifyH("LEFT")
		subtitle2:SetText("AcidWeb, Aezay, Affli, Ailae, Allez, ALZA, Ammo, Astromech, Beoko, Bitbyte, Blamdarot, Bozo, Caellian, Califpornia, Camealion, Cloudyfa, Chiril, CrusaderHeimdall, Cybey, Dawn, Don Kaban, Dridzt, Duffed, Durcyn, Eclipse, Egingell, Elv22, Evilpaul, Evl, Favorit, Fernir, Foof, Freebaser, g0st, gi2k15, Gethe, Gorlasch, Gsuz, Haleth, Haste, Hoochie, Hungtar, HyPeRnIcS, Hydra, Ildyria, iSpawnAtHome, Jaslm, Karl_w_w, Karudon, Katae, Kellett, Kemayo, Killakhan, Kraftman, Leatrix, m2jest1c, Magdain, Meurtcriss, Monolit, MrRuben5, Myrilandell of Lothar, Nathanyel, Nefarion, Nightcracker, Nils Ruesch, p3lim, Partha, Phanx, Renstrom, RustamIrzaev, Safturento, Sanex, Sara.Festung, SDPhantom, Sildor, Silverwind, SinaC, Slakah, Soeters, Starlon, Suicidal Katt, Syzgyn, Tekkub, Telroth, Thalyra, Thizzelle, Tia Lynn, Tohveli, Tukz, Tuller, Veev, Villiv, Wetxius, Woffle of Dark Iron, Wrug, Xuerian, Yleaf, Zork.")

		local title3 = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title3:SetPoint("TOPLEFT", subtitle2, "BOTTOMLEFT", 0, -8)
		title3:SetText("Translation:")

		local subtitle3 = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		subtitle3:SetWidth(370)
		subtitle3:SetPoint("TOPLEFT", title3, "BOTTOMLEFT", 0, -4)
		subtitle3:SetJustifyH("LEFT")
		subtitle3:SetText("Aelb, Alwa, Baine, Chubidu, Cranan, eXecrate, F5Hellbound, Ianchan, Leg883, Mania, Nanjiqq, Oz, Puree, Sakaras, Seal, Sinaris, Spacedragon, Tat2dawn, Tibles, Vienchen, Wetxius.")

		local title4 = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		title4:SetPoint("TOPLEFT", subtitle3, "BOTTOMLEFT", 0, -8)
		title4:SetText("Thanks:")

		local subtitle4 = self:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		subtitle4:SetWidth(370)
		subtitle4:SetPoint("TOPLEFT", title4, "BOTTOMLEFT", 0, -4)
		subtitle4:SetJustifyH("LEFT")
		subtitle4:SetText("Akimba, Antthemage, Crunching, Dandruff, DesFolk, Elfrey, Ente, Erratic, Falchior, Gromcha, Halogen, Homicidal Retribution, ILF7, Illusion, Ipton, k07n, Kazarl, Lanseb, Leots, m2jest1c, MoLLIa, Nefrit, Noobolov, Obakol, Oz, PterOs, Sart, Scorpions, Sitatunga, Sw2rT1, Tryllemann, Wetxius, Yakodzuna, UI Users and Russian Community.")

		local version = self:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		version:SetPoint("TOPRIGHT", -8, -8)
		version:SetText("Version: "..T.version)

		self.show = true
	end)

	InterfaceOptions_AddCategory(frame)
end