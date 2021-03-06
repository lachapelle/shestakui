﻿local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.loot.rolllootframe ~= true then return end

----------------------------------------------------------------------------------------
--	Based on teksLoot(by Tekkub)
----------------------------------------------------------------------------------------
local pos = "TOP"
local frames = {}
local cancelled_rolls = {}
local rolltypes = {"need", "greed", [0] = "pass"}

local LootRollAnchor = CreateFrame("Frame", "LootRollAnchor", UIParent)
LootRollAnchor:SetSize(313, 26)

local function ClickRoll(frame)
	RollOnLoot(frame.parent.rollID, frame.rolltype)
end

local function HideTip() GameTooltip:Hide() end
local function HideTip2() GameTooltip:Hide() ResetCursor() end

local function SetTip(frame)
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
	GameTooltip:SetText(frame.tiptext)
	if not frame:IsEnabled() then
		GameTooltip:AddLine("|cffff3333"..L_LOOT_CANNOT.."|r")
	end
	for name, roll in pairs(frame.parent.rolls) do if roll == rolltypes[frame.rolltype] then GameTooltip:AddLine(name, 1, 1, 1) end end
	GameTooltip:Show()
end

local function SetItemTip(frame)
	if not frame.link then return end
	GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
	GameTooltip:SetHyperlink(frame.link)
	if IsShiftKeyDown() then GameTooltip_ShowCompareItem() end
	if IsModifiedClick("DRESSUP") then ShowInspectCursor() else ResetCursor() end
end

local function ItemOnUpdate(frame)
	if GameTooltip:IsOwned(frame) then
		if IsShiftKeyDown() then
			GameTooltip_ShowCompareItem()
		else
			ShoppingTooltip1:Hide()
			ShoppingTooltip2:Hide()
		end

		if IsControlKeyDown() then
			ShowInspectCursor()
		else
			ResetCursor()
		end
	end
end

local function LootClick(frame)
	if IsControlKeyDown() then
		DressUpItemLink(frame.link)
	elseif IsShiftKeyDown() then
		local _, item = GetItemInfo(frame.link)
		if ChatEdit_GetActiveWindow() then
			ChatEdit_InsertLink(item)
		else
			ChatFrame_OpenChat(item)
		end
	end
end

local function OnEvent(frame, event, rollID)
	cancelled_rolls[rollID] = true
	if frame.rollID ~= rollID then return end

	frame.rollID = nil
	frame.time = nil
	frame:Hide()
end

local function StatusUpdate(frame)
	if not frame.parent.rollID then return end
	local t = GetLootRollTimeLeft(frame.parent.rollID)
	local perc = t / frame.parent.time
	frame:SetValue(t)
end

local function CreateRollButton(parent, ntex, ptex, htex, rolltype, tiptext, ...)
	local f = CreateFrame("Button", nil, parent)
	f:SetPoint(...)
	f:SetSize(28, 28)
	f:SetNormalTexture(ntex)
	if ptex then f:SetPushedTexture(ptex) end
	f:SetHighlightTexture(htex)
	f.rolltype = rolltype
	f.parent = parent
	f.tiptext = tiptext
	f:SetScript("OnEnter", SetTip)
	f:SetScript("OnLeave", HideTip)
	f:SetScript("OnClick", ClickRoll)
	-- f:SetMotionScriptsWhileDisabled(true)
	local txt = f:CreateFontString(nil, nil)
	txt:SetFont(C.font.loot_font, C.font.loot_font_size, C.font.loot_font_style)
	txt:SetShadowOffset(C.font.loot_font_shadow and 1 or 0, C.font.loot_font_shadow and -1 or 0)
	txt:SetPoint("CENTER", 0, rolltype == 2 and 1 or rolltype == 0 and -1.2 or 0)
	return f, txt
end

