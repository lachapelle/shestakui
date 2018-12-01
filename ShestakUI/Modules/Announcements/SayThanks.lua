local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.announcements.says_thanks ~= true then return end

----------------------------------------------------------------------------------------
--	Says thanks for some spells (SaySapped by Bitbyte, modified by m2jest1c)
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

local spells = {
	[SpellName(20484)] = true,		-- Rebirth
	[SpellName(20707)] = true,		-- Soulstone
	[SpellName(2006)] = true,		-- Resurrection
	[SpellName(7328)] = true,		-- Redemption
	[SpellName(2008)] = true,		-- Ancestral Spirit
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(self, _, ...)
	local _, event, _, buffer, _, _, player, _, spellID, spellName = ...
	for key, value in pairs(spells) do
		if spellName == key and value == true and player == T.name and buffer ~= T.name and event == "SPELL_CAST_SUCCESS" then
			SendChatMessage(L_ANNOUNCE_SS_THANKS..GetSpellLink(spellID)..", "..buffer:gsub("%-[^|]+", ""), "WHISPER", nil, buffer)
			print(GetSpellLink(spellID)..L_ANNOUNCE_SS_RECEIVED..buffer)
		end
	end
end)