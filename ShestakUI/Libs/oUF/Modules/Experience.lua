local T, C, L = unpack(select(2, ShestakAddonInfo()))
if C.unitframe.enable ~= true or C.unitframe.plugins_experience_bar ~= true then return end

----------------------------------------------------------------------------------------
--	Based on oUF_Experience(by p3lim)
----------------------------------------------------------------------------------------
local ns = oUF
local oUF = ns.oUF

for tag, func in next, {
	['experience:cur'] = function(unit)
		return UnitXP('player')
	end,
	['experience:max'] = function(unit)
		return UnitXPMax('player')
	end,
	['experience:per'] = function(unit)
		return math.floor(_TAGS['experience:cur'](unit) / _TAGS['experience:max'](unit) * 100 + 0.5)
	end,
	['experience:currested'] = function()
		return GetXPExhaustion()
	end,
	['experience:perrested'] = function(unit)
		local rested = _TAGS['experience:currested']()
		if(rested and rested > 0) then
			return math.floor(rested / _TAGS['experience:max'](unit) * 100 + 0.5)
		end
	end,
} do
	oUF.Tags.Methods[tag] = func
	oUF.Tags.Events[tag] = 'PLAYER_XP_UPDATE PLAYER_LEVEL_UP UPDATE_EXHAUSTION'
end

oUF.Tags.SharedEvents.PLAYER_LEVEL_UP = true

local function UpdateTooltip(element)
	local cur = UnitXP('player')
	local max = UnitXPMax('player')
	local per = math.floor(cur / max * 100 + 0.5)
	local bar = 20
	local rested = GetXPExhaustion() or 0

	GameTooltip:SetOwner(element, "ANCHOR_BOTTOM", 0, -5)
	GameTooltip:AddLine(COMBAT_XP_GAIN.." "..format(LEVEL_GAINED, T.level))
	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(string.format(L_STATS_CURRENT_XP..": %d / %d (%d%% - %d/%d)", cur, max, per, bar - (bar * (max - cur) / max), bar))
	GameTooltip:AddLine(string.format(L_STATS_REMAINING_XP..": %d (%d%% - %d/%d)", max - cur, (max - cur) / max * 100, 1 + bar * (max - cur) / max, bar))
	GameTooltip:AddLine(string.format("|cff0090ff"..L_STATS_RESTED_XP..": +%d (%d%%)", rested, rested / max * 100))

	GameTooltip:Show()
end

local function OnEnter(element)
	element:SetAlpha(element.inAlpha)
	GameTooltip:SetOwner(element, element.tooltipAnchor)
	element:UpdateTooltip()
end

local function OnLeave(element)
	GameTooltip:Hide()
	element:SetAlpha(element.outAlpha)
end

local function UpdateColor(element)
	element:SetStatusBarColor(T.color.r, T.color.g, T.color.b)
	if element.SetAnimatedTextureColors then
		element:SetAnimatedTextureColors(T.color.r, T.color.g, T.color.b)
	end
	if element.Rested then
		element.Rested:SetStatusBarColor(0, 0.5, 1, 0.5)
	end
end

local function Update(self, event, unit)
	if(self.unit ~= unit or unit ~= 'player') then return end

	local element = self.Experience
	if(element.PreUpdate) then element:PreUpdate(unit) end

	local level = UnitLevel(unit)
	local cur = UnitXP(unit)
	local max = UnitXPMax(unit)

	if(element.SetAnimatedValues) then
		element:SetAnimatedValues(cur, 0, max, level)
	else
		element:SetMinMaxValues(0, max)
		element:SetValue(cur)
	end

	local exhaustion
	if(element.Rested) then
		exhaustion = GetXPExhaustion() or 0

		element.Rested:SetMinMaxValues(0, max)
		element.Rested:SetValue(math.min(cur + exhaustion, max))
	end

	(element.OverrideUpdateColor or UpdateColor)(element)

	if(element.PostUpdate) then
		return element:PostUpdate(unit, cur, max, exhaustion, level)
	end
end

local function Path(self, ...)
	return (self.Experience.Override or Update) (self, ...)
end

local function ElementEnable(self)
	local element = self.Experience
	self:RegisterEvent('PLAYER_XP_UPDATE', Path)

	if(element.Rested) then
		self:RegisterEvent('UPDATE_EXHAUSTION', Path)
	end

	element:Show()
	element:SetAlpha(element.outAlpha or 1)

	Path(self, 'ElementEnable', 'player')
end

local function ElementDisable(self)
	self:UnregisterEvent('PLAYER_XP_UPDATE', Path)

	if(self.Experience.Rested) then
		self:UnregisterEvent('UPDATE_EXHAUSTION', Path)
	end

	self.Experience:Hide()

	Path(self, 'ElementDisable', 'player')
end

local function Visibility(self, event, unit)
	local element = self.Experience
	local shouldEnable

	if(UnitLevel('player') ~= element.__accountMaxLevel) then
		shouldEnable = true
	end

	if(shouldEnable) then
		ElementEnable(self)
	else
		ElementDisable(self)
	end
end

local function VisibilityPath(self, ...)
	return (self.Experience.OverrideVisibility or Visibility)(self, ...)
end

local function ForceUpdate(element)
	return VisibilityPath(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self, unit)
	local element = self.Experience
	if(element and unit == 'player') then
		element.__owner = self

		local levelRestriction = GetAccountExpansionLevel()
		element.__accountMaxLevel = MAX_PLAYER_LEVEL_TABLE[levelRestriction]

		element.ForceUpdate = ForceUpdate

		self:RegisterEvent('PLAYER_LEVEL_UP', VisibilityPath, true)

		local child = element.Rested
		if(child) then
			child:SetFrameLevel(element:GetFrameLevel() - 1)

			if(not child:GetStatusBarTexture()) then
				child:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
			end
		end

		if(not element:GetStatusBarTexture()) then
			element:SetStatusBarTexture([[Interface\TargetingFrame\UI-StatusBar]])
		end

		if(element:IsMouseEnabled()) then
			element.UpdateTooltip = element.UpdateTooltip or UpdateTooltip
			element.tooltipAnchor = element.tooltipAnchor or 'ANCHOR_BOTTOMRIGHT'
			element.inAlpha = element.inAlpha or 1
			element.outAlpha = element.outAlpha or 1

			if(not element:GetScript('OnEnter')) then
				element:SetScript('OnEnter', OnEnter)
			end

			if(not element:GetScript('OnLeave')) then
				element:SetScript('OnLeave', OnLeave)
			end
		end

		return true
	end
end

local function Disable(self)
	local element = self.Experience
	if(element) then
		self:UnregisterEvent('PLAYER_LEVEL_UP', VisibilityPath)

		ElementDisable(self)
	end
end

oUF:AddElement('Experience', VisibilityPath, Enable, Disable)