local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Well Fed -> http://www.wowhead.com/spell=104280
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
if C.reminder.raid_buffs_enable == true or C.announcements.flask_food == true then
	T.ReminderBuffs = {
		Flask = {
			-- 17624,	-- Flask of Petrification (Immunity)
			17627,	-- Flask of Distilled Wisdom (+65 Intellect)
			17628,	-- Flask of Supreme Power (+70 Spell Power)
			17629,	-- Flask of Chromatic Resistance (+25 Magic Resistance)
			17626,	-- Flask of the Titans (+400 Health)
			28518,	-- Flask of Fortification (+500 Health / +10 Defense)
			28519,	-- Flask of Mighty Restoration (+25 Mp5)
			28520,	-- Flask of Relentless Assault (+120 Attack Power)
			28521,	-- Flask of Blinding Light (+80 Arcane/Holy/Nature Spell Power)
			28540,	-- Flask of Pure Death (+80 Shadow/Fire/Frost Spell Power)
			40567,	-- Unstable Flask of the Bandit (+20 Agility / +40 Attack Power / +30 Stamina)
			40568,	-- Unstable Flask of the Elder (+20 Intellect / +30 Stamina / +8 Mp5)
			40572,	-- Unstable Flask of the Beast (+20 Agility / +20 Strength / +30 Stamina)
			40573,	-- Unstable Flask of the Physician (+20 Intellect / +30 Stamina / +44 Healing Power)
			40575,	-- Unstable Flask of the Soldier (+20 Critical Strike / +20 Strength / +30 Stamina)
			40576,	-- Unstable Flask of the Sorcerer (+20 Intellect / +30 Stamina / +23 Spell Power)
			41608,	-- Shattrath Flask of Relentless Assault (+120 Attack Power)
			41609,	-- Shattrath Flask of Fortification (+500 Health / +10 Defense)
			41610,	-- Shattrath Flask of Mighty Restoration (+25 Mp5)
			41611,	-- Shattrath Flask of Supreme Power (+70 Spell Power)
			42735,	-- Flask of Chromatic Wonder (+35 Magic Resistance / +18 Stats)
			46837,	-- Shattrath Flask of Pure Death (+80 Shadow/Fire/Frost Spell Power)
			46839,	-- Shattrath Flask of Blinding Light (+80 Arcane/Holy/Nature Spell Power)
		},
		BattleElixir = {
			11406,	-- Elixir of Demonslaying (+265 Attack Power to Demons)
			17539,	-- Greater Arcane Elixir (+35 Arcane Spell Power)
			28490,	-- Elixir of Major Strength (+35 Strength)
			28491,	-- Elixir of Healing Power (+50 Healing Power)
			28493,	-- Elixir of Major Frost Power (+55 Frost Spell Power)
			28497,	-- Elixir of Major Agility (+35 Agility / +20 Critical Strike)
			28501,	-- Elixir of Major Firepower (+55 Fire Spell Power)
			28503,	-- Elixir of Major Shadow Power (+55 Shadow Spell Power)
			33720,	-- Onslaught Elixir (+60 Attack Power)
			33721,	-- Adept's Elixir (+24 Spell Power / +24 Critical Strike)
			33726,	-- Elixir of Mastery (+15 Stats)
			38954,	-- Fel Strength Elixir (+90 Attack Power / -10 Stamina)
			45373,	-- Bloodberry Elixir (+15 Stats)
		},
		GuardianElixir = {
			28502,	-- Elixir of Major Defense (+550 Armor)
			28509,	-- Elixir of Major Mageblood (+16 Mp5)
			28514,	-- Elixir of Empowerment (+30 Spell Penetration)
			39625,	-- Elixir of Major Fortitude (+250 Health / 10 Hp5)
			39626,	-- Earthen Elixir (+20 Damage Reduction)
			39627,	-- Elixir of Draenic Wisdom (+30 Intellect / +30 Spirit)
			39628,	-- Elixir of Ironskin (+30 Resilience Rating)
		},
		Food = {
			33257,	-- Well Fed (+30 Stamina / +20 Spirit) [Fisherman's Feast / Spicy Crawdad]
			15852,	-- Dragonbreath Chili (Special) [Dragonbreath Chili]
			22730,	-- Increased Intellect (+10 Intellect) [Runn Tum Tuber Surprise]
			24799,	-- Well Fed (+20 Strength) [Helboar Bacon / Smoked Desert Dumplings]
			25661,	-- Increased Stamina (+25 Stamina) [Dirge's Kickin' Chimaerok Chops]
			-- 33254,	-- Well Fed (+20 Stamina / +20 Spirit) [Buzzard Bites / Clam Bar / Feltail Delight]
			33256,	-- Well Fed (+20 Strength / +20 Spirit) [Roasted Clefthoof]
			33259,	-- Well Fed (+40 Attack Power / +20 Spirit) [Ravager Dog]
			33261,	-- Well Fed (+20 Agility / +20 Spirit) [Grilled Mudfish / Warp Burger]
			33263,	-- Well Fed (+23 Spell Power / +20 Spirit) [Blackened Basilisk / Crunchy Serpent / Poached Bluefish]
			33265,	-- Well Fed (+20 Stamina / +8 Mp5) [Blackened Sporefish]
			33268,	-- Well Fed (+44 Healing Power / +20 Spirit) [Golden Fish Sticks]
			-- 35272,	-- Well Fed (+20 Stamina / +20 Spirit) [Mok'Nathal Shortribs / Talbuk Steak]
			43722,	-- Enlightened (+20 Spell Critical Strike / +20 Spirit) [Skullfish Soup]
			43730,	-- Electrified (Special) [Stormchops]
			43764,	-- Well Fed (+20 Physical Hit Rating / +20 Spirit) [Spicy Hot Talbuk]
			-- 44104,	-- "Well Fed" (+20 Stamina / +20 Spirit) [Brewfest]
			-- 44105,	-- "Well Fed" (+20 Stamina / +20 Spirit) [Brewfest]
			44106,	-- "Well Fed" (+20 Strength / +20 Spirit) [Brewfest]
			-- 45245,	-- Well Fed (+20 Stamina / +20 Spirit) [Hot Apple Cider]
			45619,	-- Well Fed (+8 Magic Resistance) [Broiled Bloodfin]
		},
		PetFood = {
			33272,	-- Well Fed (+20 Stamina / +20 Spirit) [Sporeling Snack]
			43771,	-- Well Fed (+20 Strength / +20 Spirit) [Kibler's Bits]
		},
		Kings = {
			20217,	-- Blessing of Kings
			25898,	-- Greater Blessing of Kings
		},
		Mark = {
			1126,	-- Mark of the Wild
			21849,	-- Gift of the Wild
		},
		Fortitude = {
			1243,	-- Power Word: Fortitude
			21562,	-- Prayer of Fortitude
		},
		Spirit = {
			14752,	-- Divine Spirit
			27681,	-- Prayer of Spirit
		},
		Sanctuary = {
			20911,	-- Blessing of Sanctuary
			25899,	-- Greater Blessing of Sanctuary
		},
		Salvation = {
			1038,	-- Blessing of Salvation
			25895,	-- Greater Blessing of Salvation
		},
		Might = {
			19740,	-- Blessing of Might
			25782,	-- Greater Blessing of Might
		},
		Intellect = {
			1459,	-- Arcane Intellect
			23028,	-- Arcane Brilliance
		},
		Wisdom = {
			19742,	-- Blessing of Wisdom
			25894,	-- Greater Blessing of Wisdom
		},
	}
end

----------------------------------------------------------------------------------------
--[[------------------------------------------------------------------------------------
	Spell Reminder Arguments

	Type of Check:
		spells - List of spells in a group, if you have anyone of these spells the icon will hide.
		weapon - Run a weapon enchant check instead of a spell check

	Spells only Requirements:
		negate_spells - List of spells in a group, if you have anyone of these spells the icon will immediately hide and stop running the spell check (these should be other peoples spells)
		personal - like a negate_spells but only for your spells
		reversecheck - only works if you provide a role or a spec, instead of hiding the frame when you have the buff, it shows the frame when you have the buff
		negate_reversecheck - if reversecheck is set you can set a spec to not follow the reverse check

	Requirements:
		role - you must be a certain role for it to display (Tank, Melee, Caster)
		spec - you must be active in a specific spec for it to display (1, 2, 3) note: spec order can be viewed from top to bottom when you open your talent pane
		level - the minimum level you must be (most of the time we don't need to use this because it will register the spell learned event if you don't know the spell, but in some cases it may be useful)

	Additional Checks: (Note we always run a check when gaining/losing an aura)
		combat - check when entering combat
		instance - check when entering a party/raid instance
		pvp - check when entering a bg/arena

	For every group created a new frame is created, it's a lot easier this way.
]]--------------------------------------------------------------------------------------
if C.reminder.solo_buffs_enable == true then
	T.ReminderSelfBuffs = {
		--[[
		ROGUE = {
			[1] = {	-- Lethal Poisons group
				["spells"] = {
					2823,	-- Deadly Poison
					8679,	-- Wound Poison
				},
				["spec"] = 1,		-- Only Assassination have poisen now
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			[2] = {	-- Non-Lethal Poisons group
				["spells"] = {
					3408,	-- Crippling Poison
					108211,	-- Leeching Poison
				},
				["spec"] = 1,		-- Only Assassination have poisen now
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		--]]
		DRUID = {
			[1] = {	-- Mark of the Wild group
				["spells"] = {
					1126,	-- Mark of the Wild
					21849,	-- Gift of the Wild
				},
				["combat"] = true,
				["instance"] = true,
			},
			[2] = {	-- Omen of Clarity group
				["spells"] = {
					16864,	-- Omen of Clarity
				},
				["combat"] = true,
				["instance"] = true,
			},
		},
		HUNTER = {
			[1] = {	-- Aspects group
				["spells"] = {
					13165,	-- Aspect of the Hawk
					13161,	-- Aspect of the Beast
					5118,	-- Aspect of the Cheetah
					13163,	-- Aspect of the Monkey
					13159,	-- Aspect of the Pack
					34074,	-- Aspect of the Viper
					20043,	-- Aspect of the Wild
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
				-- ["level"] = 10,
			},
			[2] = {	-- Trueshot group
				["spells"] = {
					19506,	-- Trueshot Aura
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		MAGE = {
			[1] = {	-- Armors group
				["spells"] = {
					30482,	-- Molten Armor
					168,	-- Frost Armor
					6117,	-- Mage Armor
					7302,	-- Ice Armor
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			[2] = {	-- Intellect group
				["spells"] = {
					1459,	-- Arcane Intellect
					23028,	-- Arcane Brilliance
				},
				["combat"] = true,
				["instance"] = true,
			},
		},
		PALADIN = {
			[1] = {	-- Righteous Fury group
				["spells"] = {
					25780,	-- Righteous Fury
				},
				["role"] = "Tank",
				["instance"] = true,
				["reversecheck"] = true,
				-- ["negate_reversecheck"] = 1,	-- Holy paladins use RF sometimes
				["negate_reversecheck"] = "Healer",	-- Holy paladins use RF sometimes
				-- ["level"] = 16,
			},
			[2] = {	-- Auras group
				["spells"] = {
					465,	-- Devotion Aura
					7294,	-- Retribution Aura
					20218,	-- Sanctity Aura
					19746,	-- Concentration Aura
					19891,	-- Fire Resistance Aura
					19888,	-- Frost Resistance Aura
					19876,	-- Shadow Resistance Aura
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			--[[
			[3] = {	-- Seals group
				["spells"] = {
					21084,	-- Seal of Righteousness
					31892,	-- Seal of Blood
					27170,	-- Seal of Command
					20164,	-- Seal of Justice
					20165,	-- Seal of Light
					31801,	-- Seal of Vengeance
					20166,	-- Seal of Wisdom
					21082,	-- Seal of the Crusader
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			--]]
		},
		PRIEST = {
			[1] = {	-- Inner Fire/Will group
				["spells"] = {
					588,	-- Inner Fire
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
				-- ["level"] = 12,
			},
			[2] = {	-- Stamina Group
				["spells"] = {
					1243,	-- Power Word: Fortitude
					21562,	-- Prayer of Fortitude
				},
				["combat"] = true,
				["instance"] = true,
			},
			[3] = {	-- Spirit
				["spells"] = {
					14752,	-- Divine Spirit
					27681,	-- Prayer of Spirit
				},
				["combat"] = true,
				["instance"] = true,
				-- ["level"] = 30,
			},
			[4] = {	-- Shadow Resistance group
				["spells"] = {
					976,	-- Shadow Protection
					27683,	-- Prayer of Shadow Protection
				},
				["combat"] = true,
				["instance"] = true,
				-- ["level"] = 30,
			},
			--[[
			[5] = {	-- Shadowform group
				["spells"] = {
					15473,	-- Shadowform
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			--]]
		},
		ROGUE = { 
			[1] = {	-- Weapons enchants group
				["weapon"] = true,
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
				-- ["level"] = 20,
			},
		},
		SHAMAN = {
			[1] = {	-- Shields group
				["spells"] = {
					24398,	-- Water Shield
					324,	-- Lightning Shield
					974,	-- Earth Shield
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
				-- ["level"] = 8,
			},
			[2] = {	-- Weapons enchants group
				["weapon"] = true,
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		WARLOCK = {
			[1] = {	-- Armors group
				["spells"] = {
					28176,	-- Fel Armor
					706,	-- Demon Armor
					687,	-- Demon Skin
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
		},
		WARRIOR = {
			[1] = {	-- Commanding Shout group
				["spells"] = {
					469,	-- Commanding Shout
				},
				["negate_spells"] = {
					6673,	-- Battle Shout
				},
				["combat"] = true,
				["role"] = "Tank",
				-- ["level"] = 68,
			},
			[2] = {	-- Battle Shout group
				["spells"] = {
					6673,	-- Battle Shout
				},
				["negate_spells"] = {
					469,	-- Commanding Shout
				},
				["combat"] = true,
				["role"] = "Melee",
			},
			--[[
			[3] = {	-- Stance group
				["spells"] = {
					2457,	-- Battle Stance
					2458,	-- Berserker Stance
					71,		-- Defensive Stance
				},
				["combat"] = true,
				["instance"] = true,
				["pvp"] = true,
			},
			--]]
		},
	}
end