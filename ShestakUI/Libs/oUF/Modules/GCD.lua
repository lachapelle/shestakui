local T, C, L = unpack(select(2, ShestakAddonInfo()))
if C.unitframe.enable ~= true or C.unitframe.plugins_gcd ~= true then return end

----------------------------------------------------------------------------------------
--	Based on oUF_GCD(by ALZA)
----------------------------------------------------------------------------------------
local ns = oUF
local oUF = ns.oUF

local starttime, duration, usingspell, spellid
local GetTime = GetTime

local spells = {
	["DRUID"] = 8921,
	["HUNTER"] = 982,
	["MAGE"] = 118,
	["PALADIN"] = 19750,
	["PRIEST"] = 585,
	["ROGUE"] = 1752,
	["SHAMAN"] = 403,
	["WARLOCK"] = 686,
	["WARRIOR"] = 6673,
}

local Enable = function(self)
	if not self.GCD then return end
	local bar = self.GCD
	local width = bar:GetWidth()
	bar:Hide()

	bar.spark = bar:CreateTexture(nil, "DIALOG")
	bar.spark:SetTexture(C.media.blank)
	bar.spark:SetVertexColor(unpack(bar.Color))
	bar.spark:SetHeight(bar.Height)
	bar.spark:SetWidth(bar.Width)
	bar.spark:SetBlendMode("ADD")

	local function OnUpdateSpark()
		bar.spark:ClearAllPoints()
		local elapsed = GetTime() - starttime
		local perc = elapsed / duration
		if perc > 1 then
			return bar:Hide()
		else
			bar.spark:SetPoint("CENTER", bar, "LEFT", width * perc, 0)
		end
	end

	local function Init()
		local isKnown = IsSpellKnown(spells[T.class])
		if isKnown then
			spellid = spells[T.class]
		end
		if spellid == nil then
			return
		end
		return spellid
	end

	local function OnHide()
		bar:SetScript("OnUpdate", nil)
		usingspell = nil
	end

	local function OnShow()
		bar:SetScript("OnUpdate", OnUpdateSpark)
	end

	local function UpdateGCD()
		if spellid == nil then
			if Init() == nil then
				return
			end
		end
		local start, dur = GetSpellCooldown(spellid)
		if dur and dur > 0 and dur <= 2 then
			usingspell = 1
			starttime = start
			duration = dur
			bar:Show()
			return
		elseif usingspell == 1 and dur == 0 then
			bar:Hide()
		end
	end

	bar:SetScript("OnShow", OnShow)
	bar:SetScript("OnHide", OnHide)

	self:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN", UpdateGCD)
end

oUF:AddElement("GCD", UpdateGCD, Enable)