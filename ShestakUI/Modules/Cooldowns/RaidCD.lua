local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.raidcooldown.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Raid cooldowns (alRaidCD by Allez, msylgj0@NGACN)
----------------------------------------------------------------------------------------
local show = {
	raid = C.raidcooldown.show_inraid,
	party = C.raidcooldown.show_inparty,
	arena = C.raidcooldown.show_inarena,
}

local filter = COMBATLOG_OBJECT_AFFILIATION_RAID + COMBATLOG_OBJECT_AFFILIATION_PARTY + COMBATLOG_OBJECT_AFFILIATION_MINE
local band = bit.band
local sformat = string.format
local floor = math.floor
local inBossCombat = nil
local timer = 0
local bars = {}

local RaidCDAnchor = CreateFrame("Frame", "RaidCDAnchor", UIParent)
RaidCDAnchor:SetPoint(unpack(C.position.raid_cooldown))
if C.raidcooldown.show_icon == true then
	RaidCDAnchor:SetSize(C.raidcooldown.width + 32, C.raidcooldown.height + 10)
else
	RaidCDAnchor:SetSize(C.raidcooldown.width + 32, C.raidcooldown.height + 4)
end

local FormatTime = function(time)
	if time >= 60 then
		return sformat("%.2d:%.2d", floor(time / 60), time % 60)
	else
		return sformat("%.2d", time)
	end
end

local function sortByExpiration(a, b)
	return a.endTime > b.endTime
end

local CreateFS = function(frame, fsize, fstyle)
	local fstring = frame:CreateFontString(nil, "OVERLAY")
	fstring:SetFont(C.font.raid_cooldowns_font, C.font.raid_cooldowns_font_size, C.font.raid_cooldowns_font_style)
	fstring:SetShadowOffset(C.font.raid_cooldowns_font_shadow and 1 or 0, C.font.raid_cooldowns_font_shadow and -1 or 0)
	return fstring
end

local UpdatePositions = function()
	for i = 1, #bars do
		bars[i]:ClearAllPoints()
		if i == 1 then
			bars[i]:SetPoint("TOPRIGHT", RaidCDAnchor, "TOPRIGHT", 0, 0)
		else
			if C.raidcooldown.upwards == true then
				bars[i]:SetPoint("BOTTOMRIGHT", bars[i-1], "TOPRIGHT", 0, 13)
			else
				bars[i]:SetPoint("TOPRIGHT", bars[i-1], "BOTTOMRIGHT", 0, -13)
			end
		end
		bars[i].id = i
	end
end

local StopTimer = function(bar)
	bar:SetScript("OnUpdate", nil)
	bar:Hide()
	table.remove(bars, bar.id)
	UpdatePositions()
end

local BarUpdate = function(self, elapsed)
	local curTime = GetTime()
	if self.endTime < curTime then
		StopTimer(self)
		return
	end
	self:SetValue(100 - (curTime - self.startTime) / (self.endTime - self.startTime) * 100)
	self.right:SetText(FormatTime(self.endTime - curTime))
end

local OnEnter = function(self)
	GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
	-- GameTooltip:SetSpellByID(self.spellId)
	GameTooltip:AddLine(GetSpellInfo(self.spellId))
	GameTooltip:AddLine(" ")
	GameTooltip:AddDoubleLine(self.left:GetText(), self.right:GetText())
	GameTooltip:SetClampedToScreen(true)
	GameTooltip:Show()
end

local OnLeave = function(self)
	GameTooltip:Hide()
end

local OnMouseDown = function(self, button)
	if button == "LeftButton" then
		SendChatMessage(sformat(L_COOLDOWNS.."%s - %s: %s", self.name, GetSpellLink(self.spellId), self.right:GetText()), T.CheckChat())
	elseif button == "RightButton" then
		StopTimer(self)
	end
end

