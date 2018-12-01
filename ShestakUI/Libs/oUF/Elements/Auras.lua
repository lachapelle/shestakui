--[[
# Element: Auras

Handles creation and updating of aura icons.

## Widget

Auras   - A Frame to hold `Button`s representing both buffs and debuffs.
Buffs   - A Frame to hold `Button`s representing buffs.
Debuffs - A Frame to hold `Button`s representing debuffs.

## Notes

At least one of the above widgets must be present for the element to work.

## Options

.disableMouse       - Disables mouse events (boolean)
.disableCooldown    - Disables the cooldown spiral (boolean)
.size               - Aura icon size. Defaults to 16 (number)
.onlyShowPlayer     - Shows only auras created by player/vehicle (boolean)
.showStealableBuffs - Displays the stealable texture on buffs that can be stolen (boolean)
.spacing            - Spacing between each icon. Defaults to 0 (number)
.['spacing-x']      - Horizontal spacing between each icon. Takes priority over `spacing` (number)
.['spacing-y']      - Vertical spacing between each icon. Takes priority over `spacing` (number)
.['growth-x']       - Horizontal growth direction. Defaults to 'RIGHT' (string)
.['growth-y']       - Vertical growth direction. Defaults to 'UP' (string)
.initialAnchor      - Anchor point for the icons. Defaults to 'BOTTOMLEFT' (string)
.filter             - Custom filter list for auras to display. Defaults to 'HELPFUL' for buffs and 'HARMFUL' for
                      debuffs (string)

## Options Auras

.numBuffs     - The maximum number of buffs to display. Defaults to 32 (number)
.numDebuffs   - The maximum number of debuffs to display. Defaults to 40 (number)
.numTotal     - The maximum number of auras to display. Prioritizes buffs over debuffs. Defaults to the sum of
                .numBuffs and .numDebuffs (number)
.gap          - Controls the creation of an invisible icon between buffs and debuffs. Defaults to false (boolean)
.buffFilter   - Custom filter list for buffs to display. Takes priority over `filter` (string)
.debuffFilter - Custom filter list for debuffs to display. Takes priority over `filter` (string)

## Options Buffs

.num - Number of buffs to display. Defaults to 32 (number)

## Options Debuffs

.num - Number of debuffs to display. Defaults to 40 (number)

## Attributes

button.caster   - the unit who cast the aura (string)
button.filter   - the filter list used to determine the visibility of the aura (string)
button.isDebuff - indicates if the button holds a debuff (boolean)
button.isPlayer - indicates if the aura caster is the player or their vehicle (boolean)

## Examples

    -- Position and size
    local Buffs = CreateFrame('Frame', nil, self)
    Buffs:SetPoint('RIGHT', self, 'LEFT')
    Buffs:SetSize(16 * 2, 16 * 16)

    -- Register with oUF
    self.Buffs = Buffs
--]]

local ns = oUF
local oUF = ns.oUF

local tinsert = table.insert
local floor = math.floor

local CreateFrame = CreateFrame
local GetTime = GetTime
local UnitAura = UnitAura

local VISIBLE = 1
local HIDDEN = 0

local function UpdateTooltip(self)
	-- GameTooltip:SetUnitAura(self:GetParent().__owner.unit, self:GetID(), self.filter)
	if self.filter == 'HELPFUL' then
		GameTooltip:SetUnitBuff(self:GetParent().__owner.unit, self:GetID(), self.filter)
	else
		GameTooltip:SetUnitDebuff(self:GetParent().__owner.unit, self:GetID(), self.filter)
	end
end

local function onEnter(self)
	if(not self:IsVisible()) then return end

	GameTooltip:SetOwner(self, 'ANCHOR_BOTTOMRIGHT')
	self:UpdateTooltip()
end

local function onLeave()
	GameTooltip:Hide()
end

