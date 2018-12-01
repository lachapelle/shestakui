local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.unitframe.enable ~= true or C.unitframe.show_arena ~= true or C.unitframe.plugins_diminishing ~= true then return end

local GetSpellInfo = GetSpellInfo

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Sap -> http://www.wowhead.com/spell=6770
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------

-- http://wowwiki.wikia.com/wiki/Diminishing_returns?oldid=1613290
-- https://github.com/Schaka/gladdy/blob/master/Modules/Diminishings.lua

T.DiminishingSpells = {
	-- Stuns
	[5211] = {"stun"},				-- Bash
	[9005] = {"stun"},				-- Pounce
	[24394] = {"stun"},				-- Intimidation
	[853] = {"stun"},				-- Hammer of Justice
	[1833] = {"stun"},				-- Cheap Shot
	[30283] = {"stun"},				-- Shadowfury
	[7922] = {"stun"},				-- Charge Stun
	[12809] = {"stun"},				-- Concussion Blow
	[20253] = {"stun"},				-- Intercept Stun
	[20549] = {"stun"},				-- War Stomp (Racial)

	--[[
	-- Stun Procs
	[16922] = {"stunproc"},			-- Celestial Focus
	[19410] = {"stunproc"},			-- Improved Concussive Shot
	[12355] = {"stunproc"},			-- Impact
	[15269] = {"stunproc"},			-- Blackout
	[20170] = {"stunproc"},			-- Seal of Justice
	[39796] = {"stunproc"},			-- Stoneclaw Totem
	-- [18093] = {"stunproc"},			-- Pyroclasm
	[5530] = {"stunproc"},			-- Mace Specialization
	--]]

	-- Disorients
	[22570] = {"disorient"},		-- Maim
	[118] = {"disorient"},			-- Polymorph
	-- [28272] = {"disorient"},		-- Polymorph (Pig)
	-- [28271] = {"disorient"},		-- Polymorph (Turtle)
	[1776] = {"disorient"},			-- Gouge
	[6770] = {"disorient"},			-- Sap

	-- Sleeps
	[2637] = {"sleep"},				-- Hibernate
	[19386] = {"sleep"},			-- Wyvern Sting

	-- Charms
	[605] = {"charm"},				-- Mind Control

	-- Fears
	[8122] = {"fear"},				-- Psychic Scream
	[5782] = {"fear"},				-- Fear
	[5484] = {"fear"},				-- Howl of Terror
	[6358] = {"fear"},				-- Seduction (Succubus)
	[5246] = {"fear"},				-- Intimidating Shout

	-- Horrors
	[6789] = {"horror"},			-- Death Coil

	-- Roots
	-- [45334] = {"root"},				-- Feral Charge Effect
	[339] = {"root"},				-- Entangling Roots
	[19975] = {"root"},				-- Entangling Roots (Nature's Grasp)
	-- [19306] = {"root"},				-- Counterattack
	[19185] = {"root"},				-- Entrapment
	-- [19229] = {"root"},				-- Improved Wing Clip
	[33395] = {"root"},				-- Freeze (Water Elemental)
	[122] = {"root"},				-- Frost Nova
	-- [12494] = {"root"},				-- Frostbite
	[44041] = {"root"},				-- Chastise
	-- [23694] = {"root"},				-- Improved Hamstring

	--[[
	-- Disarms
	[14251] = {"disarm"},			-- Riposte
	[676] = {"disarm"},				-- Disarm
	--]]

	--[[
	-- Silences
	[34490] = {"silence"},			-- Silencing Shot
	[18469] = {"silence"},			-- Counterspell - Silenced
	[15487] = {"silence"},			-- Silence
	[1330] = {"silence"},			-- Garrote - Silence
	[18425] = {"silence"},			-- Kick - Silenced
	[24259] = {"silence"},			-- Spell Lock (Felhunter)
	-- [31117] = {"silence"},			-- Unstable Affliction (Silence)
	[18498] = {"silence"},			-- Shield Bash - Silenced
	[28730] = {"silence"},			-- Arcane Torrent (Mana)
	[25046] = {"silence"},			-- Arcane Torrent (Energy)
	-- [44835] = {"silence"},			-- Maim Interrupt (incorrect spellID)
	[32747] = {"silence"},			-- Deadly Throw Interrupt
	--]]

	-- Cyclone / Blind
	[33786] = {"cycloneblind"},		-- Cyclone
	[2094] = {"cycloneblind"},		-- Blind

	-- Freezing Trap
	[3355] = {"freezingtrap"},		-- Freezing Trap

	-- Scatter Shot
	[19503] = {"scattershot"},		-- Scatter Shot

	-- Dragon's Breath
	[31661] = {"dragonsbreath"},	-- Dragon's Breath

	-- Repentence
	[20066] = {"repentance"},		-- Repentance

	--[[
	-- Turn Evil / Turn Undead
	[10326] = {"turned"},			-- Turn Evil
	[19725] = {"turned"},			-- Turn Undead
	--]]

	--[[
	-- Shackle Undead
	[9484] = {"shackle"},			-- Shackle Undead
	--]]

	-- Kidney Shot
	[408] = {"kidneyshot"},			-- Kidney Shot
}

local function GetIcon(id)
	local _, _, icon = GetSpellInfo(id)
	return icon
end

T.DiminishingIcons = {
	["stun"] = GetIcon(853),
	-- ["stunproc"] = GetIcon(5530),
	["disorient"] = GetIcon(118),
	["sleep"] = GetIcon(19386),
	["charm"] = GetIcon(605),
	["fear"] = GetIcon(8122),
	["horror"] = GetIcon(5782),
	["root"] = GetIcon(339),
	-- ["disarm"] = GetIcon(676),
	-- ["silence"] = GetIcon(15487),
	["cycloneblind"] = GetIcon(33786),
	["freezingtrap"] = GetIcon(3355),
	["scattershot"] = GetIcon(19503),
	["dragonsbreath"] = GetIcon(31661),
	["repentance"] = GetIcon(20066),
	-- ["turned"] = GetIcon(10326),
	-- ["shackle"] = GetIcon(9484),
	["kidneyshot"] = GetIcon(408),
}