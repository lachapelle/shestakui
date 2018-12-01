local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.announcements.drinking ~= true then return end

----------------------------------------------------------------------------------------
--	Announce enemy drinking in arena(by Duffed)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
frame:SetScript("OnEvent", function(self, event, ...)
	if not (event == "UNIT_SPELLCAST_SUCCEEDED" and IsActiveBattlefieldArena()) then return end

	local unit, spellName = ...
	if UnitIsEnemy("player", unit) and (spellName == GetSpellInfo(27089) or spellName == GetSpellInfo(44166)) then
		SendChatMessage(UnitClass(unit).." "..UnitName(unit)..L_MISC_DRINKING, T.CheckChat(true))
	end
end)