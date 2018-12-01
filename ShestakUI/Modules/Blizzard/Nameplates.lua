local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.nameplate.enable ~= true then return end

local unpack = unpack
local select = select
local tonumber = tonumber
local pairs = pairs
local floor = math.floor
local format = string.format
local gsub = string.gsub
local strlen = string.len

local CreateFrame = CreateFrame
local InCombatLockdown = InCombatLockdown
local SetCVar = SetCVar
local UnitCastingInfo = UnitCastingInfo
local UnitChannelInfo = UnitChannelInfo
local UnitLevel = UnitLevel
local UnitName = UnitName

local CLASS_BUTTONS = CLASS_BUTTONS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

----------------------------------------------------------------------------------------
--	Based on caelNamePlates
----------------------------------------------------------------------------------------
local NamePlates = CreateFrame("Frame", nil, UIParent)
NamePlates:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

-- local goodR, goodG, goodB = unpack(C.nameplate.good_color)
-- local badR, badG, badB = unpack(C.nameplate.bad_color)
-- local transitionR, transitionG, transitionB = unpack(C.nameplate.near_color)
local offset = T.mult * C.general.uiscale

local isValidFrame = function(frame)
	if frame:GetName() then	return end
	overlayRegion = select(2, frame:GetRegions())
	return overlayRegion and overlayRegion:GetObjectType() == "Texture" and overlayRegion:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
end

local updateTime = function(self, curValue)
	local minValue, maxValue = self:GetMinMaxValues()
	if self.channeling then
		self.time:SetFormattedText("%.1f ", curValue)
		if C.nameplate.show_castbar_name == true then
			self.castName:SetText(select(1, (UnitChannelInfo("target"))))
		end
	else
		self.time:SetFormattedText("%.1f ", maxValue - curValue)
		if C.nameplate.show_castbar_name == true then
			self.castName:SetText(select(1, (UnitCastingInfo("target"))))
		end
	end
end

local function round(num, idp)
	if idp and idp > 0 then
		local mult = 10^idp
		return floor(num * mult + 0.5) / mult
	end
	return floor(num + 0.5)
end

local function CheckTarget(self)
	if UnitName("target") == self.oldname:GetText() and self:GetAlpha() == 1 then
		return true
	else
		return false
	end
end

local threatUpdate = function(self, elapsed)
	self.elapsed = self.elapsed + elapsed	

	if self.elapsed >= 0.2 then
		local r, g, b = self.healthBar:GetStatusBarColor()
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		local isEnemyPlayer = false
		local isTarget = false

		for class, color in pairs(RAID_CLASS_COLORS) do
			if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
				isEnemyPlayer = true
			end
		end

		if not InCombatLockdown() then self:SetScale(1) end

		--[[
		if C.nameplate.enhance_threat == true then
			if not self.oldglow:IsShown() then
				if InCombatLockdown() and not isEnemyPlayer then
					if T.Role == "Tank" then
						self.healthBar:SetStatusBarColor(badR, badG, badB)
						self.healthBar.hpBackground:SetVertexColor(badR, badG, badB, 0.3)
					else
						self.healthBar:SetStatusBarColor(goodR, goodG, goodB)
						self.healthBar.hpBackground:SetVertexColor(goodR, goodG, goodB, 0.3)
					end
				else
					self.healthBar:SetStatusBarColor(self.r, self.g, self.b)		
					self.healthBar.hpBackground:SetVertexColor(self.r, self.g, self.b, 0.3)	
				end
			else
				local r, g, b = self.oldglow:GetVertexColor()
				if g + b == 0 then
					if T.Role == "Tank" then
						self.healthBar:SetStatusBarColor(goodR, goodG, goodB)
						self.healthBar.hpBackground:SetVertexColor(goodR, goodG, goodB, 0.3)
					else
						self.healthBar:SetStatusBarColor(badR, badG, badB)
						self.healthBar.hpBackground:SetVertexColor(badR, badG, badB, 0.3)
					end
				else
					self.healthBar:SetStatusBarColor(transitionR, transitionG, transitionB)
					self.healthBar.hpBackground:SetVertexColor(transitionR, transitionG, transitionB, 0.3)
				end
			end
		else
			if not self.oldglow:IsShown() and not isEnemyPlayer then
				self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
			elseif not isTarget then
				local r, g, b = self.oldglow:GetVertexColor()
				if g + b == 0 then
					self.healthBar:SetStatusBarColor(badR, badG, badB)
				else
					self.healthBar:SetStatusBarColor(transitionR, transitionG, transitionB)
				end
			end
			self.healthBar:SetStatusBarColor(self.r, self.g, self.b)
		end
		--]]

		local minHealth, maxHealth = self.oldhealth:GetMinMaxValues()
		local valueHealth = self.oldhealth:GetValue()
		local d = floor((valueHealth / maxHealth) * 100)

		if C.nameplate.health_value == true then
			self.healthBar.percent:SetText(T.ShortValue(valueHealth).." - "..(format("%d%%", floor((valueHealth/maxHealth)*100))))
			if isEnemyPlayer then
				if (d <= 45 and d >= 20) then
					self.healthBar.percent:SetTextColor(0.65, 0.63, 0.35)
				elseif(d < 20) then
					self.healthBar.percent:SetTextColor(0.69, 0.31, 0.31)
				else
					self.healthBar.percent:SetTextColor(1, 1, 1)
				end
			end
		end

		self.healthBar:ClearAllPoints()
		self.healthBar:SetPoint("CENTER", self.healthBar:GetParent(), 0, 10)

		if CheckTarget(self) then
			self.name:SetTextColor(1, 1, 0)
			self.healthBar:SetHeight((C.nameplate.height + C.nameplate.ad_height) * offset)
			self.healthBar:SetWidth((C.nameplate.width + C.nameplate.ad_width) * offset)
		else
			self.name:SetTextColor(1, 1, 1)
			self.healthBar:SetHeight(C.nameplate.height * offset)
			self.healthBar:SetWidth(C.nameplate.width * offset)
		end
		self.elapsed = 0
	end
