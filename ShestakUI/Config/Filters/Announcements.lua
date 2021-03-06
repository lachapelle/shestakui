﻿local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Misdirection -> http://www.wowhead.com/spell=34477
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return name
	else
		print("|cffff0000WARNING: spell ID ["..tostring(id).."] no longer exists! Report this to Shestak.|r")
		return "Empty"
	end
end

if C.announcements.spells == true then
	T.AnnounceSpells = {
		SpellName(20484),	-- Rebirth
		SpellName(20707),	-- Soulstone
		SpellName(633),		-- Lay on Hands
		SpellName(34477),	-- Misdirection
		SpellName(19801),	-- Tranquilizing Shot
	}
end

if C.announcements.toys == true then
	T.AnnounceToys = {
		[49844] = true,		-- Direbrew's Remote
	}
end

if C.announcements.feasts == true then
	T.AnnounceBots = {
		[22700] = true,		-- Field Repair Bot 74A
		[44389] = true,		-- Field Repair Bot 110G
	}
end

if C.announcements.portals == true then
	T.AnnouncePortals = {
		-- Alliance
		[10059] = true,		-- Stormwind
		[11416] = true,		-- Ironforge
		[11419] = true,		-- Darnassus
		[32266] = true,		-- Exodar
		[49360] = true,		-- Theramore
		[33691] = true,		-- Shattrath
		-- Horde
		[11417] = true,		-- Orgrimmar
		[11420] = true,		-- Thunder Bluff
		[11418] = true,		-- Undercity
		[32267] = true,		-- Silvermoon
		[49361] = true,		-- Stonard
		[35717] = true,		-- Shattrath
		-- Alliance/Horde
		[28148] = true,		-- Karazhan
	}
end


if C.announcements.bad_gear == true then
	T.AnnounceBadGear = {
		-- Head
		[1] = {
			33820,	-- Weather-Beaten Fishing Hat
			19972,	-- Lucky Fishing Hat
		},
		-- Neck
		[2] = {
			32757,	-- Blessed Medallion of Karabor
		},
		-- Feet
		[8] = {
			19969,	-- Nat Pagle's Extreme Anglin' Boots
		},
		-- Back
		[15] = {
		},
		-- Main-Hand
		[16] = {
			19970,	-- Arcanite Fishing Pole
			19022,	-- Nat Pagle's Extreme Angler FC-5000
			25978,	-- Seth's Graphite Fishing Pole
			6367,	-- Big Iron Fishing Pole
			6366,	-- Darkwood Fishing Pole
			6365,	-- Strong Fishing Pole
			12225,	-- Blump Family Fishing Pole
			6256,	-- Fishing Pole
		},
		-- Off-hand
		[17] = {
		},
	}
end