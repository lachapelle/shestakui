local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.chat.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Style chat frame(by Tukz and p3lim)
----------------------------------------------------------------------------------------
local origs = {}

local function Strip(info, name)
	return format("|Hplayer:%s|h[%s]|h", info, name:gsub("%-[^|]+", ""))
end

if C.chat.time then
	if C.chat.time_seconds then
		if C.chat.time_24 then
			timeStampFormat = T.RGBToHex(unpack(C.chat.time_color)).."[%H:%M:%S]|r "
		else
			timeStampFormat = T.RGBToHex(unpack(C.chat.time_color)).."[%I:%M:%S]|r "
		end
	else
		if C.chat.time_24 then
			timeStampFormat = T.RGBToHex(unpack(C.chat.time_color)).."[%H:%M]|r "
		else
			timeStampFormat = T.RGBToHex(unpack(C.chat.time_color)).."[%I:%M]|r "
		end
	end
end

-- Function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if type(text) == "string" then
		text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")
		text = text:gsub("|Hplayer:(.-)|h%[(.-)%]|h", Strip)
		-- local timeStamp = BetterDate(timeStampFormat, time())
		-- text = timeStamp..text
	end
	return origs[self](self, text, ...)
end

-- Global strings
_G.CHAT_BATTLEGROUND_GET = "|Hchannel:BATTLEGROUND|h["..L_CHAT_BATTLEGROUND.."]|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:BATTLEGROUND|h["..L_CHAT_BATTLEGROUND_LEADER.."]|h %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:GUILD|h["..L_CHAT_GUILD.."]|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:OFFICER|h["..L_CHAT_OFFICER.."]|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:PARTY|h["..L_CHAT_PARTY.."]|h %s:\32"
_G.CHAT_RAID_GET = "|Hchannel:RAID|h["..L_CHAT_RAID.."]|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:RAID|h["..L_CHAT_RAID_LEADER.."]|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "["..L_CHAT_RAID_WARNING.."] %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = L_CHAT_WHISPER.." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_FLAG_AFK = "|cffE7E716"..L_CHAT_AFK.."|r "
_G.CHAT_FLAG_DND = "|cffFF0000"..L_CHAT_DND.."|r "
_G.CHAT_FLAG_GM = "|cff4154F5"..L_CHAT_GM.."|r "
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L_CHAT_COME_ONLINE
_G.ERR_FRIEND_OFFLINE_S = "[%s] "..L_CHAT_GONE_OFFLINE

--[[
if T.client == "ruRU" then
	_G.FACTION_STANDING_DECREASED = "Отношение |3-7(%s) -%d."
	_G.FACTION_STANDING_INCREASED = "Отношение |3-7(%s) +%d."
end
--]]

-- Hide chat bubble menu button
ChatFrameMenuButton:Kill()

