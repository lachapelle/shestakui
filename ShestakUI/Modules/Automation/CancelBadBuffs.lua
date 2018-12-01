local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.automation.cancel_bad_buffs ~= true then return end

----------------------------------------------------------------------------------------
--	Auto cancel various buffs(by Unknown)
----------------------------------------------------------------------------------------
local buffIndex

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_AURAS_CHANGED")
frame:SetScript("OnEvent", function(self, event)
	if event == "PLAYER_AURAS_CHANGED" and not InCombatLockdown() then
		for buff, enabled in next, T.BadBuffs do
			local isBuffPresent, buffIndex = T.CheckPlayerBuff(buff)
			if isBuffPresent then
				CancelPlayerBuff(buffIndex)
				print("|cffffff00"..ACTION_SPELL_AURA_REMOVED.."|r "..(GetSpellLink(buff) or ("|cffffff00["..buff.."]|r")).."|cffffff00.|r")
			end
		end
	end
end)