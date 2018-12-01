local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.misc.move_blizzard ~= true then return end

----------------------------------------------------------------------------------------
--	Move some Blizzard frames
----------------------------------------------------------------------------------------
local frames = {
	"CharacterFrame", "SpellBookFrame", "TaxiFrame", "QuestFrame", "PVEFrame", "AddonList",
	"QuestLogPopupDetailFrame", "MerchantFrame", "TradeFrame", "MailFrame", "LootFrame",
	"FriendsFrame", "CinematicFrame", "TabardFrame", "PetStableFrame", "MissingLootFrame",
	"PetitionFrame", "HelpFrame", "GossipFrame", "DressUpFrame", "GuildRegistrarFrame",
	"WorldStateScoreFrame", "ChatConfigFrame", "RaidBrowserFrame", "InterfaceOptionsFrame",
	"GameMenuFrame", "VideoOptionsFrame", "GuildInviteFrame", "ItemTextFrame", "BankFrame",
	"OpenMailFrame", "StackSplitFrame", "MacOptionsFrame", "TutorialFrame", "StaticPopup1",
	"StaticPopup2", "ScrollOfResurrectionSelectionFrame"
}

for i, v in pairs(frames) do
	if _G[v] then
		_G[v]:EnableMouse(true)
		_G[v]:SetMovable(true)
		_G[v]:SetClampedToScreen(true)
		_G[v]:RegisterForDrag("LeftButton")
		_G[v]:SetScript("OnDragStart", function(self) self:StartMoving() end)
		_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	end
end

local AddOnFrames = {
	["Blizzard_AuctionUI"] = {"AuctionFrame"},
	["Blizzard_BindingUI"] = {"KeyBindingFrame"},
	["Blizzard_GMSurveyUI"] = {"GMSurveyFrame"},
	["Blizzard_GuildBankUI"] = {"GuildBankFrame"},
	["Blizzard_InspectUI"] = {"InspectFrame"},
	["Blizzard_ItemSocketingUI"] = {"ItemSocketingFrame"},
	["Blizzard_MacroUI"] = {"MacroFrame"},
	["Blizzard_TalentUI"] = {"PlayerTalentFrame"},
	["Blizzard_TradeSkillUI"] = {"TradeSkillFrame"},
	["Blizzard_TrainerUI"] = {"ClassTrainerFrame"}
}

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addon)
	if AddOnFrames[addon] then
		for _, v in pairs(AddOnFrames[addon]) do
			if _G[v] then
				_G[v]:EnableMouse(true)
				_G[v]:SetMovable(true)
				_G[v]:SetClampedToScreen(true)
				_G[v]:RegisterForDrag("LeftButton")
				_G[v]:SetScript("OnDragStart", function(self) self:StartMoving() end)
				_G[v]:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
			end
		end
	end
end)
