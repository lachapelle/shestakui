local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
-- if C.tooltip.enable ~= true or C.tooltip.item_price ~= true then return end
if C.tooltip.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Item Price
----------------------------------------------------------------------------------------

local GetActionCount = GetActionCount
local GetAuctionItemInfo = GetAuctionItemInfo
local GetAuctionSellItemInfo = GetAuctionSellItemInfo
local GetContainerItemInfo = GetContainerItemInfo
local GetCraftReagentInfo = GetCraftReagentInfo
local GetGuildBankItemInfo = GetGuildBankItemInfo
local GetInboxItem = GetInboxItem
local GetItemCount = GetItemCount
local GetLootRollItemInfo = GetLootRollItemInfo
local GetLootSlotInfo = GetLootSlotInfo
local GetMerchantItemCostItem = GetMerchantItemCostItem
local GetMerchantItemInfo = GetMerchantItemInfo
local GetQuestItemInfo = GetQuestItemInfo
local GetQuestLogRewardInfo = GetQuestLogRewardInfo
local GetSendMailItem = GetSendMailItem
local GetTradePlayerItemInfo = GetTradePlayerItemInfo
local GetTradeSkillReagentInfo = GetTradeSkillReagentInfo
local GetTradeTargetItemInfo = GetTradeTargetItemInfo
local IsConsumableAction = IsConsumableAction
local IsStackableAction = IsStackableAction

local tooltips = {
	"GameTooltip",
	"ItemRefTooltip"
}

local function SetAction(tt, id)
	local _, item = tt:GetItem()
	if not item then return end

	local count = 1
	if IsConsumableAction(id) or IsStackableAction(id) then
		local actionCount = GetActionCount(id)
		if actionCount and actionCount == GetItemCount(item) then
			count = actionCount
		end
	end

	SetPrice(tt, count, item)
end

local function SetAuctionItem(tt, type, index)
	local _, _, count = GetAuctionItemInfo(type, index)
	SetPrice(tt, count)
end

local function SetAuctionSellItem(tt)
	local _, _, count = GetAuctionSellItemInfo()
 	SetPrice(tt, count)
end

local function SetBagItem(tt, bag, slot)
	local _, count = GetContainerItemInfo(bag, slot)
	SetPrice(tt, count)
end

local function SetCraftItem(tt, skill, slot)
	local count = 1
	if slot then
		count = select(3, GetCraftReagentInfo(skill, slot))
	end

	SetPrice(tt, count)
end

local function SetHyperlink(tt, link, count)
	count = tonumber(count)
	if not count or count < 1 then
		local owner = tt:GetOwner()
		count = owner and tonumber(owner.count)
		if not count or count < 1 then
			count = 1
		end
	end

	SetPrice(tt, count)
end

local function SetInboxItem(tt, index, attachmentIndex)
	local _, _, count = GetInboxItem(index, attachmentIndex)
	SetPrice(tt, count)
end

local function SetInventoryItem(tt, unit, slot)
	if type(slot) ~= "number" or slot < 0 then return end

	local count = 1
	if slot < 20 or slot > 39 and slot < 68 then
		count = GetInventoryItemCount(unit, slot)
	end

	SetPrice(tt, count)
end

local function SetLootItem(tt, slot)
	local _, _, count = GetLootSlotInfo(slot)
	SetPrice(tt, count)
end

local function SetLootRollItem(tt, rollID)
	local _, _, count = GetLootRollItemInfo(rollID)
	SetPrice(tt, count)
end

local function SetMerchantCostItem(tt, index, item)
	local _, count = GetMerchantItemCostItem(index, item)
	SetPrice(tt, count)
end

local function SetMerchantItem(tt, slot)
	local _, _, _, count = GetMerchantItemInfo(slot)
	SetPrice(tt, count)
end

local function SetQuestItem(tt, type, slot)
	local _, _, count = GetQuestItemInfo(type, slot)
	SetPrice(tt, count)