local CreateBar = function()
	local bar = CreateFrame("Statusbar", nil, UIParent)
	bar:SetFrameStrata("MEDIUM")
	if C.raidcooldown.show_icon == true then
		bar:SetSize(C.raidcooldown.width, C.raidcooldown.height)
	else
		bar:SetSize(C.raidcooldown.width + 28, C.raidcooldown.height)
	end
	bar:SetStatusBarTexture(C.media.texture)
	bar:SetMinMaxValues(0, 100)
	bar:CreateBackdrop("Default")

	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture(C.media.texture)

	bar.left = CreateFS(bar)
	bar.left:SetPoint("LEFT", 2, 0)
	bar.left:SetJustifyH("LEFT")
	bar.left:SetSize(C.raidcooldown.width - 30, C.font.raid_cooldowns_font_size)

	bar.right = CreateFS(bar)
	bar.right:SetPoint("RIGHT", -1, 0)
	bar.right:SetJustifyH("RIGHT")

	if C.raidcooldown.show_icon == true then
		bar.icon = CreateFrame("Button", nil, bar)
		bar.icon:SetWidth(bar:GetHeight() + 6)
		bar.icon:SetHeight(bar.icon:GetWidth())
		bar.icon:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT", -7, 0)
		bar.icon:CreateBackdrop("Default")
	end
	return bar
end

local StartTimer = function(name, spellId)
	local spell, _, icon = GetSpellInfo(spellId)
	for _, v in pairs(bars) do
		if v.name == name and v.spell == spell then
			StopTimer(v)
		end
	end
	local bar = CreateBar()
	local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2, UnitClass(name))]
	bar.startTime = GetTime()
	bar.endTime = GetTime() + T.raid_spells[spellId]
	bar.left:SetText(format("%s - %s", name:gsub("%-[^|]+", ""), spell))
	bar.right:SetText(FormatTime(T.raid_spells[spellId]))
	bar.name = name
	bar.spell = spell
	bar.spellId = spellId
	if C.raidcooldown.show_icon == true then
		bar.icon:SetNormalTexture(icon)
		bar.icon:GetNormalTexture():SetTexCoord(0.1, 0.9, 0.1, 0.9)
	end
	bar:Show()
	if color then
		bar:SetStatusBarColor(color.r, color.g, color.b)
		bar.bg:SetVertexColor(color.r, color.g, color.b, 0.2)
	else
		bar:SetStatusBarColor(0.3, 0.7, 0.3)
		bar.bg:SetVertexColor(0.3, 0.7, 0.3, 0.2)
	end

	bar:SetScript("OnUpdate", BarUpdate)
	bar:EnableMouse(true)
	bar:SetScript("OnEnter", OnEnter)
	bar:SetScript("OnLeave", OnLeave)
	bar:SetScript("OnMouseDown", OnMouseDown)
	table.insert(bars, bar)
	if C.raidcooldown.expiration == true then
		table.sort(bars, sortByExpiration)
	end
	UpdatePositions()
end

local OnEvent = function(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, eventType, _, sourceName, sourceFlags = ...
		if band(sourceFlags, filter) == 0 then return end
		if eventType == "SPELL_RESURRECT" or eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" then
			local spellId = select(12, ...)
			if sourceName then
				sourceName = sourceName:gsub("-.+", "")
			else
				return
			end
			if T.raid_spells[spellId] and show[select(2, IsInInstance())] and (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) then
				if (sourceName == T.name and C.raidcooldown.show_self == true) or sourceName ~= T.name then
					StartTimer(sourceName, spellId)
				end
			end
		end
	elseif event == "ZONE_CHANGED_NEW_AREA" and select(2, IsInInstance()) == "arena" or not (GetNumPartyMembers() > 0 or GetNumRaidMembers() > 0) then
		for _, v in pairs(bars) do
			v.endTime = 0
		end
	elseif event == "ENCOUNTER_END" and select(2, IsInInstance()) == "raid" then
		for _, v in pairs(bars) do
			v.endTime = 0
		end
	end
end

for spell in pairs(T.raid_spells) do
	local name = GetSpellInfo(spell)
	if not name then
		print("|cffff0000WARNING: spell ID ["..tostring(spell).."] no longer exists! Report this to Shestak.|r")
	end
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", OnEvent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:RegisterEvent("ZONE_CHANGED_NEW_AREA")
f:RegisterEvent("ENCOUNTER_END")

SlashCmdList.RaidCD = function()
	StartTimer(UnitName("player"), 20484)	-- Rebirth
	StartTimer(UnitName("player"), 740)		-- Tranquility
	StartTimer(UnitName("player"), 29166)	-- Innervate
end
SLASH_RaidCD1 = "/raidcd"
SLASH_RaidCD2 = "/кфшвсв"