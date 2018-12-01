local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Number value function
----------------------------------------------------------------------------------------
T.Round = function(number, decimals)
	if not decimals then decimals = 0 end
	return (("%%.%df"):format(decimals)):format(number)
end

T.ShortValue = function(value)
	if value >= 1e11 then
		return ("%.0fb"):format(value / 1e9)
	elseif value >= 1e10 then
		return ("%.1fb"):format(value / 1e9):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e9 then
		return ("%.2fb"):format(value / 1e9):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e8 then
		return ("%.0fm"):format(value / 1e6)
	elseif value >= 1e7 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e6 then
		return ("%.2fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e5 then
		return ("%.0fk"):format(value / 1e3)
	elseif value >= 1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

T.RGBToHex = function(r, g, b)
	r = tonumber(r) <= 1 and tonumber(r) >= 0 and tonumber(r) or 0
	g = tonumber(g) <= tonumber(g) and tonumber(g) >= 0 and tonumber(g) or 0
	b = tonumber(b) <= 1 and tonumber(b) >= 0 and tonumber(b) or 0
	return format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end

----------------------------------------------------------------------------------------
--	Chat channel check
----------------------------------------------------------------------------------------
T.CheckChat = function(warning)
	local _, instanceType = IsInInstance()
	if IsInInstance then
		if instanceType == "pvp" then
			return "BATTLEGROUND"
		elseif instanceType == "raid" then
			if warning and (IsRaidLeader() or IsRaidOfficer()) then
				return "RAID_WARNING"
			else
				return "RAID"
			end
		else
			return "PARTY"
		end
	end
	return "SAY"
end

----------------------------------------------------------------------------------------
--	Player's role check
----------------------------------------------------------------------------------------
local function CheckRole(self, event, unit)
	if event == "UNIT_AURA" and unit ~= "player" then return end
	if (T.Class == "PALADIN" and T.CheckPlayerBuff(25780)) and GetCombatRatingBonus(CR_DEFENSE_SKILL) > 50 or
	(T.Class == "WARRIOR" and GetBonusBarOffset() == 2) or
	(T.Class == "DRUID" and GetBonusBarOffset() == 3) then
		T.Role = "Tank"
	else
		local playerint = select(2, UnitStat("player", 4))
		local playeragi	= select(2, UnitStat("player", 2))
		local base, posBuff, negBuff = UnitAttackPower("player")
		local rbase, rposBuff, rnegBuff = UnitRangedAttackPower("player")
		local playerap = base + posBuff + negBuff
		local playerrap = rbase + rposBuff + rnegBuff

		if (playerap > playerrap) and (playerap > playerint) then
			T.Role = "Melee"
		elseif ((playerap < playerrap) and (playerrap > playerint)) or (playeragi > playerint) then
			T.Role = "Ranged"
		else
			T.Role = "Caster"
		end
	end
end
local RoleUpdater = CreateFrame("Frame")
RoleUpdater:RegisterEvent("PLAYER_ENTERING_WORLD")
RoleUpdater:RegisterEvent("PLAYER_TALENT_UPDATE")
RoleUpdater:RegisterEvent("CHARACTER_POINTS_CHANGED")
RoleUpdater:RegisterEvent("UNIT_INVENTORY_CHANGED")
RoleUpdater:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
RoleUpdater:SetScript("OnEvent", CheckRole)

----------------------------------------------------------------------------------------
--	Player's talent check
----------------------------------------------------------------------------------------
T.CheckForKnownTalent = function(spellid)
	local wanted_name = GetSpellInfo(spellid)
	if not wanted_name then return nil end
	local num_tabs = GetNumTalentTabs()
	for t = 1, num_tabs do
		local num_talents = GetNumTalents(t)
		for i = 1, num_talents do
			local name_talent, _, _, _, current_rank = GetTalentInfo(t, i)
			if name_talent and name_talent == wanted_name then
				if current_rank and current_rank > 0 then
					return true
				else
					return false
				end
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------------
--	Player's buff check
----------------------------------------------------------------------------------------
T.CheckPlayerBuff = function(spell)
	for i = 1, BUFF_MAX_DISPLAY do
		local buffIndex = GetPlayerBuff(i)
		if buffIndex ~= 0 then
			if type(spell) == "number" then
				spell = GetSpellInfo(spell)
			end
			if spell == GetPlayerBuffName(buffIndex) then
				return true, i
			end
		end
	end
	return false
end

----------------------------------------------------------------------------------------
--	UTF functions
----------------------------------------------------------------------------------------
T.UTF = function(string, i, dots)
	if not string then return end
	local bytes = string:len()
	if bytes <= i then
		return string
	else
		local len, pos = 0, 1
		while (pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 0 and c <= 127 then
				pos = pos + 1
			elseif c >= 192 and c <= 223 then
				pos = pos + 2
			elseif c >= 224 and c <= 239 then
				pos = pos + 3
			elseif c >= 240 and c <= 247 then
				pos = pos + 4
			end
			if len == i then break end
		end
		if len == i and pos <= bytes then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end

----------------------------------------------------------------------------------------
--	Style functions
----------------------------------------------------------------------------------------
T.SkinFuncs = {}
T.SkinFuncs["ShestakUI"] = {}

function T.SkinScrollBar(frame, parent)
	if frame:GetName() then
		if _G[frame:GetName().."BG"] then
			_G[frame:GetName().."BG"]:SetTexture(nil)
		end
		if _G[frame:GetName().."Track"] then
			_G[frame:GetName().."Track"]:SetTexture(nil)
		end
		if _G[frame:GetName().."Top"] then
			_G[frame:GetName().."Top"]:SetTexture(nil)
		end
		if _G[frame:GetName().."Bottom"] then
			_G[frame:GetName().."Bottom"]:SetTexture(nil)
		end
		if _G[frame:GetName().."Middle"] then
			_G[frame:GetName().."Middle"]:SetTexture(nil)
		end
	end

	if frame.Background then frame.Background:SetTexture(nil) end
	if frame.trackBG then frame.trackBG:SetTexture(nil) end
	if frame.Middle then frame.Middle:SetTexture(nil) end
	if frame.Top then frame.Top:SetTexture(nil) end
	if frame.Bottom then frame.Bottom:SetTexture(nil) end
	if frame.ScrollBarTop then frame.ScrollBarTop:SetTexture(nil) end
	if frame.ScrollBarBottom then frame.ScrollBarBottom:SetTexture(nil) end
	if frame.ScrollBarMiddle then frame.ScrollBarMiddle:SetTexture(nil) end

	local UpButton = frame.ScrollUpButton or frame.UpButton or _G[(frame:GetName() or parent).."ScrollUpButton"]
	local DownButton = frame.ScrollDownButton or frame.DownButton or _G[(frame:GetName() or parent).."ScrollDownButton"]
	local ThumbTexture = frame.ThumbTexture or frame.thumbTexture or _G[frame:GetName().."ThumbTexture"]

	if UpButton and DownButton then
		if not UpButton.icon then
			T.SkinNextPrevButton(UpButton, nil, "Up")
			UpButton:SetSize(UpButton:GetWidth() + 6, UpButton:GetHeight() + 8)
		end

		if not DownButton.icon then
			T.SkinNextPrevButton(DownButton, nil, "Down")
			DownButton:SetSize(DownButton:GetWidth() + 6, DownButton:GetHeight() + 8)
		end

		if ThumbTexture then
			ThumbTexture:SetTexture(nil)
			if not frame.thumbbg then
				frame.thumbbg = CreateFrame("Frame", nil, frame)
				frame.thumbbg:SetPoint("TOPLEFT", ThumbTexture, "TOPLEFT", 0, -3)
				frame.thumbbg:SetPoint("BOTTOMRIGHT", ThumbTexture, "BOTTOMRIGHT", 0, 3)
				frame.thumbbg:SetTemplate("Overlay")

				frame:HookScript("OnShow", function()
					local _, maxValue = frame:GetMinMaxValues()
					if maxValue == 0 then
						frame:SetAlpha(0)
					else
						frame:SetAlpha(1)
					end
				end)

				--[[
				frame:HookScript("OnMinMaxChanged", function()
					local _, maxValue = frame:GetMinMaxValues()
					if maxValue == 0 then
						frame:SetAlpha(0)
					else
						frame:SetAlpha(1)
					end
				end)
				--]]

				--[[
				frame:HookScript("OnDisable", function()
					frame:SetAlpha(0)
				end)
				--]]

				--[[
				frame:HookScript("OnEnable", function()
					frame:SetAlpha(1)
				end)
				--]]
			end
		end
	end
end

local tabs = {
	"LeftDisabled",
	"MiddleDisabled",
	"RightDisabled",
	"Left",
	"Middle",
	"Right",
}

function T.SkinTab(tab, bg)
	if not tab then return end

	for _, object in pairs(tabs) do
		local tex = _G[tab:GetName()..object]
		if tex then
			tex:SetTexture(nil)
		end
	end

	if tab.GetHighlightTexture and tab:GetHighlightTexture() then
		tab:GetHighlightTexture():SetTexture(nil)
	else
		tab:StripTextures()
	end

	tab.backdrop = CreateFrame("Frame", nil, tab)
	tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
	if bg then
		tab.backdrop:SetTemplate("Overlay")
		tab.backdrop:SetPoint("TOPLEFT", 3, -7)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -3, 2)
	else
		tab.backdrop:SetTemplate("Transparent")
		tab.backdrop:SetPoint("TOPLEFT", 10, -3)
		tab.backdrop:SetPoint("BOTTOMRIGHT", -10, 3)
	end
end

function T.SkinNextPrevButton(btn, left, scroll)
	local normal, pushed, disabled
	local isPrevButton = btn:GetName() and (strfind(btn:GetName(), "Left") or strfind(btn:GetName(), "Prev") or strfind(btn:GetName(), "Decrement") or strfind(btn:GetName(), "Back")) or left
	local isScrollUpButton = btn:GetName() and strfind(btn:GetName(), "ScrollUp") or scroll == "Up"
	local isScrollDownButton = btn:GetName() and strfind(btn:GetName(), "ScrollDown") or scroll == "Down"

	if btn:GetNormalTexture() then
		normal = btn:GetNormalTexture():GetTexture()
	end

	if btn:GetPushedTexture() then
		pushed = btn:GetPushedTexture():GetTexture()
	end

	if btn:GetDisabledTexture() then
		disabled = btn:GetDisabledTexture():GetTexture()
	end

	btn:StripTextures()

	if scroll == "Up" or scroll == "Down" then
		normal = nil
		pushed = nil
		disabled = nil
	end

	if not normal then
		if isPrevButton then
			normal = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up"
		elseif isScrollUpButton then
			normal = "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Up"
		elseif isScrollDownButton then
			normal = "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up"
		else
			normal = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up"
		end
	end

	if not pushed then
		if isPrevButton then
			pushed = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down"
		elseif isScrollUpButton then
			pushed = "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Down"
		elseif isScrollDownButton then
			pushed = "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down"
		else
			pushed = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down"
		end
	end

	if not disabled then
		if isPrevButton then
			disabled = "Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled"
		elseif isScrollUpButton then
			disabled = "Interface\\ChatFrame\\UI-ChatIcon-ScrollUp-Disabled"
		elseif isScrollDownButton then
			disabled = "Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Disabled"
		else
			disabled = "Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled"
		end
	end

	btn:SetNormalTexture(normal)
	btn:SetPushedTexture(pushed)
	btn:SetDisabledTexture(disabled)

	btn:SetTemplate("Overlay")
	btn:SetSize(btn:GetWidth() - 6, btn:GetHeight() - 6)

	if normal and pushed and disabled then
		btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.81, 0.65, 0.29, 0.65, 0.81)
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetTexCoord(0.3, 0.35, 0.3, 0.81, 0.65, 0.35, 0.65, 0.81)
		end
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetTexCoord(0.3, 0.29, 0.3, 0.75, 0.65, 0.29, 0.65, 0.75)
		end

		btn:GetNormalTexture():ClearAllPoints()
		btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
		btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
		if btn:GetDisabledTexture() then
			btn:GetDisabledTexture():SetAllPoints(btn:GetNormalTexture())
		end
		if btn:GetPushedTexture() then
			btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
		end
		btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)
		btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
	end
