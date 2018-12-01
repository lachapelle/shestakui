local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Check outdated UI version
----------------------------------------------------------------------------------------
local check = function(self, event, prefix, message, channel, sender)
	if event == "CHAT_MSG_ADDON" then
		if prefix ~= "ShestakUIVer" or sender == T.name then return end
		if tonumber(message) ~= nil and tonumber(message) > tonumber(T.version) then
			print("|cffff0000"..L_MISC_UI_OUTDATED.."|r")
			self:UnregisterEvent("CHAT_MSG_ADDON")
		end
	else
		local _, instanceType = IsInInstance()
		if IsInInstance then
			if instanceType == "pvp" then
				SendAddonMessage("ShestakUIVer", tonumber(T.version), "BATTLEGROUND")
			elseif instanceType == ("arena" or "party" or "raid") then
				SendAddonMessage("ShestakUIVer", tonumber(T.version), "RAID")
			end
		elseif IsInGuild() then
			SendAddonMessage("ShestakUIVer", tonumber(T.version), "GUILD")
		end
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame:RegisterEvent("RAID_ROSTER_UPDATE")
frame:RegisterEvent("CHAT_MSG_ADDON")
frame:SetScript("OnEvent", check)

----------------------------------------------------------------------------------------
--	Whisper UI version
----------------------------------------------------------------------------------------
local whisp = CreateFrame("Frame")
whisp:RegisterEvent("CHAT_MSG_WHISPER")
whisp:SetScript("OnEvent", function(self, event, text, name, ...)
	if text:lower():match("ui_version") or text:lower():match("уи_версия") then
		SendChatMessage("ShestakUI "..T.version, "WHISPER", nil, name)
	end
end)