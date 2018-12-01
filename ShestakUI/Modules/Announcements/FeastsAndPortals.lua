local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Announce Feasts/Souls/Repair Bots/Portals/Ritual of Summoning
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(self, _, ...)
	local _, event, _, srcName, _, _, destName, _, spellID =  ...
	if not (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) or InCombatLockdown() or not event or not spellID or not srcName then return end
	if not UnitInRaid(srcName) and not UnitInParty(srcName) then return end

	local srcName = srcName:gsub("%-[^|]+", "")
	if event == "SPELL_CAST_SUCCESS" then-- Refreshment Table
		if C.announcements.feasts and spellID == 43987 then
			SendChatMessage(format(L_ANNOUNCE_FP_PRE, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		-- Ritual of Summoning
		elseif C.announcements.portals and spellID == 698 then
			SendChatMessage(format(L_ANNOUNCE_FP_CLICK, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		-- Piccolo of the Flaming Fire
		elseif C.announcements.toys and spellID == 18400 then
			SendChatMessage(format(L_ANNOUNCE_FP_USE, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		end
	elseif event == "SPELL_SUMMON" then
		-- Repair Bots
		if C.announcements.feasts and T.AnnounceBots[spellID] then
			SendChatMessage(format(L_ANNOUNCE_FP_PUT, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		end
	elseif event == "SPELL_CREATE" then
		-- Ritual of Doom
		if C.announcements.feasts and spellID == 18540 then
			SendChatMessage(format(L_ANNOUNCE_FP_PUT, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		-- Ritual of Souls
		elseif C.announcements.feasts and spellID == 29893 then
			SendChatMessage(format(L_ANNOUNCE_FP_PUT, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		-- Toys
		elseif C.announcements.toys and T.AnnounceToys[spellID] then
			SendChatMessage(format(L_ANNOUNCE_FP_PUT, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		-- Portals
		elseif C.announcements.portals and T.AnnouncePortals[spellID] then
			SendChatMessage(format(L_ANNOUNCE_FP_CAST, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		end
	elseif event == "SPELL_AURA_APPLIED" then
		-- Party G.R.E.N.A.D.E.
		if C.announcements.toys and ((spellID == 51508 or spellID == 51510) and destName == T.name) then
			SendChatMessage(format(L_ANNOUNCE_FP_USE, srcName, GetSpellLink(spellID)), T.CheckChat(true))
		end
	end
end)