end

function T.SkinRotateButton(btn)
	btn:SetTemplate("Default")
	btn:SetSize(btn:GetWidth() - 14, btn:GetHeight() - 14)

	btn:GetNormalTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)
	btn:GetPushedTexture():SetTexCoord(0.3, 0.29, 0.3, 0.65, 0.69, 0.29, 0.69, 0.65)

	btn:GetHighlightTexture():SetTexture(1, 1, 1, 0.3)

	btn:GetNormalTexture():ClearAllPoints()
	btn:GetNormalTexture():SetPoint("TOPLEFT", 2, -2)
	btn:GetNormalTexture():SetPoint("BOTTOMRIGHT", -2, 2)
	btn:GetPushedTexture():SetAllPoints(btn:GetNormalTexture())
	btn:GetHighlightTexture():SetAllPoints(btn:GetNormalTexture())
end

function T.SkinEditBox(frame, width, height)
	if _G[frame:GetName()] then
		if _G[frame:GetName().."Left"] then _G[frame:GetName().."Left"]:Kill() end
		if _G[frame:GetName().."Middle"] then _G[frame:GetName().."Middle"]:Kill() end
		if _G[frame:GetName().."Right"] then _G[frame:GetName().."Right"]:Kill() end
		if _G[frame:GetName().."Mid"] then _G[frame:GetName().."Mid"]:Kill() end
	end

	if frame.Left then frame.Left:Kill() end
	if frame.Right then frame.Right:Kill() end
	if frame.Middle then frame.Middle:Kill() end

	if frame.LeftTexture then frame.LeftTexture:Kill() end
	if frame.RightTexture then frame.RightTexture:Kill() end
	if frame.MiddleTexture then frame.MiddleTexture:Kill() end

	frame:CreateBackdrop("Overlay")

	if frame:GetName() and (frame:GetName():find("Gold") or frame:GetName():find("Silver") or frame:GetName():find("Copper")) then
		if frame:GetName():find("Gold") then
			frame.backdrop:SetPoint("TOPLEFT", -3, 1)
			frame.backdrop:SetPoint("BOTTOMRIGHT", -3, 0)
		else
			frame.backdrop:SetPoint("TOPLEFT", -3, 1)
			frame.backdrop:SetPoint("BOTTOMRIGHT", -13, 0)
		end
	end

	if width then frame:SetWidth(width) end
	if height then frame:SetHeight(height) end
