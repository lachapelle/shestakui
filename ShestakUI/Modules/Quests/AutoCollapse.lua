local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.automation.auto_collapse ~= true then return end

----------------------------------------------------------------------------------------
--	Auto collapse ObjectiveTrackerFrame in instance
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)
	if IsInInstance() then
		WatchFrame_Collapse(WatchFrame)
	elseif WatchFrame.userCollapsed and not InCombatLockdown() then
		WatchFrame_Expand(WatchFrame)
	end
end)