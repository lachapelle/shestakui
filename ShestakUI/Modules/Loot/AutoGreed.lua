local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.loot.auto_greed ~= true or T.level ~= MAX_PLAYER_LEVEL then return end

----------------------------------------------------------------------------------------
--	Auto greed on green items (by Tekkub) and NeedTheOrb (by Myrilandell of Lothar)
----------------------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("START_LOOT_ROLL")
frame:SetScript("OnEvent", function(self, event, id)
	local _, name, _, quality, BoP = GetLootRollItemInfo(id)
	-- Greed Primal Nethers
	--[[
	if (name == select(1, GetItemInfo(23572))) then
		RollOnLoot(id, 2)
	end
	--]]
	-- Need on items from the filter list, otherwise greed TBC greens.
	if id and quality == 2 and not BoP then
		for i in pairs(T.NeedLoot) do
			local itemName = GetItemInfo(T.NeedLoot[i])
			if name == itemName then
				RollOnLoot(id, 1)
				return
			end
		end
		local link = GetLootRollItemLink(id)
		local _, _, _, ilevel = GetItemInfo(link)
		if ilevel > 80 then
			RollOnLoot(id, 2)
		end
	end
end)