end

function T.SkinDropDownBox(frame, width)
	-- local button = _G[frame:GetName().."Button"] or _G[frame:GetName().."_Button"]
	local button = _G[frame:GetName()] and (_G[frame:GetName().."Button"] or _G[frame:GetName().."_Button"]) or frame.Button
	local text = _G[frame:GetName()] and _G[frame:GetName().."Text"] or frame.Text
	if not width then width = 155 end

	frame:StripTextures()
	frame:SetWidth(width)

	--[[
	if _G[frame:GetName().."Text"] then
		_G[frame:GetName().."Text"]:ClearAllPoints()
		_G[frame:GetName().."Text"]:SetPoint("RIGHT", button, "LEFT", -2, 0)
	end
	--]]
	if text then
		text:ClearAllPoints()
		text:SetPoint("RIGHT", button, "LEFT", -2, 0)
	end

	button:ClearAllPoints()
	button:SetPoint("RIGHT", frame, "RIGHT", -10, 3)
	button.SetPoint = T.dummy
	scrolldn = false
	T.SkinNextPrevButton(button)

	frame:CreateBackdrop("Overlay")
	frame:SetFrameLevel(frame:GetFrameLevel() + 2)
	frame.backdrop:SetPoint("TOPLEFT", 20, -2)
	frame.backdrop:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 2, -2)
end

function T.SkinCheckBox(frame, default)
	frame:SetNormalTexture("")
	frame:SetPushedTexture("")
	frame:CreateBackdrop("Overlay")
	frame:SetFrameLevel(frame:GetFrameLevel() + 2)
	frame.backdrop:SetPoint("TOPLEFT", 4, -4)
	frame.backdrop:SetPoint("BOTTOMRIGHT", -4, 4)

	if frame.SetHighlightTexture then
		local highlight = frame:CreateTexture(nil, nil, self)
		highlight:SetTexture(1, 1, 1, 0.3)
		highlight:SetPoint("TOPLEFT", frame, 6, -6)
		highlight:SetPoint("BOTTOMRIGHT", frame, -6, 6)
		frame:SetHighlightTexture(highlight)
	end

	if frame.SetCheckedTexture then
		if default then return end
		local checked = frame:CreateTexture(nil, nil, self)
		checked:SetTexture(1, 0.82, 0, 0.8)
		checked:SetPoint("TOPLEFT", frame, 6, -6)
		checked:SetPoint("BOTTOMRIGHT", frame, -6, 6)
		frame:SetCheckedTexture(checked)
	end

	if frame.SetDisabledCheckedTexture then
		local disabled = frame:CreateTexture(nil, nil, self)
		disabled:SetTexture(0.6, 0.6, 0.6, 0.75)
		disabled:SetPoint("TOPLEFT", frame, 6, -6)
		disabled:SetPoint("BOTTOMRIGHT", frame, -6, 6)
		frame:SetDisabledCheckedTexture(disabled)
	end

	--[[
	frame:HookScript("OnDisable", function(self)
		if not self.SetDisabledTexture then return end
		if self:GetChecked() then
			self:SetDisabledTexture(disabled)
		else
			self:SetDisabledTexture("")
		end
	end)
	--]]
end

function T.SkinCloseButton(f, point, text, pixel)
	f:StripTextures()
	f:SetTemplate("Overlay")
	f:SetSize(18, 18)

	if not text then text = "x" end
	if not f.text then
		if pixel then
			f.text = f:FontString(nil, C.media.pixel_font, 8)
			f.text:SetPoint("CENTER", -1, 1)
		else
			f.text = f:FontString(nil, C.media.normal_font, 17)
			f.text:SetPoint("CENTER", -1, 2)
		end
		f.text:SetText(text)
	end

	if point then
		f:SetPoint("TOPRIGHT", point, "TOPRIGHT", -4, -4)
	else
		f:SetPoint("TOPRIGHT", -4, -4)
	end

	f:HookScript("OnEnter", T.SetModifiedBackdrop)
	f:HookScript("OnLeave", T.SetOriginalBackdrop)
end

function T.SkinIcon(icon, parent)
	parent = parent or icon:GetParent()

	parent:CreateBackdrop("Overlay")
	parent.backdrop:SetPoint("TOPLEFT", icon, -2, 2)
	parent.backdrop:SetPoint("BOTTOMRIGHT", icon, 2, -2)

	icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon:SetParent(parent)
end

function T.SkinSlider(f)
	f:SetBackdrop(nil)

	local bd = CreateFrame("Frame", nil, f)
	bd:SetTemplate("Overlay")
	if f:GetOrientation() == "VERTICAL" then
		bd:SetPoint("TOPLEFT", -2, -6)
		bd:SetPoint("BOTTOMRIGHT", 2, 6)
	else
		bd:SetPoint("TOPLEFT", 14, -2)
		bd:SetPoint("BOTTOMRIGHT", -15, 3)
	end
	bd:SetFrameLevel(f:GetFrameLevel() - 1)

	f:SetThumbTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	f:GetThumbTexture():SetBlendMode("ADD")
end

function T.SkinIconSelectionFrame(frame, numIcons, buttonNameTemplate, frameNameOverride)
	local frameName = frameNameOverride or frame:GetName()
	local scrollFrame = _G[frameName.."ScrollFrame"]
	local editBox = _G[frameName.."EditBox"]
	local okayButton = _G[frameName.."OkayButton"] or _G[frameName.."Okay"] or frame.BorderBox.OkayButton
	local cancelButton = _G[frameName.."CancelButton"] or _G[frameName.."Cancel"] or frame.BorderBox.CancelButton

	frame:StripTextures()
	-- frame.BorderBox:StripTextures()
	frame:CreateBackdrop("Transparent")
	frame.backdrop:SetPoint("TOPLEFT", 2, 1)
	frame:SetHeight(frame:GetHeight() + 13)

	scrollFrame:StripTextures()
	scrollFrame:CreateBackdrop("Overlay")
	scrollFrame.backdrop:SetPoint("TOPLEFT", 47, 4)
	scrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 34, -8)
	scrollFrame:SetHeight(scrollFrame:GetHeight() + 12)

	okayButton:SkinButton()
	cancelButton:SkinButton()
	cancelButton:ClearAllPoints()
	cancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)

	editBox:DisableDrawLayer("BACKGROUND")
	T.SkinEditBox(editBox)

	cancelButton:ClearAllPoints()
	cancelButton:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -5, 5)

	if buttonNameTemplate then
		for i = 1, numIcons do
			local button = _G[buttonNameTemplate..i]
			local icon = _G[button:GetName().."Icon"]

			button:StripTextures()
			button:StyleButton(true)
			button:SetTemplate("Default")

			icon:ClearAllPoints()
			icon:SetPoint("TOPLEFT", 2, -2)
			icon:SetPoint("BOTTOMRIGHT", -2, 2)
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		end
	end