end

local Abbrev = function(name)	
	local newname = (strlen(name) > 18) and gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return T.UTF(newname, 18, false)
end

local updatePlate = function(self)
	if not InCombatLockdown() then self:Show() end
	local r, g, b = self.healthBar:GetStatusBarColor()
	-- local newr, newg, newb
	if g + b == 0 then
		-- Hostile unit
		-- newr, newg, newb = 0.85, 0.27, 0.27
		self.healthBar:SetStatusBarColor(0.85, 0.27, 0.27)
	elseif r + b == 0 then
		-- Friendly unit
		-- newr, newg, newb = 0.33, 0.59, 0.33
		self.healthBar:SetStatusBarColor(0.33, 0.59, 0.33)
	elseif r + g == 0 then
		-- Friendly player
		-- newr, newg, newb = 0.31, 0.45, 0.63
		self.healthBar:SetStatusBarColor(0.31, 0.45, 0.63)
	elseif 2 - (r + g) < 0.05 and b == 0 then
		-- Neutral unit
		-- newr, newg, newb = 0.65, 0.63, 0.35
		self.healthBar:SetStatusBarColor(0.65, 0.63, 0.35)
	else
		-- Hostile player - class colored
		-- newr, newg, newb = r, g, b
	end

	-- self.r, self.g, self.b = newr, newg, newb

	self.healthBar:ClearAllPoints()
	self.healthBar:SetPoint("CENTER", self.healthBar:GetParent(), 0, 10)
	self.healthBar:SetHeight(C.nameplate.height * offset)
	self.healthBar:SetWidth(C.nameplate.width * offset)

	if C.nameplate.name_abbrev == true then
		self.name:SetText(Abbrev(self.oldname:GetText()))
		self.name:SetWidth(C.nameplate.width * offset - 14)
	else
		self.name:SetText(self.oldname:GetText())
		self.name:SetWidth(C.nameplate.width * offset - 14)
	end

	-- self.healthBar.hpBackground:SetVertexColor(self.r, self.g, self.b, 0.30)
	self.healthBar.hpBackground:SetVertexColor(0.15, 0.15, 0.15, 0.65)

	self.castBar:ClearAllPoints()
	self.castBar:SetPoint("TOP", self.healthBar, "BOTTOM", 0, -8)
	self.castBar:SetHeight(C.nameplate.height * offset)
	self.castBar:SetWidth(C.nameplate.width * offset)

	self.castBar.cbBackground:SetVertexColor(0.15, 0.15, 0.15, 0.65)

	self.highlight:ClearAllPoints()
	self.highlight:SetAllPoints(self.healthBar)

	local level, mylevel = tonumber(self.level:GetText()), UnitLevel("player")
	self.level:ClearAllPoints()
	self.level:SetPoint("LEFT", self.name, "RIGHT", 0, 0)
	if self.boss:IsShown() then
		if mylevel >= 70 then
			self.level:SetText("B")
		else
			self.level:SetText("??")
		end
		self.level:SetTextColor(0.8, 0.05, 0)
		self.level:Show()
	elseif level == mylevel then
		self.level:Show()
	else
		self.level:SetText(level..(elite and "+" or ""))
	end
