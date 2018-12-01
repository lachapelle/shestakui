﻿local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Accept invites from guild members or friend list(by ALZA)
----------------------------------------------------------------------------------------
if C.automation.accept_invite == true then
	local CheckFriend = function(name)
		for i = 1, GetNumFriends() do
			if GetFriendInfo(i) == name then
				return true
			end
		end
		if IsInGuild() then
			for i = 1, GetNumGuildMembers() do
				if Ambiguate(GetGuildRosterInfo(i), "none") == name then
					return true
				end
			end
		end
	end

	local ai = CreateFrame("Frame")
	ai:RegisterEvent("PARTY_INVITE_REQUEST")
	ai:SetScript("OnEvent", function(self, event, name)
		if QueueStatusMinimapButton:IsShown() or GetNumGroupMembers() > 0 then return end
		if CheckFriend(name) then
			RaidNotice_AddMessage(RaidWarningFrame, L_INFO_INVITE..name, {r = 0.41, g = 0.8, b = 0.94}, 3)
			print(format("|cffffff00"..L_INFO_INVITE..name..".|r"))
			AcceptGroup()
			for i = 1, STATICPOPUP_NUMDIALOGS do
				local frame = _G["StaticPopup"..i]
				if frame:IsVisible() and frame.which == "PARTY_INVITE" then
					frame.inviteAccepted = 1
					StaticPopup_Hide("PARTY_INVITE")
					return
				end
			end
		else
			SendWho(name)
		end
	end)
end

----------------------------------------------------------------------------------------
--	Auto invite by whisper(by Tukz)
----------------------------------------------------------------------------------------
local autoinvite = CreateFrame("Frame")
autoinvite:RegisterEvent("CHAT_MSG_WHISPER")
autoinvite:SetScript("OnEvent", function(self, event, arg1, arg2, ...)
	if ((not UnitExists("party1") or (UnitIsPartyLeader(unit) or IsRaidLeader(unit)) or IsRaidOfficer(unit)) and arg1:lower():match(C.misc.invite_keyword)) and SavedOptionsPerChar.AutoInvite == true and not QueueStatusMinimapButton:IsShown() then
		if event == "CHAT_MSG_WHISPER" then
			InviteUnit(arg2)
		end
	end
end)

SlashCmdList.AUTOINVITE = function(msg)
	if msg == "off" then
		SavedOptionsPerChar.AutoInvite = false
		print("|cffffff00"..L_INVITE_DISABLE..".|r")
	elseif msg == "" then
		SavedOptionsPerChar.AutoInvite = true
		print("|cffffff00"..L_INVITE_ENABLE..C.misc.invite_keyword..".|r")
		C.misc.invite_keyword = C.misc.invite_keyword
	else
		SavedOptionsPerChar.AutoInvite = true
		print("|cffffff00"..L_INVITE_ENABLE..msg..".|r")
		C.misc.invite_keyword = msg
	end
end
SLASH_AUTOINVITE1 = "/ainv"
SLASH_AUTOINVITE2 = "/фштм"