end

local LoadBlizzardSkin = CreateFrame("Frame")
LoadBlizzardSkin:RegisterEvent("ADDON_LOADED")
LoadBlizzardSkin:SetScript("OnEvent", function(self, event, addon)
	if IsAddOnLoaded("Skinner") or IsAddOnLoaded("Aurora") or not C.skins.blizzard_frames then
		self:UnregisterEvent("ADDON_LOADED")
		return
	end

	for _addon, skinfunc in pairs(T.SkinFuncs) do
		if type(skinfunc) == "function" then
			if _addon == addon then
				if skinfunc then
					skinfunc()
				end
			end
		elseif type(skinfunc) == "table" then
			if _addon == addon then
				for _, skinfunc in pairs(T.SkinFuncs[_addon]) do
					if skinfunc then
						skinfunc()
					end
				end
			end
		end
	end
end)

----------------------------------------------------------------------------------------
--	Unit frames functions
----------------------------------------------------------------------------------------
if C.unitframe.enable ~= true then return end
local ns = oUF
local oUF = ns.oUF

T.UpdateAllElements = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateElement", frame.unit)
	end
end

T.UpdateAuras = function(frame)
	for _, v in ipairs(frame.__elements) do
		v(frame, "UpdateAuras", frame.unit)
	end
end

--[[
local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup()
	self.anim:SetLooping("BOUNCE")
	self.anim.fade = self.anim:CreateAnimation("Alpha")
	self.anim.fade:SetFromAlpha(1)
	self.anim.fade:SetToAlpha(0)
	self.anim.fade:SetDuration(0.6)
	self.anim.fade:SetSmoothing("IN_OUT")
end
--]]

--[[
local Flash = function(self)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	if not self.anim:IsPlaying() then
		self.anim:Play()
	end
end
--]]

--[[
local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end
--]]

T.SpawnMenu = function(self)
	local unit = self.unit:gsub("(.)", strupper, 1)
	if unit == "targettarget" or unit == "focustarget" or unit == "pettarget" then return end

	if _G[unit.."FrameDropDown"] then
		ToggleDropDownMenu(1, nil, _G[unit.."FrameDropDown"], "cursor")
	elseif self.unit:match("party") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor")
	end
end

T.SetFontString = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "ARTWORK")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetShadowOffset(C.font.unit_frames_font_shadow and 1 or 0, C.font.unit_frames_font_shadow and -1 or 0)
	return fs
end

T.PostUpdateHealth = function(health, unit, cur, max)
	-- if unit and unit:find("arena%dtarget") then return end
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		local r, g, b
		if (C.unitframe.own_color ~= true and C.unitframe.enemy_health_color and unit == "target" and UnitIsEnemy(unit, "player") and UnitIsPlayer(unit)) or (C.unitframe.own_color ~= true and unit == "target" and not UnitIsPlayer(unit) and UnitIsFriend(unit, "player")) then
			local c = T.oUF_colors.reaction[UnitReaction(unit, "player")]
			if c then
				r, g, b = c[1], c[2], c[3]
				health:SetStatusBarColor(r, g, b)
			else
				r, g, b = 0.3, 0.7, 0.3
				health:SetStatusBarColor(r, g, b)
			end
		end
		if unit == "pet" then
			local _, class = UnitClass("player")
			local r, g, b = unpack(T.oUF_colors.class[class])
			if C.unitframe.own_color == true then
				health:SetStatusBarColor(unpack(C.unitframe.uf_color))
				health.bg:SetVertexColor(0.1, 0.1, 0.1)
			else
				if b then
					health:SetStatusBarColor(r, g, b)
					if health.bg and health.bg.multiplier then
						local mu = health.bg.multiplier
						health.bg:SetVertexColor(r * mu, g * mu, b * mu)
					end
				end
			end
		end
		if C.unitframe.bar_color_value == true and not UnitIsTapDenied(unit) then
			if C.unitframe.own_color == true then
				r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
			else
				r, g, b = health:GetStatusBarColor()
			end
			local newr, newg, newb = oUF.ColorGradient(cur, max, 1, 0, 0, 1, 1, 0, r, g, b)

			health:SetStatusBarColor(newr, newg, newb)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(newr * mu, newg * mu, newb * mu)
			end
		end
		if cur ~= max then
			r, g, b = oUF.ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if unit == "player" and health:GetAttribute("normalUnit") ~= "pet" then
				if C.unitframe.show_total_value == true then
					if C.unitframe.color_value == true then
						health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(cur), T.ShortValue(max))
					else
						health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
					end
				else
					if C.unitframe.color_value == true then
						health.value:SetFormattedText("|cffAF5050%d|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", cur, r * 255, g * 255, b * 255, floor(cur / max * 100))
					else
						health.value:SetFormattedText("|cffffffff%d - %d%%|r", cur, floor(cur / max * 100))
					end
				end
			elseif unit == "target" then
				if C.unitframe.show_total_value == true then
					if C.unitframe.color_value == true then
						health.value:SetFormattedText("|cff559655%s|r |cffD7BEA5-|r |cff559655%s|r", T.ShortValue(cur), T.ShortValue(max))
					else
						health.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(cur), T.ShortValue(max))
					end
				else
					if C.unitframe.color_value == true then
						health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(cur / max * 100), T.ShortValue(cur))
					else
						health.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(cur))
					end
				end
			--[[
			elseif unit and unit:find("boss%d") then
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r |cffD7BEA5-|r |cffAF5050%s|r", r * 255, g * 255, b * 255, floor(cur / max * 100), T.ShortValue(cur))
				else
					health.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(cur))
				end
			--]]
			else
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(cur / max * 100))
				else
					health.value:SetFormattedText("|cffffffff%d%%|r", floor(cur / max * 100))
				end
			end
		else
			if unit == "player" and unit ~= "pet" then
				if C.unitframe.color_value == true then
					health.value:SetText("|cff559655"..max.."|r")
				else
					health.value:SetText("|cffffffff"..max.."|r")
				end
			else
				if C.unitframe.color_value == true then
					health.value:SetText("|cff559655"..T.ShortValue(max).."|r")
				else
					health.value:SetText("|cffffffff"..T.ShortValue(max).."|r")
				end
			end
		end
	end
end