local function CreateRollFrame()
	local frame = CreateFrame("Frame", nil, UIParent)
	frame:CreateBackdrop("Default")
	frame:SetSize(280, 22)
	frame:SetFrameStrata("MEDIUM")
	frame:SetFrameLevel(10)
	frame:SetScript("OnEvent", OnEvent)
	frame:RegisterEvent("CANCEL_LOOT_ROLL")
	frame:Hide()

	local button = CreateFrame("Button", nil, frame)
	button:SetPoint("LEFT", -29, 0)
	button:SetSize(22, 22)
	button:CreateBackdrop("Default")
	button:SetScript("OnEnter", SetItemTip)
	button:SetScript("OnLeave", HideTip2)
	button:SetScript("OnUpdate", ItemOnUpdate)
	button:SetScript("OnClick", LootClick)
	frame.button = button

	button.icon = button:CreateTexture(nil, "OVERLAY")
	button.icon:SetAllPoints()
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	local status = CreateFrame("StatusBar", nil, frame)
	status:SetSize(326, 20)
	status:SetPoint("TOPLEFT", 0, 0)
	status:SetPoint("BOTTOMRIGHT", 0, 0)
	status:SetScript("OnUpdate", StatusUpdate)
	status:SetFrameLevel(status:GetFrameLevel() - 1)
	status:SetStatusBarTexture(C.media.texture)
	status:SetStatusBarColor(0.8, 0.8, 0.8, 0.9)
	status.parent = frame
	frame.status = status

	status.bg = status:CreateTexture(nil, "BACKGROUND")
	status.bg:SetAlpha(0.1)
	status.bg:SetAllPoints()
	status.bg:SetDrawLayer("BACKGROUND", 2)

	local need, needtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Dice-Up", "Interface\\Buttons\\UI-GroupLoot-Dice-Highlight", "Interface\\Buttons\\UI-GroupLoot-Dice-Down", 1, NEED, "LEFT", frame.button, "RIGHT", 5, -1)
	local greed, greedtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Coin-Up", "Interface\\Buttons\\UI-GroupLoot-Coin-Highlight", "Interface\\Buttons\\UI-GroupLoot-Coin-Down", 2, GREED, "LEFT", need, "RIGHT", 0, -1)
	local pass, passtext = CreateRollButton(frame, "Interface\\Buttons\\UI-GroupLoot-Pass-Up", nil, "Interface\\Buttons\\UI-GroupLoot-Pass-Down", 0, PASS, "LEFT", greed, "RIGHT", 0, 2.2)
	frame.needbutt, frame.greedbutt = need, greed
	frame.need, frame.greed, frame.pass = needtext, greedtext, passtext

	local bind = frame:CreateFontString()
	bind:SetPoint("LEFT", pass, "RIGHT", 3, 1)
	bind:SetFont(C.font.loot_font, C.font.loot_font_size, C.font.loot_font_style)
	bind:SetShadowOffset(C.font.loot_font_shadow and 1 or 0, C.font.loot_font_shadow and -1 or 0)
	frame.fsbind = bind

	local loot = frame:CreateFontString(nil, "ARTWORK")
	loot:SetFont(C.font.loot_font, C.font.loot_font_size, C.font.loot_font_style)
	loot:SetShadowOffset(C.font.loot_font_shadow and 1 or 0, C.font.loot_font_shadow and -1 or 0)
	loot:SetPoint("LEFT", bind, "RIGHT", 0, 0)
	loot:SetPoint("RIGHT", frame, "RIGHT", -5, 0)
	loot:SetSize(200, 10)
	loot:SetJustifyH("LEFT")
	frame.fsloot = loot

	frame.rolls = {}

	return frame
end

