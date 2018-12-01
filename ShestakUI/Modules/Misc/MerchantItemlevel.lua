local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.misc.merchant_itemlevel ~= true then return end

----------------------------------------------------------------------------------------
--	Show item level for weapons and armor in merchant
----------------------------------------------------------------------------------------
local function MerchantItemlevel()
	local numItems = GetMerchantNumItems()

	for i = 1, MERCHANT_ITEMS_PER_PAGE do
		local index = (MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE + i
		if index > numItems then return end

		local button = _G["MerchantItem"..i.."ItemButton"]
		if button and button:IsShown() then
			if not button.text then
				button.text = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
				button.text:SetPoint("TOPLEFT", 1, -1)
				button.text:SetTextColor(1, 1, 0)
			else
				button.text:SetText("")
			end

			local itemLink = GetMerchantItemLink(index)
			local weapon, armor = GetAuctionItemClasses()
			if itemLink then
				local _, _, quality, itemLevel, _, itemType = GetItemInfo(itemLink)
				if (itemLevel and itemLevel > 1) and (quality and quality > 1) and (itemType == weapon or itemType == armor) then
					button.text:SetText(itemLevel)
				end
			end
		end
	end
end
hooksecurefunc("MerchantFrame_UpdateMerchantInfo", MerchantItemlevel)