T.PostUpdateRaidHealth = function(health, unit, cur, max)
	local self = health:GetParent()
	local power = self.Power
	local border = self.backdrop
	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		health:SetValue(0)
		if not UnitIsConnected(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_OFFLINE.."|r")
		elseif UnitIsDead(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_DEAD.."|r")
		elseif UnitIsGhost(unit) then
			health.value:SetText("|cffD7BEA5"..L_UF_GHOST.."|r")
		end
	else
		local r, g, b
		if not UnitIsPlayer(unit) and UnitIsFriend(unit, "player") and C.unitframe.own_color ~= true then
			local c = T.oUF_colors.reaction[5]
			local r, g, b = c[1], c[2], c[3]
			health:SetStatusBarColor(r, g, b)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(r * mu, g * mu, b * mu)
			end
		end
		if C.unitframe.bar_color_value == true and not UnitIsTapDenied(unit) then
			if C.unitframe.own_color == true then
				r, g, b = C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3]
			else
				r, g, b = health:GetStatusBarColor()
			end
			local newr, newg, newb = oUF.ColorGradient(cur, max, 1, 0, 0, 1, 1, 0, r, g, b)

			health:SetStatusBarColor(newr, newg, newb)
			if health.bg and health.bg.multiplier then
				local mu = health.bg.multiplier
				health.bg:SetVertexColor(newr * mu, newg * mu, newb * mu)
			end
		end
		if cur ~= max then
			r, g, b = oUF.ColorGradient(cur, max, 0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.33, 0.59, 0.33)
			if self:GetParent():GetName():match("oUF_PartyDPS") then
				if C.unitframe.color_value == true then
					health.value:SetFormattedText("|cffAF5050%s|r |cffD7BEA5-|r |cff%02x%02x%02x%d%%|r", T.ShortValue(cur), r * 255, g * 255, b * 255, floor(cur / max * 100))
				else
					health.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(cur), floor(cur / max * 100))
				end
			else
				if C.unitframe.color_value == true then
					if C.raidframe.deficit_health == true then
						health.value:SetText("|cffffffff".."-"..T.ShortValue(max - cur))
					else
						health.value:SetFormattedText("|cff%02x%02x%02x%d%%|r", r * 255, g * 255, b * 255, floor(cur / max * 100))
					end
				else
					if C.raidframe.deficit_health == true then
						health.value:SetText("|cffffffff".."-"..T.ShortValue(max - cur))
					else
						health.value:SetFormattedText("|cffffffff%d%%|r", floor(cur / max * 100))
					end
				end
			end
		else
			if C.unitframe.color_value == true then
				health.value:SetText("|cff559655"..T.ShortValue(max).."|r")
			else
				health.value:SetText("|cffffffff"..T.ShortValue(max).."|r")
			end
		end
		if C.raidframe.alpha_health == true then
			if cur / max > 0.95 then
				health:SetAlpha(0.6)
				power:SetAlpha(0.6)
				border:SetAlpha(0.6)
			else
				health:SetAlpha(1)
				power:SetAlpha(1)
				border:SetAlpha(1)
			end
		end
	end
end

T.PreUpdatePower = function(power, unit)
	local pType = UnitPowerType(unit)

	local color = T.oUF_colors.power[pType]
	if color then
		power:SetStatusBarColor(color[1], color[2], color[3])
	end
end

T.PostUpdatePower = function(power, unit, cur, max)
	-- if unit and unit:find("arena%dtarget") then return end
	local self = power:GetParent()
	local pType = UnitPowerType(unit)
	local color = T.oUF_colors.power[pType]

	if color then
		power.value:SetTextColor(color[1], color[2], color[3])
	end

	if not UnitIsConnected(unit) or UnitIsDead(unit) or UnitIsGhost(unit) then
		power:SetValue(0)
	end

	if unit == "focus" or unit == "focustarget" or unit == "targettarget" or (self:GetParent():GetName():match("oUF_RaidDPS")) then return end

	if not UnitIsConnected(unit) then
		power.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) or max == 0 then
		power.value:SetText()
	else
		if cur ~= max then
			if pType == 0 then
				if unit == "target" then
					if C.unitframe.show_total_value == true then
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						else
							power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						end
					else
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
						else
							power.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
						end
					end
				elseif (unit == "player" and power:GetAttribute("normalUnit") == "pet") or unit == "pet" then
					if C.unitframe.show_total_value == true then
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						else
							power.value:SetFormattedText("%s |cffffffff-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						end
					else
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%d%%", floor(cur / max * 100))
						else
							power.value:SetFormattedText("|cffffffff%d%%|r", floor(cur / max * 100))
						end
					end
				--[[
				elseif unit and (unit:find("arena%d") or unit:find("boss%d")) then
					if C.unitframe.color_value == true then
						power.value:SetFormattedText("|cffD7BEA5%d%% - %s|r", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
					else
						power.value:SetFormattedText("|cffffffff%d%% - %s|r", floor(cur / max * 100), T.ShortValue(max - (max - cur)))
					end
				--]]
				elseif self:GetParent():GetName():match("oUF_PartyDPS") then
					if C.unitframe.color_value == true then
						power.value:SetFormattedText("%s |cffD7BEA5-|r %d%%", T.ShortValue(max - (max - cur)), floor(cur / max * 100))
					else
						power.value:SetFormattedText("|cffffffff%s - %d%%|r", T.ShortValue(max - (max - cur)), floor(cur / max * 100))
					end
				else
					if C.unitframe.show_total_value == true then
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%s |cffD7BEA5-|r %s", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						else
							power.value:SetFormattedText("|cffffffff%s - %s|r", T.ShortValue(max - (max - cur)), T.ShortValue(max))
						end
					else
						if C.unitframe.color_value == true then
							power.value:SetFormattedText("%d |cffD7BEA5-|r %d%%", max - (max - cur), floor(cur / max * 100))
						else
							power.value:SetFormattedText("|cffffffff%d - %d%%|r", max - (max - cur), floor(cur / max * 100))
						end
					end
				end
			else
				if C.unitframe.color_value == true then
					power.value:SetText(max - (max - cur))
				else
					power.value:SetText("|cffffffff"..max - (max - cur).."|r")
				end
			end
		else
			-- if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) or (self:GetParent():GetName():match("oUF_PartyDPS")) then
			if unit == "pet" or unit == "target" or (self:GetParent():GetName():match("oUF_PartyDPS")) then
				if C.unitframe.color_value == true then
					power.value:SetText(T.ShortValue(cur))
				else
					power.value:SetText("|cffffffff"..T.ShortValue(cur).."|r")
				end
			else
				if C.unitframe.color_value == true then
					power.value:SetText(cur)
				else
					power.value:SetText("|cffffffff"..cur.."|r")
				end
			end
		end
	end
end

T.UpdateManaLevel = function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed < 0.2 then return end
	self.elapsed = 0

	if UnitPowerType("player") == 0 then
		local percMana = UnitMana("player") / UnitManaMax("player") * 100
		if percMana <= 20 and not UnitIsDeadOrGhost("player") then
			self.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			-- Flash(self)
		else
			self.ManaLevel:SetText()
			-- StopFlash(self)
		end
	elseif T.class ~= "DRUID" then
		self.ManaLevel:SetText()
		-- StopFlash(self)
	end
end

T.UpdateClassMana = function(self)
	if self.unit ~= "player" then return end

	local LDM = LibStub("LibDruidMana-1.0")

	if UnitPowerType("player") ~= 0 then
		-- local min = UnitMana("player", 0)
		-- local max = UnitManaMax("player", 0)
		local min, max = LDM:GetCurrentMana(), LDM:GetMaximumMana()

		local percMana = min / max * 100
		if percMana <= 20 and not UnitIsDeadOrGhost("player") then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..MANA_LOW.."|r")
			-- Flash(self.FlashInfo)
		else
			self.FlashInfo.ManaLevel:SetText()
			-- StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.ClassMana:SetPoint("RIGHT", self.Power.value, "LEFT", -1, 0)
				self.ClassMana:SetFormattedText("%d%%|r |cffD7BEA5-|r", floor(min / max * 100))
				self.ClassMana:SetJustifyH("RIGHT")
			else
				self.ClassMana:SetPoint("LEFT", self.Power, "LEFT", 4, 0)
				self.ClassMana:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.ClassMana:SetText()
		end

		self.ClassMana:SetAlpha(1)
	else
		self.ClassMana:SetAlpha(0)
	end
