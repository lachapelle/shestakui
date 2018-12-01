local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	MacroUI skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	MacroFrame:StripTextures()
	MacroFrame:CreateBackdrop("Transparent")
	MacroFrame.backdrop:SetPoint("TOPLEFT", 10, -11)
	MacroFrame.backdrop:SetPoint("BOTTOMRIGHT", -32, 71)

	MacroFrame.bg = CreateFrame("Frame", nil, MacroFrame)
	MacroFrame.bg:SetTemplate("Transparent", true)
	MacroFrame.bg:SetPoint("TOPLEFT", MacroButton1, -10, 10)
	MacroFrame.bg:SetPoint("BOTTOMRIGHT", MacroButton18, 10, -10)

	MacroFrameTextBackground:StripTextures()
	MacroFrameTextBackground:CreateBackdrop("Default")
	MacroFrameTextBackground.backdrop:SetPoint("TOPLEFT", 6, -3)
	MacroFrameTextBackground.backdrop:SetPoint("BOTTOMRIGHT", -2, 3)

	local Buttons = {
		"MacroFrameTab1",
		"MacroFrameTab2",
		"MacroDeleteButton",
		"MacroNewButton",
		"MacroExitButton",
		"MacroEditButton",
		"MacroPopupOkayButton",
		"MacroPopupCancelButton"
	}

	for i = 1, #Buttons do
		_G[Buttons[i]]:StripTextures()
		_G[Buttons[i]]:SkinButton()
	end

	for i = 1, 2 do
		local tab = _G["MacroFrameTab" .. i]

		tab:SetHeight(22)
	end

	MacroFrameTab1:SetPoint("TOPLEFT", MacroFrame, "TOPLEFT", 85, -39)
	MacroFrameTab2:SetPoint("LEFT", MacroFrameTab1, "RIGHT", 4, 0)

	T.SkinCloseButton(MacroFrameCloseButton)
	MacroFrameCloseButton:SetPoint("TOPRIGHT", -36, -15)

	T.SkinScrollBar(MacroFrameScrollFrameScrollBar)
	T.SkinScrollBar(MacroPopupScrollFrameScrollBar)
	MacroPopupScrollFrameScrollBar:SetPoint("RIGHT", 40, 0)

	MacroEditButton:ClearAllPoints()
	MacroEditButton:SetPoint("BOTTOMLEFT", MacroFrameSelectedMacroButton, "BOTTOMRIGHT", 10, 0)

	MacroFrameSelectedMacroName:SetPoint("TOPLEFT", MacroFrameSelectedMacroBackground, "TOPRIGHT", -4, -10)

	MacroFrameSelectedMacroButton:StripTextures()
	MacroFrameSelectedMacroButton:SetTemplate("Transparent")
	MacroFrameSelectedMacroButton:StyleButton(true)

	MacroFrameSelectedMacroButtonIcon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
	MacroFrameSelectedMacroButtonIcon:SetInside()

	MacroFrameCharLimitText:ClearAllPoints()
	MacroFrameCharLimitText:SetPoint("BOTTOM", MacroFrameTextBackground, 0, -9)

	for i = 1, MAX_MACROS do
		local button = _G["MacroButton"..i]
		local icon = _G["MacroButton"..i.."Icon"]

		if button then
			button:StripTextures()
			button:SetTemplate("Default", true)
			-- button:StyleButton(nil, true)
			button:StyleButton(true)
		end

		if icon then
			icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			icon:SetInside()
		end
	end

	T.SkinIconSelectionFrame(MacroPopupFrame, NUM_MACRO_ICONS_SHOWN, "MacroPopupButton", "MacroPopup")

	MacroPopupScrollFrame:CreateBackdrop("Transparent")
	MacroPopupScrollFrame.backdrop:SetPoint("TOPLEFT", 51, 2)
	MacroPopupScrollFrame.backdrop:SetPoint("BOTTOMRIGHT", 0, 4)

	MacroPopupFrame:SetPoint("TOPLEFT", MacroFrame, "TOPRIGHT", -24, -11)
end

T.SkinFuncs["Blizzard_MacroUI"] = LoadSkin