end

local function SetQuestLogItem(tt, type, index)
	local _, _, count = GetQuestLogRewardInfo(index)
	SetPrice(tt, count)
end

local function SetSendMailItem(tt, index)
	local _, _, count = GetSendMailItem(index)
	SetPrice(tt, count)
end

local function SetSocketedItem(tt)
	SetPrice(tt, 1)
end

local function SetExistingSocketGem(tt)
	SetPrice(tt, 1)
end

local function SetSocketGem(tt)
	SetPrice(tt, 1)
end

local function SetTradePlayerItem(tt, index)
	local _, _, count = GetTradePlayerItemInfo(index)
	SetPrice(tt, count)
end

local function SetTradeSkillItem(tt, skill, slot)
	local count = 1
	if slot then
		count = select(3, GetTradeSkillReagentInfo(skill, slot))
	end

	SetPrice(tt, count)
end

local function SetTradeTargetItem(tt, index)
	local _, _, count = GetTradeTargetItemInfo(index)
	SetPrice(tt, count)
end

local function SetGuildBankItem(tt, tab, slot)
	local _, count = GetGuildBankItemInfo(tab, slot)
	SetPrice(tt, count)
end

function SetPrice(tt, count, item)
	if MerchantFrame:IsShown() then return end

	item = item or select(2, tt:GetItem())
	if not item then return end

	local LIP = LibStub:GetLibrary("ItemPrice-1.1")
	local price = LIP:GetSellValue(item)

	if price and price > 0 then
		tt:AddDoubleLine(L_COMPATIBILITY_SELL_PRICE..": ", T.FormatMoney(count and price * count or price), nil, nil, nil, 1, 1, 1)
	end

	if tt:IsShown() then tt:Show() end
end

local function ApplyHooks(tooltip)
	hooksecurefunc(tooltip, "SetAction", SetAction)
	hooksecurefunc(tooltip, "SetAuctionItem", SetAuctionItem)
	hooksecurefunc(tooltip, "SetAuctionSellItem", SetAuctionSellItem)
	hooksecurefunc(tooltip, "SetBagItem", SetBagItem)
	hooksecurefunc(tooltip, "SetCraftItem", SetCraftItem)
	hooksecurefunc(tooltip, "SetHyperlink", SetHyperlink)
	hooksecurefunc(tooltip, "SetInboxItem", SetInboxItem)
	hooksecurefunc(tooltip, "SetInventoryItem", SetInventoryItem)
	hooksecurefunc(tooltip, "SetLootItem", SetLootItem)
	hooksecurefunc(tooltip, "SetLootRollItem", SetLootRollItem)
	hooksecurefunc(tooltip, "SetMerchantCostItem", SetMerchantCostItem)
	hooksecurefunc(tooltip, "SetMerchantItem", SetMerchantItem)
	hooksecurefunc(tooltip, "SetQuestItem", SetQuestItem)
	hooksecurefunc(tooltip, "SetQuestLogItem", SetQuestLogItem)
	hooksecurefunc(tooltip, "SetSendMailItem", SetSendMailItem)
	hooksecurefunc(tooltip, "SetSocketedItem", SetSocketedItem)
	hooksecurefunc(tooltip, "SetExistingSocketGem", SetExistingSocketGem)
	hooksecurefunc(tooltip, "SetSocketGem", SetSocketGem)
	hooksecurefunc(tooltip, "SetTradePlayerItem", SetTradePlayerItem)
	hooksecurefunc(tooltip, "SetTradeSkillItem", SetTradeSkillItem)
	hooksecurefunc(tooltip, "SetTradeTargetItem", SetTradeTargetItem)
	hooksecurefunc(tooltip, "SetGuildBankItem", SetGuildBankItem)
end

for _, tooltip in pairs(tooltips) do
	ApplyHooks(_G[tooltip])
end