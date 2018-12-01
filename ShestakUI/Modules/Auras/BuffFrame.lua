local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.aura.player_auras ~= true then return end

----------------------------------------------------------------------------------------
--	Style player buff(by Tukz)
----------------------------------------------------------------------------------------
local HideDebuffs = CreateFrame("Frame")
HideDebuffs:Hide()
	
local GetFormattedTime = function(s)
	if s >= 86400 then
		return format("%dd", floor(s/86400 + 0.5))
	elseif s >= 3600 then
		return format("%dh", floor(s/3600 + 0.5))
	elseif s >= 60 then
		return format("%dm", floor(s/60 + 0.5))
	end
	return floor(s + 0.5)
end

local BuffsAnchor = CreateFrame("Frame", "BuffsAnchor", UIParent)
BuffsAnchor:SetPoint(unpack(C.position.player_buffs))
BuffsAnchor:SetSize((15 * C.aura.player_buff_size) + 42, (C.aura.player_buff_size * 2) + 3)

local function StyleBuffs(buttonName, index)
	-- if buttonName == "DebuffButton" then _G[buttonName..index]:SetParent(HideDebuffs) return end -- Temporary?
	local buff = _G[buttonName..index]
	local icon = _G[buttonName..index.."Icon"]
	local border = _G[buttonName..index.."Border"]
	local duration = _G[buttonName..index.."Duration"]
	local count = _G[buttonName..index.."Count"]

	if icon and not _G[buttonName..index.."Panel"] then
		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetPoint("TOPLEFT", buff, 2, -2)
		icon:SetPoint("BOTTOMRIGHT", buff, -2, 2)

		buff:SetSize(C.aura.player_buff_size)

		duration:ClearAllPoints()
		duration:SetPoint("CENTER", 1, 1)
		duration:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
		duration:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

		count:ClearAllPoints()
		count:SetPoint("BOTTOMRIGHT", 0, 1)
		count:SetFont(C.font.auras_font, C.font.auras_font_size, C.font.auras_font_style)
		count:SetShadowOffset(C.font.auras_font_shadow and 1 or 0, C.font.auras_font_shadow and -1 or 0)

		local panel = CreateFrame("Frame", buttonName..index.."Panel", buff)
		panel:CreatePanel("Default", C.aura.player_buff_size, C.aura.player_buff_size, "CENTER", buff, "CENTER", 0, 0)
		if C.aura.classcolor_border == true then
			panel:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
		end
		if buttonName == "DebuffButton" then
			panel:SetBackdropBorderColor(1, 0, 0, 0.8)
		end
		panel:SetFrameLevel(buff:GetFrameLevel() - 1)
		panel:SetFrameStrata(buff:GetFrameStrata())
		
		if buff.SetHighlightTexture and not buff.highlightr then
			local highlight = buff:CreateTexture(nil, "HIGHLIGHT")
			highlight:SetTexture(1, 1, 1, 0.3)
			highlight:SetAllPoints(icon)

			buff.highlightr = highlight
			buff:SetHighlightTexture(highlight)
		end
	end
	if border then border:Hide() end
end

local function UpdateDuration(button, timeLeft)
	if button.untilCancelled == 1 then return end

	local duration = _G[button:GetName().."Duration"]

	if SHOW_BUFF_DURATIONS == "1" and timeLeft and C.aura.show_timer == true then
		duration:SetFormattedText(GetFormattedTime(timeLeft))
		duration:SetVertexColor(1, 1, 1)
		duration:Show()
	else
		duration:Hide()
	end
end

