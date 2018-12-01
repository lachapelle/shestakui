local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Merchant skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	local MerchantFrame = _G["MerchantFrame"]
	MerchantFrame:StripTextures(true)
	MerchantFrame:CreateBackdrop("Transparent")
	MerchantFrame.backdrop:SetPoint("TOPLEFT", 10, -11)
	MerchantFrame.backdrop:SetPoint("BOTTOMRIGHT", -28, 60)

	MerchantFrame:EnableMouseWheel(true)
	MerchantFrame:SetScript("OnMouseWheel", function(_, value)
		if value > 0 then
			if MerchantPrevPageButton:IsShown() and MerchantPrevPageButton:IsEnabled() == 1 then
				MerchantPrevPageButton_OnClick()
			end
		else
			if MerchantNextPageButton:IsShown() and MerchantNextPageButton:IsEnabled() == 1 then
				MerchantNextPageButton_OnClick()
			end	
		end
	end)

	T.SkinCloseButton(MerchantFrameCloseButton, MerchantFrame.backdrop)

	for i = 1, 12 do
		local item = _G["MerchantItem"..i]
		local button = _G["MerchantItem"..i.."ItemButton"]
		local icon = _G["MerchantItem"..i.."ItemButtonIconTexture"]
		local money = _G["MerchantItem"..i.."MoneyFrame"]
		local nameFrame = _G["MerchantItem"..i.."NameFrame"]
		local name = _G["MerchantItem"..i.."Name"]
		local slot = _G["MerchantItem"..i.."SlotTexture"]

		item:StripTextures(true)
		item:CreateBackdrop("Default")
		item.backdrop:SetPoint("BOTTOMRIGHT", 0, -4)

		button:StripTextures()
		button:StyleButton()
		button:SetTemplate("Default", true)
		button:SetSize(40, 40)
		button:SetPoint("TOPLEFT", item, "TOPLEFT", 4, -4)

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetInside()

		nameFrame:SetPoint("LEFT", slot, "RIGHT", -6, -17)

		name:SetPoint("LEFT", slot, "RIGHT", -4, 5)

		money:ClearAllPoints()
		money:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", 3, 0)
		money:SetScale(0.9)

		for j = 1, 2 do
			local currencyItem = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j]
			local currencyIcon = _G["MerchantItem"..i.."AltCurrencyFrameItem"..j.."Texture"]

			currencyIcon.backdrop = CreateFrame("Frame", nil, currencyItem)
			currencyIcon.backdrop:SetTemplate("Default")
			currencyIcon.backdrop:SetFrameLevel(currencyItem:GetFrameLevel())
			currencyIcon.backdrop:SetOutside(currencyIcon)

			currencyIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			currencyIcon:SetParent(currencyIcon.backdrop)
		end
	end

	T.SkinNextPrevButton(MerchantNextPageButton)
	T.SkinNextPrevButton(MerchantPrevPageButton)

	MerchantRepairItemButton:StyleButton(false)
	MerchantRepairItemButton:SetTemplate("Default", true)

	for i = 1, MerchantRepairItemButton:GetNumRegions() do
		local region = select(i, MerchantRepairItemButton:GetRegions())
		if region:GetObjectType() == "Texture" and region:GetTexture() == "Interface\\MerchantFrame\\UI-Merchant-RepairIcons" then
			region:SetTexCoord(0.04, 0.24, 0.07, 0.5)
			region:SetInside()
		end
	end

	MerchantRepairAllButton:StyleButton()
	MerchantRepairAllButton:SetTemplate("Default", true)

	MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)
	MerchantRepairAllIcon:SetInside()

	MerchantGuildBankRepairButton:StyleButton()
	MerchantGuildBankRepairButton:SetTemplate("Default", true)

	MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)
	MerchantGuildBankRepairButtonIcon:SetInside()

	MerchantBuyBackItem:StripTextures(true)
	MerchantBuyBackItem:CreateBackdrop("Transparent")
	MerchantBuyBackItem.backdrop:SetPoint("TOPLEFT", -6, 6)
	MerchantBuyBackItem.backdrop:SetPoint("BOTTOMRIGHT", 6, -6)
	MerchantBuyBackItem:SetPoint("TOPLEFT", MerchantItem10, "BOTTOMLEFT", 0, -48)

	MerchantBuyBackItemItemButton:StripTextures()
	MerchantBuyBackItemItemButton:SetTemplate("Default", true)
	MerchantBuyBackItemItemButton:StyleButton()

	MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	MerchantBuyBackItemItemButtonIconTexture:SetInside()

	for i = 1, 2 do
		T.SkinTab(_G["MerchantFrameTab"..i])
	end

	hooksecurefunc("MerchantFrame_UpdateMerchantInfo", function()
		local numMerchantItems = GetMerchantNumItems()
		local index
		local itemButton, itemName, itemLink
		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			index = (((MerchantFrame.page - 1) * MERCHANT_ITEMS_PER_PAGE) + i)
			itemButton = _G["MerchantItem"..i.."ItemButton"]
			itemName = _G["MerchantItem"..i.."Name"]

			if index <= numMerchantItems then
				itemLink = GetMerchantItemLink(index)
				if itemLink then
					local _, _, quality = GetItemInfo(itemLink)
					local r, g, b = GetItemQualityColor(quality)

					itemName:SetTextColor(r, g, b)
					if quality then
						itemButton:SetBackdropBorderColor(r, g, b)
					else
						itemButton:SetBackdropBorderColor(unpack(C.media.backdrop_color))
					end
				end
			end

			local buybackName = GetBuybackItemInfo(GetNumBuybackItems())
			if buybackName then
				local _, _, quality = GetItemInfo(buybackName)
				local r, g, b = GetItemQualityColor(quality)

				MerchantBuyBackItemName:SetTextColor(r, g, b)
				if quality then
					MerchantBuyBackItemItemButton:SetBackdropBorderColor(r, g, b)
				else
					MerchantBuyBackItemItemButton:SetBackdropBorderColor(unpack(C.media.backdrop_color))
				end
			else
				MerchantBuyBackItemItemButton:SetBackdropBorderColor(unpack(C.media.backdrop_color))
			end
		end
	end)

	hooksecurefunc("MerchantFrame_UpdateBuybackInfo", function()
		local numBuybackItems = GetNumBuybackItems()
		local itemButton, itemName
		for i = 1, BUYBACK_ITEMS_PER_PAGE do
			itemButton = _G["MerchantItem"..i.."ItemButton"]
			itemName = _G["MerchantItem"..i.."Name"]

			if i <= numBuybackItems then
				local buybackName = GetBuybackItemInfo(i)
				if buybackName then
					local _, _, quality = GetItemInfo(buybackName)
					local r, g, b = GetItemQualityColor(quality)

					itemName:SetTextColor(r, g, b)
					if quality then
						itemButton:SetBackdropBorderColor(r, g, b)
					else
						itemButton:SetBackdropBorderColor(unpack(C.media.backdrop_color))
					end
				end
			end
		end
	end)
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)