local function createAuraIcon(element, index)
	local button = CreateFrame('Button', '$parentButton' .. index, element)
	button:EnableMouse(true)
	button:RegisterForClicks('RightButtonUp')

	-- local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'CooldownFrameTemplate')
	local cd = CreateFrame('Cooldown', '$parentCooldown', button, 'oUF_CooldownFrameTemplate')
	cd:SetAllPoints()

	local icon = button:CreateTexture(nil, 'BORDER')
	icon:SetAllPoints()

	local count = button:CreateFontString(nil, 'OVERLAY', 'NumberFontNormal')
	count:SetPoint('BOTTOMRIGHT', button, 'BOTTOMRIGHT', -1, 0)

	local overlay = button:CreateTexture(nil, 'OVERLAY')
	overlay:SetTexture([[Interface\Buttons\UI-Debuff-Overlays]])
	overlay:SetAllPoints()
	overlay:SetTexCoord(.296875, .5703125, 0, .515625)
	button.overlay = overlay

	-- local stealable = button:CreateTexture(nil, 'OVERLAY')
	-- stealable:SetTexture([[Interface\TargetingFrame\UI-TargetingFrame-Stealable]])
	-- stealable:SetPoint('TOPLEFT', -3, 3)
	-- stealable:SetPoint('BOTTOMRIGHT', 3, -3)
	-- stealable:SetBlendMode('ADD')
	-- button.stealable = stealable

	button.UpdateTooltip = UpdateTooltip
	button:SetScript('OnEnter', onEnter)
	button:SetScript('OnLeave', onLeave)

	button.icon = icon
	button.count = count
	button.cd = cd

	--[[ Callback: Auras:PostCreateIcon(button)
	Called after a new aura button has been created.

	* self   - the widget holding the aura buttons
	* button - the newly created aura button (Button)
	--]]
	if(element.PostCreateIcon) then element:PostCreateIcon(button) end

	return button
end

local function customFilter(element, unit, button, name)
	-- if((element.onlyShowPlayer and button.isPlayer) or (not element.onlyShowPlayer and name)) then
	if(name) then
		return true
	end
end