local function UpdateBuffAnchors(buttonName, index, filter)
	local buff = _G[buttonName..index]
	local rowbuffs = 20

	if not buff.isSkinned then
		StyleBuffs(buttonName, index)
		buff.isSkinned = true
	end

	if filter == "HELPFUL" then
		buff:ClearAllPoints()
		if index > 1 and (mod(index, rowbuffs) == 1) then
			if index == rowbuffs + 1 then
				buff:SetPoint("RIGHT", BuffsAnchor, "RIGHT", 0, 0)
			else
				buff:SetPoint("TOPRIGHT", getglobal(buttonName..(index-BUFFS_PER_ROW)), "TOPRIGHT", 0, 0)
			end
		elseif index == 1 then
			mainhand, _, _, offhand = GetWeaponEnchantInfo()
			if mainhand and offhand then
				buff:SetPoint("RIGHT", TempEnchant2, "LEFT", -3, 0)
			elseif (mainhand and not offhand) or (offhand and not mainhand) then
				buff:SetPoint("RIGHT", TempEnchant1, "LEFT", -3, 0)
			else
				buff:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT", 0, 0)
			end
		else
			buff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", -3, 0)
		end

		if index > (rowbuffs*2) then
			buff:Hide()
		else
			buff:Show()
		end
	else
		buff:ClearAllPoints()
		if index == 1 then
			buff:SetPoint("BOTTOMRIGHT", BuffsAnchor, "BOTTOMRIGHT", 0, -(C.aura.player_buff_size * 2))
		else
			buff:SetPoint("RIGHT", _G[buttonName..(index-1)], "LEFT", -3, 0)
		end

		if index > rowbuffs then
			buff:Hide()
		else
			buff:Show()
		end
	end
end

local function UpdateBuffButton(buttonName, index, filter)
	local color, debuffType
	local buffIndex = GetPlayerBuff(index, filter)
	local buff = _G[buttonName..index]

	if buffIndex ~= 0 then
		if filter == "HARMFUL" then
			debuffType = GetPlayerBuffDispelType(buffIndex)

			if debuffType then
				color = DebuffTypeColor[debuffType]
			else
				color = DebuffTypeColor["none"]
			end

			buff:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
		end
	end
end

local function UpdateBuffFrame()
	BUFF_ACTUAL_DISPLAY = 0
	for i = 1, BUFF_MAX_DISPLAY do
		if UpdateBuffButton("BuffButton", i, "HELPFUL") then
			BUFF_ACTUAL_DISPLAY = BUFF_ACTUAL_DISPLAY + 1
			StyleBuffs("BuffButton", i)
		end
	end

	for i = 1, DEBUFF_MAX_DISPLAY do
		if UpdateBuffButton("DebuffButton", i, "HARMFUL") then
			DEBUFF_ACTUAL_DISPLAY = DEBUFF_ACTUAL_DISPLAY + 1
			StyleBuffs("DebuffButton", i)
		end
	end

	TemporaryEnchantFrame:ClearAllPoints()
	TemporaryEnchantFrame:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT", 0, 0)

	for i = 1, 2 do
		_G["TempEnchant"..i]:ClearAllPoints()
		if i == 1 then
			_G["TempEnchant"..i]:SetPoint("TOPRIGHT", BuffsAnchor, "TOPRIGHT")
		else
			_G["TempEnchant"..i]:SetPoint("RIGHT", TempEnchant1, "LEFT", -3, 0)
		end

		StyleBuffs("TempEnchant", i)
	end
end

local function UpdateWeaponEnchantInfo()
	if mainhand or offhand then UpdateBuffFrame() end
	mainhand, _, _, offhand = GetWeaponEnchantInfo()

	local hasMainHandEnchant, _, _, hasOffHandEnchant = GetWeaponEnchantInfo()
	local mhQuality = GetInventoryItemQuality("player", 16)
	local ohQuality = GetInventoryItemQuality("player", 17)

	if hasMainHandEnchant and hasOffHandEnchant then
		TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(ohQuality))
		TempEnchant2:SetBackdropBorderColor(GetItemQualityColor(mhQuality))
	elseif hasMainHandEnchant and not hasOffHandEnchant then
		TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(mhQuality))
	elseif not hasMainHandEnchant and hasOffHandEnchant then
		TempEnchant1:SetBackdropBorderColor(GetItemQualityColor(ohQuality))
	end
end

local WeaponEnchantCheck = CreateFrame("Frame")
WeaponEnchantCheck:RegisterEvent("UNIT_INVENTORY_CHANGED")
WeaponEnchantCheck:RegisterEvent("PLAYER_EVENTERING_WORLD")
WeaponEnchantCheck:SetScript("OnEvent", UpdateWeaponEnchantInfo)

hooksecurefunc("BuffButton_UpdateAnchors", UpdateBuffAnchors)
hooksecurefunc("BuffButton_OnUpdate", UpdateBuffFrame)
hooksecurefunc("BuffFrame_UpdateDuration", UpdateDuration)