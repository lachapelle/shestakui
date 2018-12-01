local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	ActionBar(by Tukz)
----------------------------------------------------------------------------------------
local bar = CreateFrame("Frame", "Bar1Holder", ActionBarAnchor, "SecureStateHeaderTemplate")
bar:SetAllPoints(ActionBarAnchor)

for i = 1, 12 do
	local button = _G["ActionButton"..i]
	button:SetSize(C.actionbar.button_size, C.actionbar.button_size)
	button:ClearAllPoints()
	button:SetParent(Bar1Holder)
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", Bar1Holder, 0, 0)
	else
		local previous = _G["ActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", C.actionbar.button_space, 0)
	end
end

-- Bonus Bar
BonusActionBarFrame:SetParent(Bar1Holder)
BonusActionBarFrame:SetWidth(0.00001)

for i = 1, 12 do
	local button = _G["BonusActionButton"..i]
	button:SetSize(C.actionbar.button_size, C.actionbar.button_size)
	button:ClearAllPoints()
	if i == 1 then
		button:SetPoint("BOTTOMLEFT", Bar1Holder, 0, 0)
	else
		local previous = _G["BonusActionButton"..i-1]
		button:SetPoint("LEFT", previous, "RIGHT", C.actionbar.button_space, 0)
	end
end

local function BonusBarUpdate(alpha)
	for i = 1, 12 do
		local button = _G["ActionButton"..i]
		button:SetAlpha(alpha)
	end
end
BonusActionBarFrame:HookScript("OnShow", function(self) BonusBarUpdate(0) end)
BonusActionBarFrame:HookScript("OnHide", function(self) BonusBarUpdate(1) end)
if BonusActionBarFrame:IsShown() then
	BonusBarUpdate(0)
end

bar:RegisterEvent("PLAYER_LOGIN")
bar:RegisterEvent("UPDATE_BONUS_ACTIONBAR")
bar:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
bar:RegisterEvent("UPDATE_BINDINGS")
bar:SetScript("OnEvent", function(self, event, ...)
	if GetBonusBarOffset() ~= 0 then
		BonusBarUpdate(0)
	else
		BonusBarUpdate(1)
	end
end)