local function GetFrame()
	for i, f in ipairs(frames) do
		if not f.rollID then return f end
	end

	local f = CreateRollFrame()
	if pos == "TOP" then
		f:SetPoint("TOPRIGHT", next(frames) and frames[#frames] or LootRollAnchor, "BOTTOMRIGHT", next(frames) and 0 or -2, next(frames) and -7 or -5)
	else
		f:SetPoint("BOTTOMRIGHT", next(frames) and frames[#frames] or LootRollAnchor, "TOPRIGHT", next(frames) and 0 or -2, next(frames) and 7 or 5)
	end
	table.insert(frames, f)
	return f
end

local function START_LOOT_ROLL(rollID, time)
	if cancelled_rolls[rollID] then return end

	local f = GetFrame()
	f.rollID = rollID
	f.time = time
	for i in pairs(f.rolls) do f.rolls[i] = nil end
	f.need:SetText(0)
	f.greed:SetText(0)
	f.pass:SetText(0)

	local texture, name, count, quality, bop = GetLootRollItemInfo(rollID)
	f.button.icon:SetTexture(texture)
	f.button.link = GetLootRollItemLink(rollID)

	if C.loot.auto_greed and T.level == MAX_PLAYER_LEVEL and quality == 2 and not bop then return end

	f.needbutt:Enable()
	f.needbutt:SetAlpha(1)

	f.greedbutt:Enable()
	f.greedbutt:SetAlpha(1)

	f.fsbind:SetText(bop and "BoP" or "BoE")
	f.fsbind:SetVertexColor(bop and 1 or 0.3, bop and 0.3 or 1, bop and 0.1 or 0.3)

	local color = ITEM_QUALITY_COLORS[quality]
	f.fsloot:SetText(name)
	f.fsloot:SetVertexColor(color.r, color.g, color.b)

	f.status:SetStatusBarColor(color.r, color.g, color.b, 0.7)
	f.status.bg:SetTexture(color.r, color.g, color.b)

	f.backdrop:SetBackdropBorderColor(color.r, color.g, color.b, 0.7)
	f.button.backdrop:SetBackdropBorderColor(color.r, color.g, color.b, 0.7)

	f.status:SetMinMaxValues(0, time)
	f.status:SetValue(time)

	f:SetPoint("CENTER", WorldFrame, "CENTER")
	f:Show()
end

local locale = GetLocale()
local rollpairs = locale == "deDE" and {
	["(.*) passt automatisch bei (.+), weil [ersie]+ den Gegenstand nicht benutzen kann.$"] = "pass",
	["(.*) würfelt nicht für: (.+|r)$"] = "pass",
	["(.*) hat für (.+) 'Gier' ausgewählt"] = "greed",
	["(.*) hat für (.+) 'Bedarf' ausgewählt"] = "need",
} or locale == "frFR" and {
	["(.*) a passé pour : (.+) parce qu'((il)|(elle)) ne peut pas ramasser cette objet.$"] = "pass",
	["(.*) a passé pour : (.+)"] = "pass",
	["(.*) a choisi Cupidité pour : (.+)"] = "greed",
	["(.*) a choisi Besoin pour : (.+)"] = "need",
} or locale == "zhTW" and {
	["(.*)自動放棄:(.+)，因為他無法拾取該物品$"]  = "pass",
	["(.*)自動放棄:(.+)，因為她無法拾取該物品$"]  = "pass",
	["(.*)放棄了:(.+)"] = "pass",
	["(.*)選擇了貪婪:(.+)"] = "greed",
	["(.*)選擇了需求:(.+)"] = "need",
} or locale == "zhCN" and {
	["(.*)自动放弃了(.+)，因为他无法拾取该物品。$"] = "pass",
	["(.*)放弃了：(.+)"] = "pass",
	["(.*)选择了贪婪取向：(.+)"] = "greed",
	["(.*)选择了需求取向：(.+)"] = "need",
} or locale == "ruRU" and {
	["(.*) автоматически передает предмет (.+), поскольку не может его забрать"] = "pass",
	["(.*) пропускает розыгрыш предмета \"(.+)\", поскольку не может его забрать"] = "pass",
	["(.*) отказывается от предмета (.+)%."] = "pass",
	["Разыгрывается: (.+)%. (.*): \"Не откажусь\""] = "greed",
	["Разыгрывается: (.+)%. (.*): \"Мне это нужно\""] = "need",
} or locale == "koKR" and {
	["(.*)님이 획득할 수 없는 아이템이어서 자동으로 주사위 굴리기를 포기했습니다: (.+)"] = "pass",
	["(.*)님이 주사위 굴리기를 포기했습니다: (.+)"] = "pass",
	["(.*)님이 차비를 선택했습니다: (.+)"] = "greed",
	["(.*)님이 입찰을 선택했습니다: (.+)"] = "need",
} or (locale == "esES" or locale == "esMX") and {
	["^(.*) pasó automáticamente de: (.+) porque no puede despojar este objeto.$"] = "pass",
	["^(.*) pasó de: (.+|r)$"]  = "pass",
	["(.*) eligió Codicia para: (.+)"] = "greed",
	["(.*) eligió Necesidad para: (.+)"]  = "need",
} or locale == "ptBR" and {
	["^(.*) abdicou de (.+) automaticamente porque não pode saquear o item.$"] = "pass",
	["^(.*) dispensou: (.+|r)$"] = "pass",
	["(.*) selecionou Ganância para: (.+)"] = "greed",
	["(.*) escolheu Necessidade para: (.+)"] = "need",
} or {
	["^(.*) automatically passed on: (.+) because s?he cannot loot that item.$"] = "pass",
	["^(.*) passed on: (.+|r)$"] = "pass",
	["(.*) has selected Greed for: (.+)"] = "greed",
	["(.*) has selected Need for: (.+)"] = "need",
}

local function ParseRollChoice(msg)
	for i,v in pairs(rollpairs) do
		local _, _, playername, itemname = string.find(msg, i)
		if locale == "ruRU" and (v == "greed" or v == "need") then 
			local temp = playername
			playername = itemname
			itemname = temp
		end 
		if playername and itemname and playername ~= "Everyone" then return playername, itemname, v end
	end
end

local function CHAT_MSG_LOOT(msg)
	local playername, itemname, rolltype = ParseRollChoice(msg)
	if playername and itemname and rolltype then
		for _,f in ipairs(frames) do
			if f.rollID and f.button.link == itemname and not f.rolls[playername] then
				f.rolls[playername] = rolltype
				f[rolltype]:SetText(tonumber(f[rolltype]:GetText()) + 1)
				return
			end
		end
	end
end

LootRollAnchor:RegisterEvent("ADDON_LOADED")
LootRollAnchor:SetScript("OnEvent", function(frame, event, addon)
	if addon ~= "ShestakUI" then return end

	LootRollAnchor:UnregisterEvent("ADDON_LOADED")
	LootRollAnchor:RegisterEvent("START_LOOT_ROLL")
	LootRollAnchor:RegisterEvent("CHAT_MSG_LOOT")

	UIParent:UnregisterEvent("START_LOOT_ROLL")
	UIParent:UnregisterEvent("CANCEL_LOOT_ROLL")

	LootRollAnchor:SetScript("OnEvent", function(frame, event, ...)
		if event == "CHAT_MSG_LOOT" then
			return CHAT_MSG_LOOT(...)
		else
			return START_LOOT_ROLL(...)
		end
	end)

	LootRollAnchor:SetPoint(unpack(C.position.group_loot))
end)

SlashCmdList.TESTROLL = function()
	local f = GetFrame()
	local items = {32837, 34196, 33820, 29789}
	if f:IsShown() then
		f:Hide()
	else
		local item = items[math.random(1, #items)]
		local _, _, quality, _, _, _, _, _, _, texture = GetItemInfo(item)
		local r, g, b = GetItemQualityColor(quality or 1)

		f.button.icon:SetTexture(texture)
		f.button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

		f.fsloot:SetText(GetItemInfo(item))
		f.fsloot:SetVertexColor(r, g, b)

		f.status:SetMinMaxValues(0, 100)
		f.status:SetValue(math.random(50, 90))
		f.status:SetStatusBarColor(r, g, b, 0.7)
		f.status.bg:SetTexture(r, g, b)

		f.backdrop:SetBackdropBorderColor(r, g, b, 0.7)
		f.button.backdrop:SetBackdropBorderColor(r, g, b, 0.7)

		f.need:SetText(0)
		f.greed:SetText(0)
		f.pass:SetText(0)

		f.button.link = "item:"..item..":0:0:0:0:0:0:0"
		f:Show()
	end
end
SLASH_TESTROLL1 = "/testroll"
SLASH_TESTROLL2 = "/еуыекщдд"