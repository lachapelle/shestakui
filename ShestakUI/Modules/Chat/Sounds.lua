﻿local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.chat.enable ~= true or C.chat.whisp_sound ~= true then return end

----------------------------------------------------------------------------------------
--	Play sound files system(by Tukz)
----------------------------------------------------------------------------------------
local SoundSys = CreateFrame("Frame")
SoundSys:RegisterEvent("CHAT_MSG_WHISPER")
SoundSys:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_WHISPER" and not InCombatLockdown() then
		PlaySoundFile(C.media.whisp_sound)
	end
end)