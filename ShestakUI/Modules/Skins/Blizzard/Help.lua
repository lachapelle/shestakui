local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	Help skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	HelpFrame:StripTextures()
	HelpFrame:CreateBackdrop("Transparent")
	HelpFrame.backdrop:SetPoint("TOPLEFT", 6, 0)
	HelpFrame.backdrop:SetPoint("BOTTOMRIGHT", -45, 14)

	local knowFrameButtons = {
		"Cancel",
		"GMTalk",
		"ReportIssue",
		"Stuck",
		"SearchButton",
		"TopIssuesButton"
	}
	for i = 1, #knowFrameButtons do
		local knowButton = _G["KnowledgeBaseFrame"..knowFrameButtons[i]]

		knowButton:SkinButton()
	end

	local helpFrameButtons = {
		"GMTalkOpenTicket",
		"GMTalkCancel",
		"OpenTicketSubmit",
		"OpenTicketCancel",
		"ReportIssueOpenTicket",
		"ReportIssueCancel",
		"StuckStuck",
		"StuckOpenTicket",
		"StuckCancel"
	}
	for i = 1, #helpFrameButtons do
		local helpButton = _G["HelpFrame"..helpFrameButtons[i]]

		helpButton:SkinButton()
	end

	T.SkinCloseButton(HelpFrameCloseButton)
	HelpFrameCloseButton:SetPoint("TOPRIGHT", -49, -4)
	
	KnowledgeBaseFrame:StripTextures()

	KnowledgeBaseFrameHeader:SetTexture("")
	KnowledgeBaseFrameHeader:ClearAllPoints()
	KnowledgeBaseFrameHeader:SetPoint("TOP", -22, -8)

	HelpFrameOpenTicketDivider:StripTextures()

	T.SkinScrollBar(HelpFrameOpenTicketScrollFrame)
	T.SkinScrollBar(HelpFrameOpenTicketScrollFrameScrollBar)
	T.SkinScrollBar(KnowledgeBaseArticleScrollFrameScrollBar)

	HelpFrameOpenTicketSubmit:SetPoint("RIGHT", HelpFrameOpenTicketCancel, "LEFT", -2, 0)
	KnowledgeBaseFrameStuck:SetPoint("LEFT", KnowledgeBaseFrameReportIssue, "RIGHT", 2, 0)

	KnowledgeBaseFrameDivider:Kill()
	KnowledgeBaseFrameDivider2:Kill()

	T.SkinEditBox(KnowledgeBaseFrameEditBox)

	KnowledgeBaseFrameEditBox.backdrop:SetPoint("TOPLEFT", -6, -5)
	KnowledgeBaseFrameEditBox.backdrop:SetPoint("BOTTOMRIGHT", 2, 5)

	T.SkinDropDownBox(KnowledgeBaseFrameCategoryDropDown)
	KnowledgeBaseFrameCategoryDropDown:SetPoint("TOPLEFT", "KnowledgeBaseFrameEditBox", "TOPRIGHT", -14, -3)

	T.SkinDropDownBox(KnowledgeBaseFrameSubCategoryDropDown)
	KnowledgeBaseFrameSubCategoryDropDown:SetPoint("TOPLEFT", "KnowledgeBaseFrameCategoryDropDown","TOPRIGHT", -24, 0)

	KnowledgeBaseFrameSearchButton:SetPoint("TOPLEFT", "KnowledgeBaseFrameSubCategoryDropDown","TOPRIGHT", -4, -2)

	T.SkinNextPrevButton(KnowledgeBaseArticleListFrameNextButton)
	T.SkinNextPrevButton(KnowledgeBaseArticleListFramePreviousButton)

	KnowledgeBaseArticleScrollChildFrameBackButton:SkinButton()
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)