local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.announcements.spells ~= true then return end

----------------------------------------------------------------------------------------
--	Announce some spells
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", function(self, _, ...)
	local _, event, sourceGUID, sourceName, _, _, destName, _, spellID, spellName = ...
	local spells = T.AnnounceSpells
	local _, instanceType = IsInInstance()
	if IsInInstance() and instanceType ~= "none" or event ~= "SPELL_CAST_SUCCESS" then return end

	if sourceName then sourceName = sourceName:gsub("%-[^|]+", "") end
	if destName then destName = destName:gsub("%-[^|]+", "") end
	if C.announcements.spells_from_all == true and not (sourceGUID == UnitGUID("player") and sourceName == T.name) then
		if not sourceName then return end

		for i, spells in pairs(spells) do
			if spellName == spells then
				if destName == nil then
					SendChatMessage(format(L_ANNOUNCE_FP_USE, sourceName, GetSpellLink(spellID)), T.CheckChat())
				else
					SendChatMessage(format(L_ANNOUNCE_FP_USE, sourceName, GetSpellLink(spellID).." -> "..destName), T.CheckChat())
				end
			end
		end
	else
		if not (sourceGUID == UnitGUID("player") and sourceName == T.name) then return end

		for i, spells in pairs(spells) do
			if spellName == spells then
				if destName == nil then
					SendChatMessage(format(L_ANNOUNCE_FP_USE, sourceName, GetSpellLink(spellID)), T.CheckChat())
				else
					SendChatMessage(GetSpellLink(spellID).." -> "..destName, T.CheckChat())
				end
			end
		end
	end
end)