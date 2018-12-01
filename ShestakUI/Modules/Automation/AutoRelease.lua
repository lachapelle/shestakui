local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.automation.release ~= true then return end

----------------------------------------------------------------------------------------
--	Auto release the spirit in battlegrounds
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_DEAD")
frame:SetScript("OnEvent", function(self, event)
	local inBattlefield = false
	for i = 1, MAX_BATTLEFIELD_QUEUES do
		local status = GetBattlefieldStatus(i)
		if status == "active" then inBattlefield = true end
	end
	if not (HasSoulstone() and CanUseSoulstone()) then
		SetMapToCurrentZone()
		local areaID = GetCurrentMapAreaID() or 0
		if areaID == 501 or inBattlefield == true then
			RepopMe()
		end
	end
end)