end

local fixCastbar = function(self)
	self.castbarOverlay:Hide()
	self:SetHeight(C.nameplate.height * offset)
	self:ClearAllPoints()
	self:SetPoint("TOPLEFT", self.healthBar, "BOTTOMLEFT", 0, -8)
	self:SetPoint("BOTTOMRIGHT", self.healthBar, "BOTTOMRIGHT", 0, -C.nameplate.height-8)
end

--[[
local colorCastBar = function(self, shielded)
	if shielded then
		self:SetStatusBarColor(0.8, 0.05, 0.05)
		self.cbGlow:SetBackdropBorderColor(0.8, 0.05, 0.05)
		self.icGlow:SetBackdropBorderColor(0.8, 0.05, 0.05)
	else
		self.cbGlow:SetBackdropBorderColor(unpack(C.media.border_color))
		self.icGlow:SetBackdropBorderColor(unpack(C.media.border_color))
	end
end
--]]
local colorCastBar = function(self)
	self.cbGlow:SetBackdropBorderColor(unpack(C.media.border_color))
	self.icGlow:SetBackdropBorderColor(unpack(C.media.border_color))
end

local onSizeChanged = function(self)
	self.needFix = true
end

local onValueChanged = function(self, curValue)
	updateTime(self, curValue)
	if self.needFix then
		fixCastbar(self)
		self.needFix = nil
	end
end

local onShow = function(self)
	self.channeling  = UnitChannelInfo("target")
	fixCastbar(self)
	colorCastBar(self)
end

local onHide = function(self)
	self.highlight:Hide()
end

local onEvent = function(self, event, unit)
	if unit == "target" then
		if self:IsShown() then
			colorCastBar(self)
		end
	end
end