end

T.UpdatePvPStatus = function(self, elapsed)
	if self.elapsed and self.elapsed > 0.2 then
		local unit = self.unit
		local time = GetPVPTimer()

		local min = format("%01.f", floor((time / 1000) / 60))
		local sec = format("%02.f", floor((time / 1000) - min * 60))
		if self.Status then
			local factionGroup = UnitFactionGroup(unit)
			if UnitIsPVPFreeForAll(unit) then
				if time ~= 301000 and time ~= -1 then
					self.Status:SetText(PVP.." ".."["..min..":"..sec.."]")
				else
					self.Status:SetText(PVP)
				end
			elseif factionGroup and UnitIsPVP(unit) then
				if time ~= 301000 and time ~= -1 then
					self.Status:SetText(PVP.." ".."["..min..":"..sec.."]")
				else
					self.Status:SetText(PVP)
				end
			else
				self.Status:SetText("")
			end
		end
		self.elapsed = 0
	else
		self.elapsed = (self.elapsed or 0) + elapsed
	end
end

T.UpdateComboPoint = function(self, event, unit)
	if powerType and powerType ~= "COMBO_POINTS" then return end
	if unit == "pet" then return end

	local cpoints = self.ComboPoints
	local cp = GetComboPoints("player", "target")

	for i = 1, MAX_COMBO_POINTS do
		if i <= cp then
			cpoints[i]:SetAlpha(1)
		else
			cpoints[i]:SetAlpha(0.2)
		end
	end

	if T.class == "DRUID" and C.unitframe_class_bar.combo_always ~= true then
		local form = GetShapeshiftForm()

		if form == 3 and cp > 0 then
			cpoints:Show()
			if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19) end
		else
			cpoints:Hide()
			if self.Debuffs then self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5) end
		end
	end
end

T.UpdateComboPointOld = function(self, event, unit)
	if powerType and powerType ~= "COMBO_POINTS" then return end
	if unit == "pet" then return end

	local cpoints = self.ComboPoints
	local cp = GetComboPoints("player", "target")

	for i = 1, MAX_COMBO_POINTS do
		if i <= cp then
			cpoints[i]:SetAlpha(1)
		else
			cpoints[i]:SetAlpha(0.2)
		end
	end

	if cpoints[1]:GetAlpha() == 1 then
		for i = 1, MAX_COMBO_POINTS do
			cpoints:Show()
			cpoints[i]:Show()
		end
	else
		for i = 1, MAX_COMBO_POINTS do
			cpoints:Hide()
			cpoints[i]:Hide()
		end
	end

	if cpoints[1]:IsShown() then
		if self.Auras then self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 19) end
	else
		if self.Auras then self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 5) end
	end
end

local ticks = {}
local channelingTicks = T.CastBarTicks

local setBarTicks = function(CastBar, ticknum)
	for k, v in pairs(ticks) do
		v:Hide()
	end
	if ticknum and ticknum > 0 then
		local delta = CastBar:GetWidth() / ticknum
		for k = 1, ticknum do
			if not ticks[k] then
				ticks[k] = CastBar:CreateTexture(nil, "OVERLAY")
				ticks[k]:SetTexture(C.media.texture)
				ticks[k]:SetVertexColor(unpack(C.media.border_color))
				ticks[k]:SetWidth(1)
				ticks[k]:SetHeight(CastBar:GetHeight())
				ticks[k]:SetDrawLayer("OVERLAY", 7)
			end
			ticks[k]:ClearAllPoints()
			ticks[k]:SetPoint("CENTER", CastBar, "RIGHT", -delta * k, 0)
			ticks[k]:Show()
		end
	end
end

T.PostCastStart = function(CastBar, unit, name)
	CastBar.channeling = false

	if unit == "player" and C.unitframe.castbar_latency == true and CastBar.Latency then
		local _, _, lag = GetNetStats()
		local latency = GetTime() - (CastBar.castSent or 0)
		lag = lag / 1e3 > CastBar.max and CastBar.max or lag / 1e3
		latency = latency > CastBar.max and lag or latency
		CastBar.Latency:SetText(("%dms"):format(latency * 1e3))
		CastBar.SafeZone:SetWidth(CastBar:GetWidth() * latency / CastBar.max)
		CastBar.SafeZone:ClearAllPoints()
		CastBar.SafeZone:SetPoint("TOPRIGHT")
		CastBar.SafeZone:SetPoint("BOTTOMRIGHT")
		CastBar.castSent = nil
	end

	if unit == "player" and C.unitframe.castbar_ticks == true then
		setBarTicks(CastBar, 0)
	end

	local r, g, b, color
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		color = T.oUF_colors.class[class]
	else
		local reaction = T.oUF_colors.reaction[UnitReaction(unit, "player")]
		if reaction then
			r, g, b = reaction[1], reaction[2], reaction[3]
		else
			r, g, b = 1, 1, 1
		end
	end

	if color then
		r, g, b = color[1], color[2], color[3]
	end

	if CastBar.interrupt and UnitCanAttack("player", unit) then
		CastBar:SetStatusBarColor(0.8, 0, 0)
		CastBar.bg:SetVertexColor(0.8, 0, 0, 0.2)
		CastBar.Overlay:SetBackdropBorderColor(0.8, 0, 0)
		if C.unitframe.castbar_icon == true and (unit == "target" or unit == "focus") then
			CastBar.Button:SetBackdropBorderColor(0.8, 0, 0)
		end
	else
		if unit == "pet" then
			local _, class = UnitClass("player")
			local r, g, b = unpack(T.oUF_colors.class[class])
			if C.unitframe.own_color == true then
				CastBar:SetStatusBarColor(unpack(C.unitframe.uf_color))
				CastBar.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
			else
				if b then
					CastBar:SetStatusBarColor(r, g, b)
					CastBar.bg:SetVertexColor(r, g, b, 0.2)
				end
			end
		else
			if C.unitframe.own_color == true then
				CastBar:SetStatusBarColor(unpack(C.unitframe.uf_color))
				CastBar.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
			else
				CastBar:SetStatusBarColor(r, g, b)
				CastBar.bg:SetVertexColor(r, g, b, 0.2)
			end
		end
		CastBar.Overlay:SetBackdropBorderColor(unpack(C.media.border_color))
		if C.unitframe.castbar_icon == true and (unit == "target" or unit == "focus") then
			CastBar.Button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end