-- Set chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()

	_G[chat]:SetFrameLevel(5)

	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen
	_G[chat]:SetClampedToScreen(false)

	-- Stop the chat chat from fading out
	_G[chat]:SetFading(false)

	-- Move the chat edit box
	_G["ChatFrameEditBox"]:ClearAllPoints()
	_G["ChatFrameEditBox"]:SetPoint("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -10, 23)
	_G["ChatFrameEditBox"]:SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 11, 23)

	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture
	_G[format("ChatFrame%sTabLeft", id)]:Kill()
	_G[format("ChatFrame%sTabMiddle", id)]:Kill()
	_G[format("ChatFrame%sTabRight", id)]:Kill()

	-- Removes Chat Frame scroll buttons
	_G[format("ChatFrame%sUpButton", id)]:Kill()
	_G[format("ChatFrame%sDownButton", id)]:Kill()
	_G[format("ChatFrame%sBottomButton", id)]:Kill()
	
	-- Kill off editbox artwork
	local a, b, c = select(6, _G["ChatFrameEditBox"]:GetRegions()) a:Kill() b:Kill() c:Kill()

	-- Disable alt key usage
	_G["ChatFrameEditBox"]:SetAltArrowKeyMode(false)

	-- Hide editbox on login
	_G["ChatFrameEditBox"]:Hide()

	-- Script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G["ChatFrameEditBox"]:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G["ChatFrameEditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)

	-- Hide edit box every time we click on a tab
	_G[chat.."Tab"]:HookScript("OnClick", function() _G["ChatFrameEditBox"]:Hide() end)

	-- Create our own texture for edit box
	if C.chat.background == true and C.chat.tabs_mouseover ~= true then
		local EditBoxBackground = CreateFrame("Frame", "ChatEditBoxBackground", _G["ChatFrameEditBox"])
		EditBoxBackground:CreatePanel("Transparent", 1, 1, "LEFT", _G["ChatFrameEditBox"], "LEFT", 0, 0)
		EditBoxBackground:ClearAllPoints()
		EditBoxBackground:SetPoint("TOPLEFT", _G["ChatFrameEditBox"], "TOPLEFT", 7, -5)
		EditBoxBackground:SetPoint("BOTTOMRIGHT", _G["ChatFrameEditBox"], "BOTTOMRIGHT", -7, 4)
		EditBoxBackground:SetFrameStrata("LOW")
		EditBoxBackground:SetFrameLevel(1)

		local function colorize(r, g, b)
			EditBoxBackground:SetBackdropBorderColor(r, g, b)
		end

		-- Update border color according where we talk
		hooksecurefunc("ChatEdit_UpdateHeader", function()
			local chatType = _G["ChatFrameEditBox"]:GetAttribute("chatType")
			if not chatType then return end
			local chanTarget = _G[chat.."EditBox"]:GetAttribute("channelTarget")
			local chanName = chanTarget and GetChannelName(chanTarget)
			if chanName and chatType == "CHANNEL" then
				local id = GetChannelName(_G["ChatFrameEditBox"]:GetAttribute("channelTarget"))
				if chanName == 0 then
					colorize(unpack(C.media.border_color))
				else
					colorize(ChatTypeInfo[chatType..chanName].r, ChatTypeInfo[chatType..chanName].g, ChatTypeInfo[chatType..chanName].b)
				end
			else
				colorize(ChatTypeInfo[chatType].r, ChatTypeInfo[chatType].g, ChatTypeInfo[chatType].b)
			end
		end)
	end

	-- Rename combat log tab
	if _G[chat] == _G["ChatFrame2"] then
		FCF_SetWindowName(_G[chat], GUILD_BANK_LOG)
		CombatLogQuickButtonFrame_Custom:StripTextures()
		CombatLogQuickButtonFrame_Custom:CreateBackdrop("Transparent")
		CombatLogQuickButtonFrame_Custom.backdrop:SetPoint("TOPLEFT", 1, -4)
		CombatLogQuickButtonFrame_Custom.backdrop:SetPoint("BOTTOMRIGHT", -22, 0)
		T.SkinCloseButton(CombatLogQuickButtonFrame_CustomAdditionalFilterButton, CombatLogQuickButtonFrame_Custom.backdrop, "+", true)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton:SetSize(12, 12)
		CombatLogQuickButtonFrame_CustomAdditionalFilterButton:SetHitRectInsets (0, 0, 0, 0)
		CombatLogQuickButtonFrame_CustomProgressBar:ClearAllPoints()
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("TOPLEFT", CombatLogQuickButtonFrame_Custom.backdrop, 2, -2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("BOTTOMRIGHT", CombatLogQuickButtonFrame_Custom.backdrop, -2, 2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetStatusBarTexture(C.media.texture)
	end

	if _G[chat] ~= _G["ChatFrame2"] then
		origs[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
	end

	frame.skinned = true
end

-- Setup chatframes 1 to 10 on login
local function SetupChat(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
		frame:SetScript("OnMouseWheel", FloatingChatFrame_OnMouseScroll)
		frame:EnableMouseWheel(true)
	end

	-- Remember last channel
	local var
	if C.chat.sticky == true then
		var = 1
	else
		var = 0
	end
	ChatTypeInfo.SAY.sticky = var
	ChatTypeInfo.PARTY.sticky = var
	ChatTypeInfo.GUILD.sticky = var
	ChatTypeInfo.OFFICER.sticky = var
	ChatTypeInfo.RAID.sticky = var
	ChatTypeInfo.RAID_WARNING.sticky = var
	ChatTypeInfo.BATTLEGROUND.sticky = var
	ChatTypeInfo.BATTLEGROUND_LEADER.sticky = var
	ChatTypeInfo.WHISPER.sticky = var
	ChatTypeInfo.CHANNEL.sticky = var
end

local function SetupChatPosAndFont(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local _, fontSize = GetChatWindowInfo(id)

		-- Min. size for chat font
		if fontSize < 11 then
			chat:SetFont(C.font.chat_font, 11, C.font.chat_font_style)
		end

		-- Font and font style for chat
		chat:SetFont(C.font.chat_font, fontSize, C.font.chat_font_style)
		chat:SetShadowOffset(C.font.chat_font_shadow and 1 or 0, C.font.chat_font_shadow and -1 or 0)

		-- Force chat position
		if i == 1 then
			chat:ClearAllPoints()
			chat:SetSize(C.chat.width, C.chat.height)
			if C.chat.background == true then
				chat:SetPoint(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5] + 4)
			else
				chat:SetPoint(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5])
			end
		elseif i == 2 then
			if C.chat.combatlog ~= true then
				FCF_DockFrame(chat)
				ChatFrame2Tab:EnableMouse(false)
				-- ChatFrame2Tab:SetText("")
				-- ChatFrame2Tab.SetText = T.dummy
				ChatFrame2TabText:Hide()
				ChatFrame2Tab:SetWidth(0.001)
				ChatFrame2Tab.SetWidth = T.dummy
				FCF_DockUpdate()
			end
		end
	end
end

local UIChat = CreateFrame("Frame")
UIChat:RegisterEvent("ADDON_LOADED")
UIChat:RegisterEvent("PLAYER_ENTERING_WORLD")
UIChat:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		SetupChatPosAndFont(self)
	end
end)

----------------------------------------------------------------------------------------
--	Save slash command typo
----------------------------------------------------------------------------------------
local function TypoHistory_Posthook_AddMessage(chat, text)
	if strfind(text, HELP_TEXT_SIMPLE) then
		ChatEdit_AddHistory(chat.editBox)
	end
end

for i = 1, NUM_CHAT_WINDOWS do
	if i ~= 2 then
		hooksecurefunc(_G["ChatFrame"..i], "AddMessage", TypoHistory_Posthook_AddMessage)
	end
end