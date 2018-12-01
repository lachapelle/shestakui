local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.unitframe.enable ~= true then return end

----------------------------------------------------------------------------------------
--	UnitFrames based on oUF_Caellian (by Caellian)
----------------------------------------------------------------------------------------
local ns = oUF
local oUF = ns.oUF

-- Create layout
local function Shared(self, unit)
	-- Set our own colors
	self.colors = T.oUF_colors

	-- Register click
	self:RegisterForClicks("AnyUp")
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	local unit = unit

	-- Menu
	-- self.menu = T.SpawnMenu
	
	-- Backdrop for every units
	self:CreateBackdrop("Default")
	self:SetFrameStrata("BACKGROUND")
	self.backdrop:SetFrameLevel(2)

	-- Health bar
	self.Health = CreateFrame("StatusBar", self:GetName().."_Health", self)
	if unit == "player" or unit == "target" then
		self.Health:SetHeight(21)
	else
		self.Health:SetHeight(13)
	end
	self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
	self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", 0, 0)
	self.Health:SetStatusBarTexture(C.media.texture)

	self.Health.frequentUpdates = true
	if C.unitframe.own_color == true then
		self.Health.colorTapping = false
		self.Health.colorDisconnected = false
		self.Health.colorClass = false
		self.Health.colorReaction = false
		self.Health:SetStatusBarColor(unpack(C.unitframe.uf_color))
	else
		self.Health.colorTapping = true
		self.Health.colorDisconnected = true
		self.Health.colorClass = true
		self.Health.colorReaction = true
	end
	if C.unitframe.plugins_smooth_bar == true then
		self.Health.Smooth = true
	end

	self.Health.PostUpdate = T.PostUpdateHealth

	-- Health bar background
	self.Health.bg = self.Health:CreateTexture(nil, "BORDER")
	self.Health.bg:SetAllPoints()
	self.Health.bg:SetTexture(C.media.texture)
	if C.unitframe.own_color == true then
		self.Health.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
	else
		self.Health.bg.multiplier = 0.2
	end

	self.Health.value = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
	if unit == "player" or unit == "pet" or unit == "focus" then
		self.Health.value:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
		self.Health.value:SetJustifyH("RIGHT")
	else
		self.Health.value:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
		self.Health.value:SetJustifyH("LEFT")
	end

	-- Power bar
	self.Power = CreateFrame("StatusBar", self:GetName().."_Power", self)
	if unit == "player" or unit == "target" then
		self.Power:SetHeight(5)
	else
		self.Power:SetHeight(2)
	end
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
	self.Power:SetStatusBarTexture(C.media.texture)

	self.Power.frequentUpdates = true
	self.Power.colorDisconnected = true
	self.Power.colorTapping = true
	if C.unitframe.own_color == true then
		self.Power.colorClass = true
	else
		self.Power.colorPower = true
	end
	if C.unitframe.plugins_smooth_bar == true then
		self.Power.Smooth = true
	end

	self.Power.PreUpdate = T.PreUpdatePower
	self.Power.PostUpdate = T.PostUpdatePower

	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints()
	self.Power.bg:SetTexture(C.media.texture)
	if C.unitframe.own_color == true and unit == "pet" then
		self.Power.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
	else
		self.Power.bg.multiplier = 0.2
	end

	self.Power.value = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
	if unit == "player" then
		self.Power.value:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
		self.Power.value:SetJustifyH("RIGHT")
	elseif unit == "pet" or unit == "focus" or unit == "focustarget" or unit == "targettarget" then
		self.Power.value:Hide()
	else
		self.Power.value:SetPoint("LEFT", self.Power, "LEFT", 2, 0)
		self.Power.value:SetJustifyH("LEFT")
	end

	-- Names
	if unit ~= "player" then
		self.Info = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.Level = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		if unit == "target" then
			self.Info:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
			self:Tag(self.Info, "[GetNameColor][NameLong]")
			self.Level:SetPoint("RIGHT", self.Power, "RIGHT", 0, 0)
			-- self:Tag(self.Level, "[cpoints] [Threat] [DiffColor][level][shortclassification]")
			self:Tag(self.Level, "[cpoints] [DiffColor][level][shortclassification]")
		elseif unit == "focus" or unit == "pet" then
			self.Info:SetPoint("LEFT", self.Health, "LEFT", 2, 0)
			if unit == "pet" then
				self:Tag(self.Info, "[PetNameColor][NameMedium]")
			else
				self:Tag(self.Info, "[GetNameColor][NameMedium]")
			end
		else
			self.Info:SetPoint("RIGHT", self.Health, "RIGHT", 0, 0)
			self:Tag(self.Info, "[GetNameColor][NameMedium]")
		end
	end

	if unit == "player" then
		self.FlashInfo = CreateFrame("Frame", "FlashInfo", self)
		self.FlashInfo:SetScript("OnUpdate", T.UpdateManaLevel)
		self.FlashInfo:SetFrameLevel(self.Health:GetFrameLevel() + 1)
		self.FlashInfo:SetAllPoints(self.Health)

		self.FlashInfo.ManaLevel = T.SetFontString(self.FlashInfo, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.FlashInfo.ManaLevel:SetPoint("CENTER", 0, 0)

		-- Combat icon
		if C.unitframe.icons_combat == true then
			self.CombatIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.CombatIndicator:SetSize(18, 18)
			self.CombatIndicator:SetPoint("TOPRIGHT", 4, 8)
		end

		-- Resting icon
		if C.unitframe.icons_resting == true and T.level ~= MAX_PLAYER_LEVEL then
			self.RestingIndicator = self.Power:CreateTexture(nil, "OVERLAY")
			self.RestingIndicator:SetSize(18, 18)
			self.RestingIndicator:SetPoint("BOTTOMLEFT", -8, -8)
		end

		-- Leader/Assistant/ML icons
		if C.raidframe.icons_leader == true then
			-- Leader icon
			self.LeaderIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.LeaderIndicator:SetSize(14, 14)
			self.LeaderIndicator:SetPoint("TOPLEFT", -3, 9)

			-- Assistant icon
			self.AssistantIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.AssistantIndicator:SetSize(12, 12)
			self.AssistantIndicator:SetPoint("TOPLEFT", -3, 8)

			-- Master looter icon
			self.MasterLooterIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.MasterLooterIndicator:SetSize(12, 12)
			self.MasterLooterIndicator:SetPoint("TOPRIGHT", 3, 8)
		end

		-- Raid role icons
		if C.raidframe.icons_role == true then
			self.RaidRoleIndicator = self.Health:CreateTexture(nil, "OVERLAY")
			self.RaidRoleIndicator:SetSize(12, 12)
			self.RaidRoleIndicator:SetPoint("TOPLEFT", 10, 8)
		end

		-- Rogue/Druid Combo bar
		if C.unitframe_class_bar.combo == true and C.unitframe_class_bar.combo_old ~= true and (T.class == "ROGUE" or T.class == "DRUID") then
			self.ComboPoints = CreateFrame("Frame", self:GetName().."_ComboBar", self)
			self.ComboPoints:CreateBackdrop("Default")
			self.ComboPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.ComboPoints:SetSize(217, 7)

			for i = 1, 5 do
				self.ComboPoints[i] = CreateFrame("StatusBar", self:GetName().."_ComboBar", self.ComboPoints)
				self.ComboPoints[i]:SetSize(213 / 5, 7)
				if i == 1 then
					self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints)
				else
					self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints[i-1], "RIGHT", 1, 0)
				end
				self.ComboPoints[i]:SetStatusBarTexture(C.media.texture)
			end

			self.ComboPoints[1]:SetStatusBarColor(0.9, 0.1, 0.1)
			self.ComboPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
			self.ComboPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
			self.ComboPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
			self.ComboPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)

			if T.class == "DRUID" and C.unitframe_class_bar.combo_always ~= true then
				self:RegisterEvent("UPDATE_SHAPESHIFT_FORM", T.UpdateComboPoint)
			end

			self.ComboPoints.Override = T.UpdateComboPoint
		end

		-- Totem bar
		if C.unitframe_class_bar.totem == true and T.class == "SHAMAN" then
			self.TotemBar = CreateFrame("Frame", self:GetName().."_TotemBar", self)
			self.TotemBar:CreateBackdrop("Default")
			self.TotemBar:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
			self.TotemBar:SetSize(217, 7)
			self.TotemBar.Destroy = true

			for i = 1, 4 do
				self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar", self.TotemBar)
				self.TotemBar[i]:SetSize(213 / 4, 7)

				local fixpos
				if i == 2 then
					self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				elseif i == 1 then
					self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 55, 7)
				else
					fixpos = i
					if i == 3 then fixpos = i-1 end
					self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[fixpos-1], "TOPRIGHT", 1, 0)
				end
				self.TotemBar[i]:SetStatusBarTexture(C.media.texture)
				self.TotemBar[i]:SetMinMaxValues(0, 1)

				self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
				self.TotemBar[i].bg:SetAllPoints()
				self.TotemBar[i].bg:SetTexture(C.media.texture)
				self.TotemBar[i].bg.multiplier = 0.2
			end
		end

		-- Additional mana
		if T.class == "DRUID" then
			CreateFrame("Frame"):SetScript("OnUpdate", function() T.UpdateClassMana(self) end)
			self.ClassMana = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.ClassMana:SetTextColor(1, 0.49, 0.04)
		end

		-- Experience bar
		if C.unitframe.plugins_experience_bar == true then
			self.Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
			self.Experience:CreateBackdrop("Default")
			self.Experience:EnableMouse(true)
			if C.unitframe.portrait_enable == true then
				self.Experience:SetPoint("TOPLEFT", self, "TOPLEFT", -25 - C.unitframe.portrait_width, 28)
			else
				self.Experience:SetPoint("TOPLEFT", self, "TOPLEFT", -18, 28)
			end
			self.Experience:SetSize(7, 94)
			self.Experience:SetOrientation("Vertical")
			self.Experience:SetStatusBarTexture(C.media.texture)

			self.Experience.bg = self.Experience:CreateTexture(nil, "BORDER")
			self.Experience.bg:SetAllPoints()
			self.Experience.bg:SetTexture(C.media.texture)
			-- self.Experience.bg:SetVertexColor(T.color.r, T.color.g, T.color.b, 0.2)

			self.Experience.Rested = CreateFrame("StatusBar", nil, self.Experience)
			-- self.Experience.Rested:SetParent(self.Experience)
			self.Experience.Rested:SetOrientation("Vertical")
			self.Experience.Rested:SetAllPoints()
			self.Experience.Rested:SetStatusBarTexture(C.media.texture)

			self.Experience.inAlpha = 1
			self.Experience.outAlpha = 0
		end

		-- Reputation bar
		if C.unitframe.plugins_reputation_bar == true then
			self.Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
			self.Reputation:CreateBackdrop("Default")
			self.Reputation:EnableMouse(true)
			if C.unitframe.portrait_enable == true then
				if self.Experience and self.Experience:IsShown() then
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -39 - C.unitframe.portrait_width, 28)
				else
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -25 - C.unitframe.portrait_width, 28)
				end
			else
				if self.Experience and self.Experience:IsShown() then
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -32, 28)
				else
					self.Reputation:SetPoint("TOPLEFT", self, "TOPLEFT", -18, 28)
				end
			end
			self.Reputation:SetSize(7, 94)
			self.Reputation:SetOrientation("Vertical")
			self.Reputation:SetStatusBarTexture(C.media.texture)

			self.Reputation.bg = self.Reputation:CreateTexture(nil, "BORDER")
			self.Reputation.bg:SetAllPoints()
			self.Reputation.bg:SetTexture(C.media.texture)

			self.Reputation.inAlpha = 1
			self.Reputation.outAlpha = 0
			self.Reputation.colorStanding = true
		end

		-- GCD spark
		if C.unitframe.plugins_gcd == true then
			self.GCD = CreateFrame("Frame", self:GetName().."_GCD", self)
			self.GCD:SetWidth(220)
			self.GCD:SetHeight(3)
			self.GCD:SetFrameStrata("HIGH")
			self.GCD:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 0)

			self.GCD.Color = {1, 1, 1}
			self.GCD.Height = T.Scale(3)
			self.GCD.Width = T.Scale(4)
		end
	end

	if unit == "pet" or unit == "targettarget" or unit == "focus" or unit == "focustarget" then
		self.Debuffs = CreateFrame("Frame", self:GetName().."Debuffs", self)
		self.Debuffs:SetHeight(25)
		self.Debuffs:SetWidth(109)
		self.Debuffs.size = T.Scale(25)
		self.Debuffs.spacing = T.Scale(3)
		self.Debuffs.num = 4
		self.Debuffs["growth-y"] = "DOWN"
		if unit == "pet" or unit == "focus" then
			self.Debuffs:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 2, -17)
			self.Debuffs.initialAnchor = "TOPRIGHT"
			self.Debuffs["growth-x"] = "LEFT"
		else
			self.Debuffs:SetPoint("TOPLEFT", self, "BOTTOMLEFT", -2, -17)
			self.Debuffs.initialAnchor = "TOPLEFT"
			self.Debuffs["growth-x"] = "RIGHT"
		end
		self.Debuffs.PostCreateIcon = T.PostCreateAura
		self.Debuffs.PostUpdateIcon = T.PostUpdateIcon

		if unit == "pet" then
			self:RegisterEvent("UNIT_PET", T.UpdateAllElements)
		end
	end

	if unit == "player" or unit == "target" then
		if C.unitframe.portrait_enable == true then
			self.Portrait = CreateFrame("PlayerModel", self:GetName().."_Portrait", self)
			self.Portrait:SetHeight(C.unitframe.portrait_height)
			self.Portrait:SetWidth(C.unitframe.portrait_width)
			if unit == "player" then
				self.Portrait:SetPoint(unpack(C.position.unitframes.player_portrait))
			elseif unit == "target" then
				self.Portrait:SetPoint(unpack(C.position.unitframes.target_portrait))
			end

			self.Portrait:CreateBackdrop("Transparent")
			self.Portrait.backdrop:SetPoint("TOPLEFT", -2 + T.mult, 2 + T.mult)
			self.Portrait.backdrop:SetPoint("BOTTOMRIGHT", 2 + T.mult, -2 - T.mult)

			if C.unitframe.portrait_classcolor_border == true then
				if unit == "player" then
					self.Portrait.backdrop:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
				elseif unit == "target" then
					self.Portrait.backdrop:RegisterEvent("PLAYER_TARGET_CHANGED")
					self.Portrait.backdrop:SetScript("OnEvent", function()
						local _, class = UnitClass("target")
						local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
						if color then
							self.Portrait.backdrop:SetBackdropBorderColor(color.r, color.g, color.b)
						else
							self.Portrait.backdrop:SetBackdropBorderColor(unpack(C.media.border_color))
						end
					end)
				end
			end
		end

		if unit == "player" then
			--[[
			self.Buffs = CreateFrame("Frame", nil, self)
			self.Buffs:SetSize((15 * C.aura.player_buff_size) + 42, (C.aura.player_buff_size * 2) + 3)
			self.Buffs.size = T.Scale(25)
			self.Buffs.num = 36
			self.Buffs.spacing = T.Scale(1)
			self.Buffs["spacing-x"] = 3
			self.Buffs["spacing-y"] = 3
			self.Buffs:SetPoint(unpack(C.position.player_buffs))
			self.Buffs.initialAnchor = "TOPRIGHT"
			self.Buffs["growth-x"] = "LEFT"
			self.Buffs["growth-y"] = "DOWN"
			self.Buffs.filter = true
			
			self.Buffs.PostCreateIcon = T.PostCreateAura
			self.Buffs.PostUpdateIcon = T.PostUpdateIcon
			--]]
			
			self.Debuffs = CreateFrame("Frame", self:GetName().."Debuffs", self)
			self.Debuffs:SetHeight(165)
			self.Debuffs:SetWidth(221)
			self.Debuffs.size = T.Scale(25)
			self.Debuffs.spacing = T.Scale(3)
			self.Debuffs.initialAnchor = "BOTTOMRIGHT"
			self.Debuffs["growth-y"] = "UP"
			self.Debuffs["growth-x"] = "LEFT"
			if ((T.class == "DRUID" or T.class == "ROGUE") and C.unitframe_class_bar.combo == true and C.unitframe_class_bar.combo_old ~= true)
			or (T.class == "SHAMAN" and C.unitframe_class_bar.totem == true) then
				self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 19)
			else
				self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", 2, 5)
			end

			self.Debuffs.PostCreateIcon = T.PostCreateAura
			self.Debuffs.PostUpdateIcon = T.PostUpdateIcon

			--[[
			self.Enchant = CreateFrame("Frame", nil, self)
			self.Enchant:SetHeight(25)
			self.Enchant:SetWidth(53)
			self.Enchant:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -22, -76)
			self.Enchant.size = T.Scale(25)
			self.Enchant.spacing = T.Scale(3)
			self.Enchant.initialAnchor = "TOPRIGHT"
			self.Enchant["growth-x"] = "LEFT"
			
			self.PostCreateEnchantIcon = T.PostCreateAura
			self.PostUpdateEnchantIcons = T.CreateEnchantTimer
			--]]
		end

		if unit == "target" then
			self.Auras = CreateFrame("Frame", self:GetName().."Auras", self)
			self.Auras:SetPoint("BOTTOMLEFT", self, "TOPLEFT", -2, 5)
			self.Auras.initialAnchor = "BOTTOMLEFT"
			self.Auras["growth-x"] = "RIGHT"
			self.Auras["growth-y"] = "UP"
			self.Auras.numDebuffs = 16
			self.Auras.numBuffs = 32
			self.Auras:SetHeight(165)
			self.Auras:SetWidth(221)
			self.Auras.spacing = T.Scale(3)
			self.Auras.size = T.Scale(25)
			self.Auras.gap = true
			self.Auras.PostCreateIcon = T.PostCreateAura
			self.Auras.PostUpdateIcon = T.PostUpdateIcon

			-- Rogue/Druid Combo bar
			if C.unitframe_class_bar.combo == true and (C.unitframe_class_bar.combo_old == true or (T.class ~= "DRUID" and T.class ~= "ROGUE")) then
				self.ComboPoints = CreateFrame("Frame", self:GetName().."_ComboBar", self)
				self.ComboPoints:CreateBackdrop("Default")
				self.ComboPoints:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 0, 7)
				self.ComboPoints:SetSize(217, 7)

				for i = 1, 5 do
					self.ComboPoints[i] = CreateFrame("StatusBar", self:GetName().."_ComboBar", self.ComboPoints)
					self.ComboPoints[i]:SetSize(213 / 5, 7)
					if i == 1 then
						self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints)
					else
						self.ComboPoints[i]:SetPoint("LEFT", self.ComboPoints[i-1], "RIGHT", 1, 0)
					end
					self.ComboPoints[i]:SetStatusBarTexture(C.media.texture)
				end

				self.ComboPoints[1]:SetStatusBarColor(0.9, 0.1, 0.1)
				self.ComboPoints[2]:SetStatusBarColor(0.9, 0.1, 0.1)
				self.ComboPoints[3]:SetStatusBarColor(0.9, 0.9, 0.1)
				self.ComboPoints[4]:SetStatusBarColor(0.9, 0.9, 0.1)
				self.ComboPoints[5]:SetStatusBarColor(0.1, 0.9, 0.1)

				self.ComboPoints.Override = T.UpdateComboPointOld
			end

			--[[
			-- Enemy specialization
			if C.unitframe.plugins_enemy_spec == true then
				self.EnemySpec = T.SetFontString(self.Power, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.EnemySpec:SetTextColor(1, 0, 0)
				self.EnemySpec:SetPoint("BOTTOM", self.Power, "BOTTOM", 0, -1)
			end
			--]]
		end

		if C.unitframe.plugins_combat_feedback == true then
			self.CombatFeedbackText = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
			if C.unitframe.portrait_enable == true then
				self.CombatFeedbackText:SetPoint("BOTTOM", self.Portrait, "BOTTOM", 0, 0)
				self.CombatFeedbackText:SetParent(self.Portrait)
			else
				self.CombatFeedbackText:SetPoint("CENTER", 0, 1)
			end
		end

		if C.unitframe.icons_pvp == true then
			self.Status = T.SetFontString(self.Health, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.Status:SetPoint("CENTER", self.Health, "CENTER", 0, 0)
			self.Status:SetTextColor(0.69, 0.31, 0.31)
			self.Status:Hide()
			self.Status.Override = T.dummy

			self.Status.Update = CreateFrame("Frame", nil, self)
			self.Status.Update:SetScript("OnUpdate", function(self, elapsed) T.UpdatePvPStatus(self:GetParent(), elapsed) end)

			self:SetScript("OnEnter", function(self) FlashInfo.ManaLevel:Hide() self.Status:Show() UnitFrame_OnEnter(self) end)
			self:SetScript("OnLeave", function(self) FlashInfo.ManaLevel:Show() self.Status:Hide() UnitFrame_OnLeave(self) end)
		end
	end

	if C.unitframe.unit_castbar == true then
		self.CastBar = CreateFrame("StatusBar", self:GetName().."_CastBar", self)
		self.CastBar:SetStatusBarTexture(C.media.texture, "ARTWORK")

		self.CastBar.bg = self.CastBar:CreateTexture(nil, "BORDER")
		self.CastBar.bg:SetAllPoints()
		self.CastBar.bg:SetTexture(C.media.texture)

		self.CastBar.Overlay = CreateFrame("Frame", nil, self.CastBar)
		self.CastBar.Overlay:SetTemplate("Default")
		self.CastBar.Overlay:SetFrameStrata("BACKGROUND")
		self.CastBar.Overlay:SetFrameLevel(2)
		self.CastBar.Overlay:SetPoint("TOPLEFT", -2, 2)
		self.CastBar.Overlay:SetPoint("BOTTOMRIGHT", 2, -2)

		self.CastBar.PostCastStart = T.PostCastStart
		self.CastBar.PostChannelStart = T.PostChannelStart

		if unit == "player" then
			if C.unitframe.castbar_icon == true then
				self.CastBar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4] + 11, C.position.unitframes.player_castbar[5])
				self.CastBar:SetWidth(258)
			else
				self.CastBar:SetPoint(unpack(C.position.unitframes.player_castbar))
				self.CastBar:SetWidth(281)
			end
			self.CastBar:SetHeight(16)
		elseif unit == "target" then
			if C.unitframe.castbar_icon == true then
				if C.unitframe.plugins_swing == true then
					self.CastBar:SetPoint(C.position.unitframes.target_castbar[1], C.position.unitframes.target_castbar[2], C.position.unitframes.target_castbar[3], C.position.unitframes.target_castbar[4] - 23, C.position.unitframes.target_castbar[5] + 12)
				else
					self.CastBar:SetPoint(C.position.unitframes.target_castbar[1], C.position.unitframes.target_castbar[2], C.position.unitframes.target_castbar[3], C.position.unitframes.target_castbar[4] - 23, C.position.unitframes.target_castbar[5])
				end
				self.CastBar:SetWidth(258)
			else
				if C.unitframe.plugins_swing == true then
					self.CastBar:SetPoint(C.position.unitframes.target_castbar[1], C.position.unitframes.target_castbar[2], C.position.unitframes.target_castbar[3], C.position.unitframes.target_castbar[4], C.position.unitframes.target_castbar[5] + 12)
				else
					self.CastBar:SetPoint(unpack(C.position.unitframes.target_castbar))
				end
				self.CastBar:SetWidth(281)
			end
			self.CastBar:SetHeight(16)
		else
			self.CastBar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -7)
			self.CastBar:SetWidth(105)
			self.CastBar:SetHeight(5)
		end

		if unit == "focus" then
			self.CastBar.Button = CreateFrame("Frame", nil, self.CastBar)
			self.CastBar.Button:SetHeight(65)
			self.CastBar.Button:SetWidth(65)
			self.CastBar.Button:SetPoint(unpack(C.position.unitframes.focus_castbar))
			self.CastBar.Button:SetTemplate("Default")

			self.CastBar.Icon = self.CastBar.Button:CreateTexture(nil, "ARTWORK")
			self.CastBar.Icon:SetPoint("TOPLEFT", self.CastBar.Button, 2, -2)
			self.CastBar.Icon:SetPoint("BOTTOMRIGHT", self.CastBar.Button, -2, 2)
			self.CastBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

			self.CastBar.Time = T.SetFontString(self.CastBar, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
			self.CastBar.Time:SetParent(self.CastBar.Button)
			self.CastBar.Time:SetPoint("CENTER", self.CastBar.Icon, "CENTER", 0, 10)
			self.CastBar.Time:SetTextColor(1, 1, 1)

			self.CastBar.Time2 = T.SetFontString(self.CastBar, C.font.unit_frames_font, C.font.unit_frames_font_size * 2, C.font.unit_frames_font_style)
			self.CastBar.Time2:SetParent(self.CastBar.Button)
			self.CastBar.Time2:SetPoint("CENTER", self.CastBar.Icon, "CENTER", 0, -10)
			self.CastBar.Time2:SetTextColor(1, 1, 1)

			self.CastBar.CustomTimeText = function(self, duration)
				self.Time:SetText(("%.1f"):format(self.max))
				self.Time2:SetText(("%.1f"):format(self.channeling and duration or self.max - duration))
			end
			self.CastBar.CustomDelayText = function(self)
				self.Time:SetText(("|cffaf5050%s %.1f|r"):format(self.channeling and "-" or "+", abs(self.delay)))
			end
		end

		if unit == "player" or unit == "target" then
			self.CastBar.Time = T.SetFontString(self.CastBar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.CastBar.Time:SetPoint("RIGHT", self.CastBar, "RIGHT", 0, 0)
			self.CastBar.Time:SetTextColor(1, 1, 1)
			self.CastBar.Time:SetJustifyH("RIGHT")
			self.CastBar.CustomTimeText = T.CustomCastTimeText
			self.CastBar.CustomDelayText = T.CustomCastDelayText

			self.CastBar.Text = T.SetFontString(self.CastBar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
			self.CastBar.Text:SetPoint("LEFT", self.CastBar, "LEFT", 2, 0)
			self.CastBar.Text:SetPoint("RIGHT", self.CastBar.Time, "LEFT", -1, 0)
			self.CastBar.Text:SetTextColor(1, 1, 1)
			self.CastBar.Text:SetJustifyH("LEFT")
			self.CastBar.Text:SetHeight(C.font.unit_frames_font_size)

			if C.unitframe.castbar_icon == true then
				self.CastBar.Button = CreateFrame("Frame", nil, self.CastBar)
				self.CastBar.Button:SetHeight(20)
				self.CastBar.Button:SetWidth(20)
				self.CastBar.Button:SetTemplate("Default")

				self.CastBar.Icon = self.CastBar.Button:CreateTexture(nil, "ARTWORK")
				self.CastBar.Icon:SetPoint("TOPLEFT", self.CastBar.Button, 2, -2)
				self.CastBar.Icon:SetPoint("BOTTOMRIGHT", self.CastBar.Button, -2, 2)
				self.CastBar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)

				if unit == "player" then
					self.CastBar.Button:SetPoint("RIGHT", self.CastBar, "LEFT", -5, 0)
				elseif unit == "target" then
					self.CastBar.Button:SetPoint("LEFT", self.CastBar, "RIGHT", 5, 0)
				end
			end

			if unit == "player" and C.unitframe.castbar_latency == true then
				self.CastBar.SafeZone = self.CastBar:CreateTexture(nil, "BORDER", nil, 1)
				self.CastBar.SafeZone:SetTexture(C.media.texture)
				self.CastBar.SafeZone:SetVertexColor(0.85, 0.27, 0.27)

				self.CastBar.Latency = T.SetFontString(self.CastBar, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
				self.CastBar.Latency:SetTextColor(1, 1, 1)
				self.CastBar.Latency:SetPoint("TOPRIGHT", self.CastBar.Time, "BOTTOMRIGHT", 0, 0)
				self.CastBar.Latency:SetJustifyH("RIGHT")

				self:RegisterEvent("UNIT_SPELLCAST_SENT", function(self, event, caster)
					if (caster == "player") then
						self.CastBar.castSent = GetTime()
					end
				end)
			end
		end
	end

	-- Swing bar
	if C.unitframe.plugins_swing == true and unit == "player" then
		self.Swing = CreateFrame("StatusBar", self:GetName().."_Swing", self)
		self.Swing:CreateBackdrop("Default")
		self.Swing:SetPoint("BOTTOMRIGHT", "oUF_Player_CastBar", "TOPRIGHT", 0, 7)
		self.Swing:SetSize(281, 5)
		self.Swing:SetStatusBarTexture(C.media.texture)
		if C.unitframe.own_color == true then
			self.Swing:SetStatusBarColor(unpack(C.unitframe.uf_color))
		else
			self.Swing:SetStatusBarColor(T.color.r, T.color.g, T.color.b)
		end

		self.Swing.bg = self.Swing:CreateTexture(nil, "BORDER")
		self.Swing.bg:SetAllPoints(self.Swing)
		self.Swing.bg:SetTexture(C.media.texture)
		if C.unitframe.own_color == true then
			self.Swing.bg:SetVertexColor(C.unitframe.uf_color[1], C.unitframe.uf_color[2], C.unitframe.uf_color[3], 0.2)
		else
			self.Swing.bg:SetVertexColor(T.color.r, T.color.g, T.color.b, 0.2)
		end

		self.Swing.Text = T.SetFontString(self.Swing, C.font.unit_frames_font, C.font.unit_frames_font_size, C.font.unit_frames_font_style)
		self.Swing.Text:SetPoint("CENTER", 0, 0)
		self.Swing.Text:SetTextColor(1, 1, 1)
	end

	-- Agro border
	if C.raidframe.aggro_border == true then
		table.insert(self.__elements, T.UpdateThreat)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", T.UpdateThreat)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", T.UpdateThreat)
		self:RegisterEvent("PLAYER_REGEN_DISABLED", T.UpdateThreat)
		-- self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", T.UpdateThreat)
		-- self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", T.UpdateThreat)
		-- self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", T.UpdateThreat)
	end

	-- Raid marks
	if C.raidframe.icons_raid_mark == true then
		self.RaidTargetIndicator = self:CreateTexture(nil, "OVERLAY")
		self.RaidTargetIndicator:SetParent(self.Health)
		self.RaidTargetIndicator:SetSize((unit == "player" or unit == "target") and 15 or 12, (unit == "player" or unit == "target") and 15 or 12)
		self.RaidTargetIndicator:SetPoint("TOP", self.Health, 0, 0)
	end

	-- Debuff highlight
	self.DebuffHighlight = self.Health:CreateTexture(nil, "OVERLAY")
	self.DebuffHighlight:SetAllPoints(self.Health)
	self.DebuffHighlight:SetTexture(C.media.highlight)
	self.DebuffHighlight:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlight:SetBlendMode("ADD")
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightFilter = true

	--[[
	-- Incoming heal text/bar
	if C.raidframe.plugins_healcomm == true then
		local mhpb = self.Health:CreateTexture(nil, "ARTWORK")
		mhpb:SetTexture(C.media.texture)
		mhpb:SetVertexColor(0, 1, 0.5, 0.2)

		local ohpb = self.Health:CreateTexture(nil, "ARTWORK")
		ohpb:SetTexture(C.media.texture)
		ohpb:SetVertexColor(0, 1, 0, 0.2)

		local ahpb = self.Health:CreateTexture(nil, "ARTWORK")
		ahpb:SetTexture(C.media.texture)
		ahpb:SetVertexColor(1, 1, 0, 0.2)

		self.HealPrediction = {
			myBar = mhpb,
			otherBar = ohpb,
			absorbBar = ahpb,
			maxOverflow = 1,
			frequentUpdates = true
		}
	end
	--]]

	-- Fader
	if C.unitframe.plugins_fader == true then
		self.Fader = {
			[1] = {Combat = 1, Arena = 1, Instance = 1},
			[2] = {PlayerTarget = 1, PlayerNotMaxHealth = 1, PlayerNotMaxMana = 1},
			[3] = {Stealth = 0.5},
			[4] = {notCombat = 0, PlayerTaxi = 0},
		}
		self.NormalAlpha = 1
	end

	-- T.HideAuraFrame(self)

	return self
end

----------------------------------------------------------------------------------------
--	Default position of ShestakUI unitframes
----------------------------------------------------------------------------------------
oUF:RegisterStyle("Shestak", Shared)

local player = oUF:Spawn("player", "oUF_Player")
player:SetPoint(unpack(C.position.unitframes.player))
player:SetSize(217, 27)

local target = oUF:Spawn("target", "oUF_Target")
target:SetPoint(unpack(C.position.unitframes.target))
target:SetSize(217, 27)

if C.unitframe.show_pet == true then
	local pet = oUF:Spawn("pet", "oUF_Pet")
	pet:SetPoint(unpack(C.position.unitframes.pet))
	pet:SetSize(105, 16)
end

if C.unitframe.show_focus == true then
	local focus = oUF:Spawn("focus", "oUF_Focus")
	focus:SetPoint(unpack(C.position.unitframes.focus))
	focus:SetSize(105, 16)

	local focustarget = oUF:Spawn("focustarget", "oUF_FocusTarget")
	focustarget:SetPoint(unpack(C.position.unitframes.focus_target))
	focustarget:SetSize(105, 16)
else
	local focus = oUF:Spawn("focus", "oUF_Focus")
end

if C.unitframe.show_target_target == true then
	local targettarget = oUF:Spawn("targettarget", "oUF_TargetTarget")
	targettarget:SetPoint(unpack(C.position.unitframes.target_target))
	targettarget:SetSize(105, 16)
end

----------------------------------------------------------------------------------------
--	Test UnitFrames(by community)
----------------------------------------------------------------------------------------
local moving = false
SlashCmdList.TEST_UF = function(msg)
	if InCombatLockdown() then print("|cffffff00"..ERR_NOT_IN_COMBAT.."|r") return end
	if not moving then
		for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget"}) do
			_G[frames].oldunit = _G[frames].unit
			_G[frames]:SetAttribute("unit", "player")
		end

		moving = true
	else
		for _, frames in pairs({"oUF_Target", "oUF_TargetTarget", "oUF_Pet", "oUF_Focus", "oUF_FocusTarget"}) do
			_G[frames]:SetAttribute("unit", _G[frames].oldunit)
		end

		moving = false
	end
end
SLASH_TEST_UF1 = "/testui"
SLASH_TEST_UF2 = "/еуыегш"
SLASH_TEST_UF3 = "/testuf"
SLASH_TEST_UF4 = "/еуыега"

----------------------------------------------------------------------------------------
--	Player line
----------------------------------------------------------------------------------------
if C.unitframe.lines == true then
	local HorizontalPlayerLine = CreateFrame("Frame", "HorizontalPlayerLine", oUF_Player)
	HorizontalPlayerLine:CreatePanel("ClassColor", 228, 1, "TOPLEFT", "oUF_Player", "BOTTOMLEFT", -5, -5)

	local VerticalPlayerLine = CreateFrame("Frame", "VerticalPlayerLine", oUF_Player)
	VerticalPlayerLine:CreatePanel("ClassColor", 1, 98, "RIGHT", HorizontalPlayerLine, "LEFT", 0, 13)
end

----------------------------------------------------------------------------------------
--	Target line
----------------------------------------------------------------------------------------
if C.unitframe.lines == true then
	local HorizontalTargetLine = CreateFrame("Frame", "HorizontalTargetLine", oUF_Target)
	HorizontalTargetLine:CreatePanel("ClassColor", 228, 1, "TOPRIGHT", "oUF_Target", "BOTTOMRIGHT", 5, -5)
	HorizontalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
	HorizontalTargetLine:SetScript("OnEvent", function(self)
		local _, class = UnitClass("target")
		local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		if color then
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end)

	local VerticalTargetLine = CreateFrame("Frame", "VerticalTargetLine", oUF_Target)
	VerticalTargetLine:CreatePanel("ClassColor", 1, 98, "LEFT", HorizontalTargetLine, "RIGHT", 0, 13)
	VerticalTargetLine:RegisterEvent("PLAYER_TARGET_CHANGED")
	VerticalTargetLine:SetScript("OnEvent", function(self)
		local _, class = UnitClass("target")
		local color = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[class]
		if color then
			self:SetBackdropBorderColor(color.r, color.g, color.b)
		else
			self:SetBackdropBorderColor(unpack(C.media.border_color))
		end
	end)
end

----------------------------------------------------------------------------------------
--	Auto reposition heal raid frame
----------------------------------------------------------------------------------------
local function Reposition()
	if SavedOptions and SavedOptions.RaidLayout == "HEAL" and not C.raidframe.raid_groups_vertical then
		if C.raidframe.raid_groups < 6 then return end

		if C.unitframe.castbar_icon == true then
			oUF_Player_CastBar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4] + 11, C.position.unitframes.player_castbar[5] + (C.raidframe.raid_groups - 5) * 33)
		else
			oUF_Player_CastBar:SetPoint(C.position.unitframes.player_castbar[1], C.position.unitframes.player_castbar[2], C.position.unitframes.player_castbar[3], C.position.unitframes.player_castbar[4], C.position.unitframes.player_castbar[5] + (C.raidframe.raid_groups - 5) * 33)
		end

		player:SetPoint(C.position.unitframes.player[1], C.position.unitframes.player[2], C.position.unitframes.player[3], C.position.unitframes.player[4], C.position.unitframes.player[5] + (C.raidframe.raid_groups - 5) * 33)
		target:SetPoint(C.position.unitframes.target[1], C.position.unitframes.target[2], C.position.unitframes.target[3], C.position.unitframes.target[4], C.position.unitframes.target[5] + (C.raidframe.raid_groups - 5) * 33)
	end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", Reposition)

----------------------------------------------------------------------------------------
--	Delete some lines from unit dropdown menu
----------------------------------------------------------------------------------------
do
	local PET_DISMISS = "PET_DISMISS"
	if T.class == "HUNTER" then
		PET_DISMISS = nil
	end

	for k, _ in pairs(UnitPopupMenus) do
		for x, y in pairs(UnitPopupMenus[k]) do
			if y == "SET_FOCUS" then
				table.remove(UnitPopupMenus[k], x)
			elseif y == "CLEAR_FOCUS" then
				table.remove(UnitPopupMenus[k], x)
			end
		end
	end
end