end

T.PostChannelStart = function(CastBar, unit, name)
	CastBar.channeling = true

	if unit == "player" and C.unitframe.castbar_latency == true and CastBar.Latency then
		local _, _, lag = GetNetStats()
		local latency = GetTime() - (CastBar.castSent or 0)
		lag = lag / 1e3 > CastBar.max and CastBar.max or lag / 1e3
		latency = latency > CastBar.max and lag or latency
		CastBar.Latency:SetText(("%dms"):format(latency * 1e3))
		CastBar.SafeZone:SetWidth(CastBar:GetWidth() * latency / CastBar.max)
		CastBar.SafeZone:ClearAllPoints()
		CastBar.SafeZone:SetPoint("TOPLEFT")
		CastBar.SafeZone:SetPoint("BOTTOMLEFT")
		CastBar.castSent = nil
	end

	if unit == "player" and C.unitframe.castbar_ticks == true then
		local spell = UnitChannelInfo(unit)
		CastBar.channelingTicks = channelingTicks[spell] or 0
		setBarTicks(CastBar, CastBar.channelingTicks)
	end

	local r, g, b, color
	if UnitIsPlayer(unit) then
		local _, class = UnitClass(unit)
		color = T.oUF_colors.class[class]
	else
		local reaction = T.oUF_colors.reaction[UnitReaction(unit, "player")]
		if reaction then
			r, g, b = reaction[1], reaction[2], reaction[3]
		else
			r, g, b = 1, 1, 1
		end
	end

	if color then
		r, g, b = color[1], color[2], color[3]
	end

	if CastBar.interrupt and UnitCanAttack("player", unit) then
		CastBar:SetStatusBarColor(0.8, 0, 0)
		CastBar.bg:SetVertexColor(0.8, 0, 0, 0.2)
		CastBar.Overlay:SetBackdropBorderColor(0.8, 0, 0)
		if C.unitframe.castbar_icon == true and (unit == "target" or unit == "focus") then
			CastBar.Button:SetBackdropBorderColor(0.8, 0, 0)
		end
	else
		if unit == "pet" then
			local _, class = UnitClass("player")
			local r, g, b = unpack(T.oUF_colors.class[class])
			if C.unitframe.own_color == true then
				CastBar:SetStatusBarColor(unpack(C.unitframe.uf_color))
				CastBar.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
			else
				if b then
					CastBar:SetStatusBarColor(r, g, b)
					CastBar.bg:SetVertexColor(r, g, b, 0.2)
				end
			end
		else
			if C.unitframe.own_color == true then
				CastBar:SetStatusBarColor(unpack(C.unitframe.uf_color))
				CastBar.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
			else
				CastBar:SetStatusBarColor(r, g, b)
				CastBar.bg:SetVertexColor(r, g, b, 0.2)
			end
		end
		CastBar.Overlay:SetBackdropBorderColor(unpack(C.media.border_color))
		if C.unitframe.castbar_icon == true and (unit == "target" or unit == "focus") then
			CastBar.Button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end
end

T.CustomCastTimeText = function(self, duration)
	self.Time:SetText(("%.1f / %.1f"):format(self.channeling and duration or self.max - duration, self.max))
end

T.CustomCastDelayText = function(self, duration)
	self.Time:SetText(("%.1f |cffaf5050%s %.1f|r"):format(self.channeling and duration or self.max - duration, self.channeling and "-" or "+", abs(self.delay)))
end

T.FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s / day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s / hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s / minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100)) / 100
	end
	return format("%.1f", s), (s * 100 - floor(s * 100)) / 100
end

T.FormatMoney = function(money)
	local gold = floor(math.abs(money) / 10000)
	local silver = mod(floor(math.abs(money) / 100), 100)
	local copper = mod(floor(math.abs(money)), 100)
	if gold ~= 0 then
		return format("%s".."|cffffd700"..L_COMPATIBILITY_GOLD_AMOUNT_SYMBOL.."|r".." %s".."|cffc7c7cfs|r".." %s".."|cffeda55fc|r", gold, silver, copper)
	elseif silver ~= 0 then
		return format("%s".."|cffc7c7cf"..L_COMPATIBILITY_SILVER_AMOUNT_SYMBOL.."|r".." %s".."|cffeda55fc|r", silver, copper)
	else
		return format("%s".."|cffeda55f"..L_COMPATIBILITY_COPPER_AMOUNT_SYMBOL.."|r", copper)
	end
end

local CreateAuraTimer = function(self, elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = T.FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				self.remaining:SetTextColor(1, 1, 1)
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

T.AuraTrackerTime = function(self, elapsed)
	if self.active then
		self.timeleft = self.timeleft - elapsed
		if self.timeleft <= 5 then
			self.text:SetTextColor(1, 0, 0)
		else
			self.text:SetTextColor(1, 1, 1)
		end
		if self.timeleft <= 0 then
			self.icon:SetTexture("")
			self.text:SetText("")
		end
		self.text:SetFormattedText("%.1f", self.timeleft)
	end
end

T.HideAuraFrame = function(self)
	if self.unit == "player" then
		if not C.aura.player_auras then
			BuffFrame:UnregisterEvent("UNIT_AURA")
			BuffFrame:Hide()
			TemporaryEnchantFrame:Hide()
			self.Buffs:Hide()
			self.Debuffs:Hide()
			self.Enchant:Hide()
		else
			BuffFrame:Hide()
			TemporaryEnchantFrame:Hide()
		end
	elseif self.unit == "pet" and not C.aura.pet_debuffs or self.unit == "focus" and not C.aura.focus_debuffs
	or self.unit == "focustarget" and not C.aura.fot_debuffs or self.unit == "targettarget" and not C.aura.tot_debuffs then
		self.Debuffs:Hide()
	elseif self.unit == "target" and not C.aura.target_auras then
		self.Auras:Hide()
	end
end

local CancelAura = function(self, button)
	if button == "RightButton" and not self.debuff then
		CancelPlayerBuff(self:GetID(), self:GetParent().filter)
	end
end

T.PostCreateAura = function(element, button)
	button:SetTemplate("Default")

	button.remaining = T.SetFontString(button, C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.remaining:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)
	button.remaining:SetPoint("CENTER", button, "CENTER", 1, 1)
	button.remaining:SetJustifyH("CENTER")

	button.cd.noOCC = true
	button.cd.noCooldownCount = true

	button.icon:SetPoint("TOPLEFT", 2, -2)
	button.icon:SetPoint("BOTTOMRIGHT", -2, 2)
	button.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

	button.count:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", 1, 0)
	button.count:SetJustifyH("RIGHT")
	button.count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
	button.count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

	if C.aura.show_spiral == true then
		element.disableCooldown = false
		button.cd:SetReverse(true)
		button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", 2, -2)
		button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)
		button.parent = CreateFrame("Frame", nil, button)
		button.parent:SetFrameLevel(button.cd:GetFrameLevel() + 1)
		button.count:SetParent(button.parent)
		button.remaining:SetParent(button.parent)
	else
		element.disableCooldown = true
	end
	
	if unit == "player" then
		button:SetScript("OnMouseUp", CancelAura)
	end