local createPlate = function(frame)
	if frame.done then return end

	frame.nameplate = true

	frame.healthBar, frame.castBar = frame:GetChildren()
	local healthBar, castBar = frame.healthBar, frame.castBar
	local overlayRegion, castbarOverlay, spellIconRegion, highlightRegion, nameTextRegion, levelTextRegion, bossIconRegion, raidIconRegion = frame:GetRegions()
	frame.oldhealth = healthBar

	frame.oldname = nameTextRegion
	nameTextRegion:Hide()

	local backdrop = {
		bgFile = C.media.blank, 
		edgeFile = C.media.blank, 
		tile = false, tileSize = 0, edgeSize = 1 * offset, 
		insets = { left = -1 * offset, right = -1 * offset, top = -1 * offset, bottom = -1 * offset}
	}

	local newNameRegion = frame:CreateFontString()
	newNameRegion:SetPoint("BOTTOM", healthBar, "TOP", 0, 4)
	newNameRegion:SetFont(C.font.nameplates_font, C.font.nameplates_font_size * offset, C.font.nameplates_font_style)
	newNameRegion:SetShadowOffset(C.font.nameplates_font_shadow and 1 or 0, C.font.nameplates_font_shadow and -1 or 0)
	newNameRegion:SetTextColor(1, 1, 1)
	if C.nameplate.name_abbrev ~= true then
		newNameRegion:SetWidth(C.nameplate.width * offset)
		newNameRegion:SetHeight(C.font.nameplates_font_size * offset)
	end
	frame.name = newNameRegion

	frame.level = levelTextRegion
	levelTextRegion:SetFont(C.font.nameplates_font, C.font.nameplates_font_size * offset, C.font.nameplates_font_style)
	levelTextRegion:SetShadowOffset(C.font.nameplates_font_shadow and 1 or 0, C.font.nameplates_font_shadow and -1 or 0)

	healthBar:SetStatusBarTexture(C.media.texture)

	healthBar.hpBackground = healthBar:CreateTexture(nil, "BORDER")
	healthBar.hpBackground:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -1 * offset, 1 * offset)
	healthBar.hpBackground:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 1 * offset, -1 * offset)
	healthBar.hpBackground:SetTexture(C.media.texture)
	-- healthBar.hpBackground:SetVertexColor(0.15, 0.15, 0.15)
	healthBar.hpBackground:SetVertexColor(0.15, 0.15, 0.15, 0.65)

	healthBar.hpGlow = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlow:SetBackdrop(backdrop)
	healthBar.hpGlow:SetBackdropColor(unpack(C.media.backdrop_color))
	healthBar.hpGlow:SetBackdropBorderColor(unpack(C.media.border_color))
	healthBar.hpGlow:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -2 * offset, 2 * offset)
	healthBar.hpGlow:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 2 * offset, -2 * offset)
	healthBar.hpGlow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)

	healthBar.hpGlowBorder = CreateFrame("Frame", nil, healthBar)
	healthBar.hpGlowBorder:SetBackdrop(backdrop)
	healthBar.hpGlowBorder:SetBackdropColor(unpack(C.media.backdrop_color))
	healthBar.hpGlowBorder:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.65)
	healthBar.hpGlowBorder:SetPoint("TOPLEFT", healthBar, "TOPLEFT", -3 * offset, 3 * offset)
	healthBar.hpGlowBorder:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 3 * offset, -3 * offset)
	healthBar.hpGlowBorder:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)

	if C.nameplate.health_value == true then
		healthBar.percent = healthBar:CreateFontString(nil, "OVERLAY")
		healthBar.percent:SetFont(C.font.nameplates_font, C.font.nameplates_font_size * offset, C.font.nameplates_font_style)
		healthBar.percent:SetShadowOffset(C.font.nameplates_font_shadow and 1 or 0, C.font.nameplates_font_shadow and -1 or 0)
		healthBar.percent:SetPoint("RIGHT", healthBar, "RIGHT", 0, 0)
		healthBar.percent:SetTextColor(1, 1, 1)
		healthBar.percent:SetJustifyH("RIGHT")
	end
	castBar.castbarOverlay = castbarOverlay
	castBar.healthBar = healthBar
	castBar:SetStatusBarTexture(C.media.texture)

	castBar:HookScript("OnShow", onShow)
	castBar:HookScript("OnSizeChanged", onSizeChanged)
	castBar:HookScript("OnValueChanged", onValueChanged)
	castBar:HookScript("OnEvent", onEvent)

	castBar.time = castBar:CreateFontString(nil, "ARTWORK")
	castBar.time:SetFont(C.font.nameplates_font, C.font.nameplates_font_size * offset, C.font.nameplates_font_style)
	castBar.time:SetShadowOffset(C.font.nameplates_font_shadow and 1 or 0, C.font.nameplates_font_shadow and -1 or 0)
	castBar.time:SetPoint("RIGHT", castBar, "RIGHT", 0, 0)
	castBar.time:SetJustifyH("RIGHT")

	if C.nameplate.show_castbar_name == true then
		castBar.castName = castBar:CreateFontString(nil, "OVERLAY")
		castBar.castName:SetFont(C.font.nameplates_font, C.font.nameplates_font_size * offset, C.font.nameplates_font_style)
		castBar.castName:SetShadowOffset(C.font.nameplates_font_shadow and 1 or 0, C.font.nameplates_font_shadow and -1 or 0)
		castBar.castName:SetHeight(C.nameplate.height)
		castBar.castName:SetWidth(C.nameplate.width - 27)
		castBar.castName:SetPoint("LEFT", castBar, "LEFT", 2, 0)
		castBar.castName:SetTextColor(1, 1, 1)
		castBar.castName:SetJustifyH("LEFT")
	end

	castBar.cbBackground = castBar:CreateTexture(nil, "BORDER")
	castBar.cbBackground:SetPoint("TOPLEFT", castBar, "TOPLEFT", -1 * offset, 1 * offset)
	castBar.cbBackground:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 1 * offset, -1 * offset)
	castBar.cbBackground:SetTexture(C.media.texture)
	castBar.cbBackground:SetVertexColor(0.15, 0.15, 0.15, 0.65)

	castBar.cbGlow = CreateFrame("Frame", nil, castBar)
	castBar.cbGlow:SetBackdrop(backdrop)
	castBar.cbGlow:SetBackdropColor(unpack(C.media.backdrop_color))
	castBar.cbGlow:SetBackdropBorderColor(unpack(C.media.border_color))
	castBar.cbGlow:SetPoint("TOPLEFT", castBar, "TOPLEFT", -2 * offset, 2 * offset)
	castBar.cbGlow:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 2 * offset, -2 * offset)
	castBar.cbGlow:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	castBar.cbGlowBorder = CreateFrame("Frame", nil, castBar)
	castBar.cbGlowBorder:SetBackdrop(backdrop)
	castBar.cbGlowBorder:SetBackdropColor(unpack(C.media.backdrop_color))
	castBar.cbGlowBorder:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.65)
	castBar.cbGlowBorder:SetPoint("TOPLEFT", castBar, "TOPLEFT", -3 * offset, 3 * offset)
	castBar.cbGlowBorder:SetPoint("BOTTOMRIGHT", castBar, "BOTTOMRIGHT", 3 * offset, -3 * offset)
	castBar.cbGlowBorder:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	castBar.Holder = CreateFrame("Frame", nil, castBar)
	castBar.Holder:SetFrameLevel(castBar.Holder:GetFrameLevel() + 1)
	castBar.Holder:SetAllPoints()

	-- Some frame strata dancing
	castBar.Hold = CreateFrame("Frame", nil, healthBar)
	castBar.Hold:SetPoint("TOPLEFT", healthBar, "TOPLEFT", 0, 0)
	castBar.Hold:SetPoint("BOTTOMRIGHT", healthBar, "BOTTOMRIGHT", 0, 0)
	castBar.Hold:SetFrameLevel(10)
	castBar.Hold:SetFrameStrata("MEDIUM")	

	if C.nameplate.class_icons == true then
		local cIconTex = castBar.Hold:CreateTexture(nil, "OVERLAY")
		cIconTex:SetPoint("TOPRIGHT", healthBar, "TOPLEFT", -8, 2)
		cIconTex:SetTexture("Interface\\WorldStateFrame\\Icons-Classes")
		cIconTex:SetHeight((C.nameplate.height * 2) + 11)
		cIconTex:SetWidth((C.nameplate.height * 2) + 11)
		frame.icon = cIconTex	

		frame.icon.Glow = CreateFrame("Frame", nil, frame)
		frame.icon.Glow:SetBackdrop(backdrop)
		frame.icon.Glow:SetBackdropColor(unpack(C.media.backdrop_color))
		frame.icon.Glow:SetBackdropBorderColor(unpack(C.media.border_color))
		frame.icon.Glow:SetPoint("TOPLEFT", frame.icon, "TOPLEFT", 0, 0)
		frame.icon.Glow:SetPoint("BOTTOMRIGHT", frame.icon, "BOTTOMRIGHT", 0, 0)
		frame.icon.Glow:SetFrameLevel(healthBar:GetFrameLevel() -1 > 0 and healthBar:GetFrameLevel() -1 or 0)
		frame.icon.Glow:Hide()
	end

	spellIconRegion:ClearAllPoints()
	spellIconRegion:SetParent(castBar)
	spellIconRegion:SetTexCoord(0.1, 0.9, 0.1, 0)
	spellIconRegion:SetPoint("TOPLEFT", healthBar, "TOPRIGHT", 10, 0)
	spellIconRegion:SetSize((C.nameplate.height * 2) + 7, (C.nameplate.height * 2) + 7)

	spellIconRegion.iconBackground = castBar:CreateTexture(nil, "BORDER")
	spellIconRegion.iconBackground:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", -1 * offset, 1 * offset)
	spellIconRegion.iconBackground:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", 1 * offset, -1 * offset)
	spellIconRegion.iconBackground:SetTexture(C.media.texture)
	spellIconRegion.iconBackground:SetVertexColor(0.15, 0.15, 0.15, 0.65)

	spellIconRegion.IconBackdrop = CreateFrame("Frame", nil, castBar)
	spellIconRegion.IconBackdrop:SetBackdrop(backdrop)
	spellIconRegion.IconBackdrop:SetBackdropColor(unpack(C.media.backdrop_color))
	spellIconRegion.IconBackdrop:SetBackdropBorderColor(unpack(C.media.border_color))
	spellIconRegion.IconBackdrop:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", -2, 2)
	spellIconRegion.IconBackdrop:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", 2, -2)
	spellIconRegion.IconBackdrop:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	spellIconRegion.IconBackdropBorder = CreateFrame("Frame", nil, castBar)
	spellIconRegion.IconBackdropBorder:SetBackdrop(backdrop)
	spellIconRegion.IconBackdropBorder:SetBackdropColor(unpack(C.media.backdrop_color))
	spellIconRegion.IconBackdropBorder:SetBackdropBorderColor(0.15, 0.15, 0.15, 0.65)
	spellIconRegion.IconBackdropBorder:SetPoint("TOPLEFT", spellIconRegion, "TOPLEFT", -3, 3)
	spellIconRegion.IconBackdropBorder:SetPoint("BOTTOMRIGHT", spellIconRegion, "BOTTOMRIGHT", 3, -3)
	spellIconRegion.IconBackdropBorder:SetFrameLevel(castBar:GetFrameLevel() -1 > 0 and castBar:GetFrameLevel() -1 or 0)

	highlightRegion:SetTexture(C.media.texture)
	highlightRegion:SetVertexColor(0.25, 0.25, 0.25)
	frame.highlight = highlightRegion

	raidIconRegion:ClearAllPoints()
	raidIconRegion:SetPoint("CENTER", healthBar, "CENTER", 0, 35)
	raidIconRegion:SetSize(25, 25)

	frame.oldglow = overlayRegion
	frame.boss = bossIconRegion
	castBar.icGlow = spellIconRegion.IconBackdrop

	frame.done = true

	overlayRegion:SetTexture(nil)
	castbarOverlay:SetTexture(nil)
	bossIconRegion:SetTexture(nil)

	updatePlate(frame)
	frame:SetScript("OnShow", updatePlate)
	frame:SetScript("OnHide", onHide)

	frame.elapsed = 0
	frame:SetScript("OnUpdate", threatUpdate)

	if C.nameplate.class_icons == true then
		frame:HookScript("OnUpdate", UpdateClass)
	end