local function updateIcon(element, unit, index, offset, filter, isDebuff, visible)
	--[[
	local name, rank, texture, count, debuffType, duration, expiration, caster, isStealable,
		nameplateShowSelf, spellID, canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,
		timeMod, effect1, effect2, effect3 = UnitAura(unit, index, filter)
	--]]

	local name, rank, texture, count, debuffType, duration, expiration = UnitAura(unit, index, filter)
	--[[
	if isDebuff then
		name, rank, texture, count, debuffType, duration, expiration = UnitDebuff(unit, index, filter)
	else
		name, rank, texture, count, duration, expiration = UnitBuff(unit, index, filter)
	end
	--]]

	-- Correction if count is nil
	count = count or 0

	if element.forceShow then
		name, rank, texture = GetSpellInfo(26993)
		count, debuffType, duration, expiration = 5, 'Magic', 0, 60
	end

	if(name) then
		local position = visible + offset + 1
		local button = element[position]
		if(not button) then
			--[[ Override: Auras:CreateIcon(position)
			Used to create the aura button at a given position.

			* self     - the widget holding the aura buttons
			* position - the position at which the aura button is to be created (number)

			## Returns

			* button - the button used to represent the aura (Button)
			--]]
			button = (element.CreateIcon or createAuraIcon) (element, position)

			-- table.insert(element, button)
			tinsert(element, button)
			element.createdIcons = element.createdIcons + 1
		end

		button.caster = caster
		button.filter = filter
		button.isDebuff = isDebuff
		-- button.isPlayer = caster == 'player' or caster == 'vehicle'

		--[[ Override: Auras:CustomFilter(unit, button, ...)
		Defines a custom filter that controls if the aura button should be shown.

		* self   - the widget holding the aura buttons
		* unit   - the unit on which the aura is cast (string)
		* button - the button displaying the aura (Button)
		* ...    - the return values from [UnitAura](http://wowprogramming.com/docs/api/UnitAura.htmll)

		## Returns

		* show - indicates whether the aura button should be shown (boolean)
		--]]
		--[[
		local show = (element.CustomFilter or customFilter) (element, unit, button, name, rank, texture,
			count, debuffType, duration, expiration, caster, isStealable, nameplateShowSelf, spellID,
			canApply, isBossDebuff, casterIsPlayer, nameplateShowAll,timeMod, effect1, effect2, effect3)
		--]]

		local show = true
		if not element.forceShow then
			show = (element.CustomFilter or customFilter) (element, unit, button, name, rank, texture, count, debuffType, duration, expiration)
		end

		if(show) then
			-- We might want to consider delaying the creation of an actual cooldown
			-- object to this point, but I think that will just make things needlessly
			-- complicated.
			if(button.cd and not element.disableCooldown) then
				if(duration and duration > 0) then
					button.cd:SetCooldown(GetTime() - (duration - expiration), duration)
					button.cd:Show()
				else
					button.cd:Hide()
				end
			end

			if(button.overlay) then
				if((isDebuff and element.showDebuffType) or (not isDebuff and element.showBuffType) or element.showType) then
					local color = element.__owner.colors.debuff[debuffType] or element.__owner.colors.debuff.none

					button.overlay:SetVertexColor(color[1], color[2], color[3])
					button.overlay:Show()
				else
					button.overlay:Hide()
				end
			end

			--[[
			if(button.stealable) then
				if(not isDebuff and isStealable and element.showStealableBuffs and not UnitIsUnit('player', unit)) then
					button.stealable:Show()
				else
					button.stealable:Hide()
				end
			end
			--]]

			if(button.icon) then button.icon:SetTexture(texture) end
			if(button.count) then button.count:SetText(count > 1 and count) end

			local size = element.size or 16
			button:SetSize(size, size)

			button:EnableMouse(not element.disableMouse)
			button:SetID(index)
			button:Show()

			--[[ Callback: Auras:PostUpdateIcon(unit, button, index, position)
			Called after the aura button has been updated.

			* self        - the widget holding the aura buttons
			* unit        - the unit on which the aura is cast (string)
			* button      - the updated aura button (Button)
			* index       - the index of the aura (number)
			* position    - the actual position of the aura button (number)
			* duration    - the aura duration in seconds (number?)
			* expiration  - the point in time when the aura will expire. Comparable to GetTime() (number)
			* debuffType  - the debuff type of the aura (string?)['Curse', 'Disease', 'Magic', 'Poison']
			* isStealable - whether the aura can be stolen or purged (boolean)
			--]]
			if(element.PostUpdateIcon) then
				-- element:PostUpdateIcon(unit, button, index, position, duration, expiration, debuffType, isStealable)
				element:PostUpdateIcon(unit, button, index, position, duration, expiration, debuffType)
			end

			return VISIBLE
		else
			return HIDDEN
		end
	end
end

local function SetPositionOld(element, from, to)
	local sizex = (element.size or 16) + (element['spacing-x'] or element.spacing or 0)
	local sizey = (element.size or 16) + (element['spacing-y'] or element.spacing or 0)
	local anchor = element.initialAnchor or 'BOTTOMLEFT'
	local growthx = (element['growth-x'] == 'LEFT' and -1) or 1
	local growthy = (element['growth-y'] == 'DOWN' and -1) or 1
	local cols = math.floor(element:GetWidth() / sizex + 0.5)

	for i = from, to do
		local button = element[i]

		-- Bail out if the to range is out of scope.
		if(not button) then break end
		local col = (i - 1) % cols
		local row = math.floor((i - 1) / cols)

		button:ClearAllPoints()
		button:SetPoint(anchor, element, anchor, col * sizex * growthx, row * sizey * growthy)
	end
end

local SetPosition = function(element, x)
	if(element and x > 0) then
		local col = 0
		local row = 0
		local gap = element.gap
		local sizex = (element.size or 16) + (element['spacing-x'] or element.spacing or 0)
		local sizey = (element.size or 16) + (element['spacing-y'] or element.spacing or 0)
		local anchor = element.initialAnchor or "BOTTOMLEFT"
		local growthx = (element["growth-x"] == "LEFT" and -1) or 1
		local growthy = (element["growth-y"] == "DOWN" and -1) or 1
		local cols = math.floor(element:GetWidth() / sizex + .5)
		local rows = math.floor(element:GetHeight() / sizey + .5)

		for i = 1, #element do
			local button = element[i]
			if(button and button:IsShown()) then
				if(gap and button.isDebuff) then
					if(col > 0) then
						col = col + 1
					end

					gap = false
				end

				if(col >= cols) then
					col = 0
					row = row + 1
				end
				button:ClearAllPoints()
				button:SetPoint(anchor, element, anchor, col * sizex * growthx, row * sizey * growthy)

				col = col + 1
			elseif(not button) then
				break
			end
		end
	end
end

local function filterIcons(element, unit, filter, limit, isDebuff, offset, dontHide)
	if(not offset) then offset = 0 end
	local index = 1
	local visible = 0
	local hidden = 0
	while(visible < limit) do
		local result = updateIcon(element, unit, index, offset, filter, isDebuff, visible)
		if(not result) then
			break
		elseif(result == VISIBLE) then
			visible = visible + 1
		elseif(result == HIDDEN) then
			hidden = hidden + 1
		end

		index = index + 1
	end

	if(not dontHide) then
		for i = visible + offset + 1, #element do
			element[i]:Hide()
		end
	end

	return visible, hidden
end

local function UpdateAuras(self, event, unit)
	if(self.unit ~= unit) then return end

	local auras = self.Auras
	if(auras) then
		--[[ Callback: Auras:PreUpdate(unit)
		Called before the element has been updated.

		* self - the widget holding the aura buttons
		* unit - the unit for which the update has been triggered (string)
		--]]
		if(auras.PreUpdate) then auras:PreUpdate(unit) end

		local numBuffs = auras.numBuffs or 32
		local numDebuffs = auras.numDebuffs or 40
		local max = auras.numTotal or numBuffs + numDebuffs

		local pvb = auras.visibleBuffs
		local visibleBuffs, hiddenBuffs = filterIcons(auras, unit, auras.buffFilter or auras.filter or 'HELPFUL', math.min(numBuffs, max), nil, 0, true)
		auras.visibleBuffs = visibleBuffs

		local pvd = auras.visibleDebuffs
		local visibleDebuffs, hiddenDebuffs = filterIcons(auras, unit, auras.debuffFilter or auras.filter or 'HARMFUL', math.min(numDebuffs, max - visibleBuffs), true, visibleBuffs)
		auras.visibleDebuffs = visibleDebuffs

		auras.visibleAuras = auras.visibleBuffs + auras.visibleDebuffs

		if(auras.PreSetPosition) then
			auras:PreSetPosition(max)
		end

		local hiddenAuras = hiddenBuffs + hiddenDebuffs
		if(
			auras.PreSetPosition or
			hiddenAuras > 0 or
			(auras.gap and (visibleBuffs ~= pvb or visibleDebuffs ~= pvd)) or
			auras.createdIcons > auras.anchoredIcons
		)
		then
			(auras.SetPosition or SetPosition) (auras, max)
			auras.anchoredIcons = auras.createdIcons
		end

		if(auras.PostUpdate) then auras:PostUpdate(unit) end
	end

	local buffs = self.Buffs
	if(buffs) then
		if(buffs.PreUpdate) then buffs:PreUpdate(unit) end

		local numBuffs = buffs.num or 32
		local visibleBuffs, hiddenBuffs = filterIcons(buffs, unit, buffs.filter or 'HELPFUL', numBuffs)
		buffs.visibleBuffs = visibleBuffs

		if(buffs.PreSetPosition) then
			buffs:PreSetPosition(numBuffs)
		end

		if(buffs.PreSetPosition or hiddenBuffs > 0 or buffs.createdIcons > buffs.anchoredIcons) then
			(buffs.SetPosition or SetPosition) (buffs, numBuffs)
			buffs.anchoredIcons = buffs.createdIcons
		end

		if(buffs.PostUpdate) then buffs:PostUpdate(unit) end
	end

	local debuffs = self.Debuffs
	if(debuffs) then
		if(debuffs.PreUpdate) then debuffs:PreUpdate(unit) end

		local numDebuffs = debuffs.num or 40
		local visibleDebuffs, hiddenDebuffs = filterIcons(debuffs, unit, debuffs.filter or 'HARMFUL', numDebuffs, true)
		debuffs.visibleDebuffs = visibleDebuffs

		if(debuffs.PreSetPosition) then
			debuffs:PreSetPosition(numDebuffs)
		end

		if(debuffs.PreSetPosition or hiddenDebuffs > 0 or debuffs.createdIcons > debuffs.anchoredIcons) then
			(debuffs.SetPosition or SetPosition) (debuffs, numDebuffs)
			debuffs.anchoredIcons = debuffs.createdIcons
		end

		if(debuffs.PostUpdate) then debuffs:PostUpdate(unit) end
	end
end

local function Update(self, event, unit)
	if(self.unit ~= unit) then return end

	UpdateAuras(self, event, unit)

	-- Assume no event means someone wants to re-anchor things. This is usually
	-- done by UpdateAllElements and :ForceUpdate.
	if(event == 'ForceUpdate' or not event) then
		local buffs = self.Buffs
		if(buffs) then
			(buffs.SetPosition or SetPosition) (buffs, 1, buffs.createdIcons)
		end

		local debuffs = self.Debuffs
		if(debuffs) then
			(debuffs.SetPosition or SetPosition) (debuffs, 1, debuffs.createdIcons)
		end

		local auras = self.Auras
		if(auras) then
			(auras.SetPosition or SetPosition) (auras, 1, auras.createdIcons)
		end
	end
end

local function ForceUpdate(element)
	return Update(element.__owner, 'ForceUpdate', element.__owner.unit)
end

local function Enable(self)
	if(self.Buffs or self.Debuffs or self.Auras) then
		self:RegisterEvent('UNIT_AURA', UpdateAuras)

		local buffs = self.Buffs
		if(buffs) then
			buffs.__owner = self
			buffs.ForceUpdate = ForceUpdate

			buffs.createdIcons = buffs.createdIcons or 0
			buffs.anchoredIcons = 0

			-- buffs:Show()
		end

		local debuffs = self.Debuffs
		if(debuffs) then
			debuffs.__owner = self
			debuffs.ForceUpdate = ForceUpdate

			debuffs.createdIcons = debuffs.createdIcons or 0
			debuffs.anchoredIcons = 0

			-- debuffs:Show()
		end

		local auras = self.Auras
		if(auras) then
			auras.__owner = self
			auras.ForceUpdate = ForceUpdate

			auras.createdIcons = auras.createdIcons or 0
			auras.anchoredIcons = 0

			-- auras:Show()
		end

		return true
	end
end

local function Disable(self)
	if(self.Buffs or self.Debuffs or self.Auras) then
		self:UnregisterEvent('UNIT_AURA', UpdateAuras)

		if(self.Buffs) then self.Buffs:Hide() end
		if(self.Debuffs) then self.Debuffs:Hide() end
		if(self.Auras) then self.Auras:Hide() end
	end
end

oUF:AddElement('Auras', Update, Enable, Disable)