end

T.CreateEnchantTimer = function(self, icons)
	for i = 1, 2 do
		local icon = icons[i]
		if icon.expTime then
			icon.timeLeft = icon.expTime - GetTime()
			icon.remaining:Show()
		else
			icon.remaining:Hide()
		end
		icon:SetScript("OnUpdate", CreateAuraTimer)
	end
end

T.PostUpdateIcon = function(element, unit, button, index, offset, filter, isDebuff, duration, timeLeft)
	local unstableAffliction = GetSpellInfo(30108)
	local vampiricTouch = GetSpellInfo(34914)

	local name, _, _, _, dtype, duration, expirationTime = UnitAura(unit, index, button.filter)
	--[[
	if not button.isDebuff then
		local name, _, _, _, duration, expirationTime = UnitBuff(unit, index)
	else
		local name, _, _, _, dtype, duration, expirationTime = UnitDebuff(unit, index)
	end
	--]]
	if expirationTime then expirationTime = expirationTime + GetTime() end

	--[[
	local playerUnits = {
		player = true,
		pet = true,
	}
	--]]
	
	if expirationTime then
		button.owner = true
	else
		button.owner = false
	end

	if button.isDebuff then
		-- if not UnitIsFriend("player", unit) and not playerUnits[button.owner] then
		if not UnitIsFriend("player", unit) and not button.owner then
			if C.aura.player_aura_only then
				button:Hide()
			else
				button:SetBackdropBorderColor(unpack(C.media.border_color))
				button.icon:SetDesaturated(true)
			end
		else
			if C.aura.debuff_color_type == true then
				if (name == unstableAffliction or name == vampiricTouch) and T.class ~= "WARLOCK" then
					button:SetBackdropBorderColor(0.05, 0.85, 0.94)
				else
					local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
					button:SetBackdropBorderColor(color.r, color.g, color.b)
					button.icon:SetDesaturated(false)
				end
			else
				button:SetBackdropBorderColor(1, 0, 0)
			end
		end
	else
		if (((T.class == "MAGE" or T.class == "PRIEST" or T.class == "SHAMAN") and dtype == "Magic")) and not UnitIsFriend("player", unit) then
			button:SetBackdropBorderColor(1, 0.85, 0)
		else
			button:SetBackdropBorderColor(unpack(C.media.border_color))
		end
		button:SetBackdropBorderColor(unpack(C.media.border_color))
		button.icon:SetDesaturated(false)
	end
	
	button.spell = name
	button.duration = duration

	if duration and duration > 0 and C.aura.show_timer == true then
		button.remaining:Show()
		button.timeLeft = expirationTime
		button:SetScript("OnUpdate", CreateAuraTimer)
	else
		button.remaining:Hide()
		button.timeLeft = huge
		button:SetScript("OnUpdate", nil)
	end

	button.first = true
end

local Banzai = LibStub("LibBanzai-2.0", true)
local lastCombatLogUpdate = 0

T.UpdateThreat = function(self, event, unit)
	if self.unit ~= unit then return end
	if GetTime() - lastCombatLogUpdate > 0.2 then
		lastCombatLogUpdate = GetTime()
		-- local threat = Banzai:GetUnitAggroByUnitId(self.unit)
		local threat = nil
		if threat then
			self.backdrop:SetBackdropBorderColor(1, 0, 0)
		else
			self.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end
end

local CountOffSets = {
	TOPLEFT = {9, 0},
	TOPRIGHT = {-8, 0},
	BOTTOMLEFT = {9, 0},
	BOTTOMRIGHT = {-8, 0},
	LEFT = {9, 0},
	RIGHT = {-8, 0},
	TOP = {0, 0},
	BOTTOM = {0, 0},
}

T.CreateAuraWatchIcon = function(self, icon)
	icon:SetTemplate("Default")
	icon.icon:SetPoint("TOPLEFT", icon, 1, -1)
	icon.icon:SetPoint("BOTTOMRIGHT", icon, -1, 1)
	icon.icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	icon.icon:SetDrawLayer("ARTWORK")
	if icon.cd then
		icon.cd:SetReverse(true)
	end
	icon.overlay:SetTexture()
end

T.CreateAuraWatch = function(self, unit)
	local auras = CreateFrame("Frame", nil, self)
	auras:SetPoint("TOPLEFT", self.Health, 0, 0)
	auras:SetPoint("BOTTOMRIGHT", self.Health, 0, 0)
	auras.presentAlpha = 1
	auras.missingAlpha = 0
	auras.icons = {}
	auras.PostCreateIcon = T.CreateAuraWatchIcon

	if not C.aura.show_timer then
		auras.hideCooldown = true
	end

	local buffs = {}

	if T.RaidBuffs["ALL"] then
		for key, value in pairs(T.RaidBuffs["ALL"]) do
			tinsert(buffs, value)
		end
	end

	if T.RaidBuffs[T.class] then
		for key, value in pairs(T.RaidBuffs[T.class]) do
			tinsert(buffs, value)
		end
	end

	if buffs then
		for key, spell in pairs(buffs) do
			local icon = CreateFrame("Frame", nil, auras)
			icon.spellID = spell[1]
			icon.anyUnit = spell[4]
			icon.strictMatching = spell[5]
			icon.textThreshold = -1
			icon:SetWidth(7)
			icon:SetHeight(7)
			icon:SetPoint(spell[2], 0, 0)

			local tex = icon:CreateTexture(nil, "OVERLAY")
			tex:SetAllPoints(icon)
			tex:SetTexture(C.media.blank)
			if spell[3] then
				tex:SetVertexColor(unpack(spell[3]))
			else
				tex:SetVertexColor(0.8, 0.8, 0.8)
			end

			local count = T.SetFontString(icon, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			count:SetPoint("CENTER", unpack(CountOffSets[spell[2]]))
			icon.count = count

			if not icon.text then
				local f = CreateFrame("Frame", nil, icon)
				f:SetFrameLevel(icon:GetFrameLevel() + 50)
				icon.text = f:CreateFontString(nil, "BORDER")
			end

			auras.icons[spell[1]] = icon
		end
	end

	self.AuraWatch = auras
end