end

-- Update class function
if C.nameplate.class_icons == true then
	function UpdateClass(frame)
		local r, g, b = frame.healthBar:GetStatusBarColor()
		local r, g, b = floor(r*100+.5)/100, floor(g*100+.5)/100, floor(b*100+.5)/100
		local classname = ""
		local hasclass = 0
		for class, color in pairs(RAID_CLASS_COLORS) do
			if RAID_CLASS_COLORS[class].r == r and RAID_CLASS_COLORS[class].g == g and RAID_CLASS_COLORS[class].b == b then
				classname = class
			end
		end
		if (classname) then
			texcoord = CLASS_BUTTONS[classname]
			if texcoord then
				hasclass = 1
			else
				texcoord = {0.5, 0.75, 0.5, 0.75}
				hasclass = 0
			end
		else
			texcoord = {0.5, 0.75, 0.5, 0.75}
			hasclass = 0
		end
		frame.icon:SetTexCoord(texcoord[1],texcoord[2],texcoord[3],texcoord[4])
		if hasclass == 1 then
			frame.icon.Glow:Show()
		else
			frame.icon.Glow:Hide()
		end
	end
end

local numKids = 0
NamePlates:SetScript("OnUpdate", function(self, elapsed)
	local newNumKids = WorldFrame:GetNumChildren()
	if newNumKids ~= numKids then
		for i = numKids + 1, newNumKids do
			local frame = select(i, WorldFrame:GetChildren())

			if isValidFrame(frame) then
				createPlate(frame)
			end
		end
		numKids = newNumKids
	end
end)

-- Only show nameplates when in combat
if C.nameplate.combat == true then
	NamePlates:RegisterEvent("PLAYER_REGEN_ENABLED")
	NamePlates:RegisterEvent("PLAYER_REGEN_DISABLED")

	function NamePlates:PLAYER_REGEN_ENABLED()
		SetCVar("nameplateShowEnemies", 0)
	end

	function NamePlates:PLAYER_REGEN_DISABLED()
		SetCVar("nameplateShowEnemies", 1)
	end
end

NamePlates:RegisterEvent("PLAYER_ENTERING_WORLD")
function NamePlates:PLAYER_ENTERING_WORLD()
	if C.nameplate.combat == true then
		if InCombatLockdown() then
			SetCVar("nameplateShowEnemies", 1)
		else
			SetCVar("nameplateShowEnemies", 0)
		end
	end
	--[[
	if C.nameplate.enhance_threat == true then
		SetCVar("threatWarning", 3)
	end
	--]]
end