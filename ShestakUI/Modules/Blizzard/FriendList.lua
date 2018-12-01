if IsAddOnLoaded("yClassColor") then return end

----------------------------------------------------------------------------------------
--	Class color guild/friends/etc list (yClassColor by Yleaf)
----------------------------------------------------------------------------------------
local GUILD_INDEX_MAX = 12
local SMOOTH = {1, 0, 0, 1, 1, 0, 0, 1, 0}
local myName = UnitName("player")
--[[
local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end
--]]
local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS
local WHITE_HEX = "|cffffffff"

local function Hex(r, g, b)
	if type(r) == "table" then
		if (r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end

	if not r or not g or not b then
		r, g, b = 1, 1, 1
	end

	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end

	local num = select("#", ...) / 3

	local segment, relperc = modf(perc * (num - 1))
	local r1, g1, b1, r2, g2, b2 = select((segment * 3) + 1, ...)

	return r1 + (r2 - r1) * relperc, g1 + (g2 - g1) * relperc, b1 + (b2 - b1) * relperc
end

local guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			local c = Hex(ColorGradient(i / GUILD_INDEX_MAX, unpack(SMOOTH)))
			if c then
				t[i] = c
				return c
			else
				t[i] = t[0]
			end
		end
	end
})
guildRankColor[0] = WHITE_HEX

local diffColor = setmetatable({}, {
	__index = function(t, i)
		local c = i and GetQuestDifficultyColor(i)
		t[i] = c and Hex(c) or t[0]
		return t[i]
	end
})
diffColor[0] = WHITE_HEX

local classColor = setmetatable({}, {
	__index = function(t, i)
		-- local c = i and RAID_CLASS_COLORS[BC[i] or i]
		local c = i
		if c then
			t[i] = Hex(c)
			return t[i]
		else
			return WHITE_HEX
		end
	end
})

local WHITE = {1, 1, 1}
local classColorRaw = setmetatable({}, {
	__index = function(t, i)
		-- local c = i and RAID_CLASS_COLORS[BC[i] or i]
		local c = i
		if not c then return WHITE end
		t[i] = c
		return c
	end
})

if CUSTOM_CLASS_COLORS then
	CUSTOM_CLASS_COLORS:RegisterCallback(function()
		wipe(classColorRaw)
		wipe(classColor)
	end)
end

-- WhoList
hooksecurefunc("WhoList_Update", function()
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)

	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo("player")
	local playerRace = UnitRace("player")

	for i = 1, WHOS_TO_DISPLAY, 1 do
		local index = whoOffset + i
		local nameText = _G["WhoFrameButton"..i.."Name"]
		local levelText = _G["WhoFrameButton"..i.."Level"]
		local classText = _G["WhoFrameButton"..i.."Class"]
		local variableText = _G["WhoFrameButton"..i.."Variable"]

		local name, guild, level, race, class, zone, classFileName = GetWhoInfo(index)
		if name then
			if zone == playerZone then
				zone = "|cff00ff00"..zone
			end
			if guild == playerGuild then
				guild = "|cff00ff00"..guild
			end
			if race == playerRace then
				race = "|cff00ff00"..race
			end
			local columnTable = {zone, guild, race}

			local c = classColorRaw[classFileName]
			nameText:SetTextColor(c.r, c.g, c.b)
			levelText:SetText(diffColor[level]..level)
			variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
		end
	end
end)

--[[
-- LFRBrowseList
hooksecurefunc("LFMFrame_Update", function(button, index)
	local name, level, class = GetLFGResults(index)

	if index and class and name and level then
		button.name:SetText(classColor[class]..name)
		button.class:SetText(classColor[class]..class)
		button.level:SetText(diffColor[level]..level)
		button.level:SetWidth(30)
	end
end)
--]]

-- WorldStateScoreList
hooksecurefunc("WorldStateScoreFrame_Update", function()
	local inArena = IsActiveBattlefieldArena()
	local offset = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame)

	-- for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
	for i = 1, GetNumBattlefieldScores() do
		local index = offset + i
		local name, _, _, _, _, faction, _, _, class = GetBattlefieldScore(index)
		if name then
			local n, r = strsplit("-", name, 2)
			n = classColor[class]..n.."|r"

			if name == myName then
				n = ">>> "..n.." <<<"
			end

			if r then
				local color
				if inArena then
					if faction == 1 then
						color = "|cffffd100"
					else
						color = "|cff19ff19"
					end
				else
					if faction == 1 then
						color = "|cff00adf0"
					else
						color = "|cffff1919"
					end
				end
				r = color..r.."|r"
				n = n.."|cffffffff - |r"..r
			end

			local button = _G["WorldStateScoreButton"..i]
			button.name.text:SetText(n)
		end
	end
end)

local _VIEW

local function viewChanged(view)
	_VIEW = view
end

-- GuildList
local function guildFrame()
	local playerArea = GetRealZoneText()
	
	if ( FriendsFrame.playerStatusFrame ) then
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		local guildIndex
		
		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(guildIndex)
			if not name then return end
			if online then
				local nameText = getglobal('GuildFrameButton'..i..'Name')
				local zoneText = getglobal('GuildFrameButton'..i..'Zone')
				local levelText = getglobal('GuildFrameButton'..i..'Level')
				local classText = getglobal('GuildFrameButton'..i..'Class')
				
				nameText:SetVertexColor(unpack(classColors[class]))
				if playerArea == zone then
					zoneText:SetFormattedText('|cff00ff00%s|r', zone)
				end
				levelText:SetText(diffColor[level] .. level)
			end
		end
	else
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		local guildIndex
		
		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(guildIndex)
			if not name then return end
			if online then
				local nameText = getglobal('GuildFrameGuildStatusButton'..i..'Name')
				nameText:SetVertexColor(unpack(classColors[class]))
				
				local rankText = getglobal('GuildFrameGuildStatusButton'..i..'Rank')
				rankText:SetVertexColor(unpack(guildRankColor[rankIndex]))
			end
		end
	end
end
hooksecurefunc("GuildStatus_Update", guildFrame)

--[[
-- FriendsList
local WHITE = {r = 1, g = 1, b = 1}
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s")
local function friendsFrame()
	local scrollFrame = FriendsFrameFriendsScrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	local playerArea = GetRealZoneText()

	for i = 1, #buttons do
		local nameText, infoText
		button = buttons[i]
		index = offset + i
		if button:IsShown() then
			if button.buttonType == FRIENDS_BUTTON_TYPE_WOW then
				local name, level, class, area, connected = GetFriendInfo(button.id)
				if connected then
					nameText = classColor[class]..name.."|r, "..format(FRIENDS_LEVEL_TEMPLATE, diffColor[level]..level.."|r", class)
					if area == playerArea then
						infoText = format("|cff00ff00%s|r", area)
					end
				end
			end
		end

		if nameText then
			button.name:SetText(nameText)
		end
		if infoText then
			button.info:SetText(infoText)
		end
	end
end
-- hooksecurefunc(FriendsFrameFriendsScrollFrame, "buttonFunc", friendsFrame)
hooksecurefunc("FriendsList_Update", friendsFrame)
--]]