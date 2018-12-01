local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.actionbar.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Style ActionBars buttons(by Tukz)
----------------------------------------------------------------------------------------
local function StyleNormalButton(self)
	local self = this -- TBC Compatibility
	local name = self:GetName()
	local button = self
	local icon = _G[name.."Icon"]
	local count = _G[name.."Count"]
	local flash = _G[name.."Flash"]
	local hotkey = _G[name.."HotKey"]
	local border = _G[name.."Border"]
	local btname = _G[name.."Name"]
	local normal = _G[name.."NormalTexture"]
	local float = _G[name.."FloatingBG"]

	flash:SetTexture("")
	button:SetNormalTexture("")

	if float then
		float:Hide()
		float = T.dummy
	end

	if border then
		border:Hide()
		border = T.dummy
	end

	count:ClearAllPoints()
	count:SetPoint("BOTTOMRIGHT", 0, 2)
	count:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
	count:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)

	if btname then
		if C.actionbar.macro == true then
			btname:ClearAllPoints()
			btname:SetPoint("BOTTOM", 0, 0)
			btname:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
			btname:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
			btname:SetWidth(C.actionbar.button_size - 1)
		else
			btname:Kill()
		end
	end

	if C.actionbar.hotkey == true then
		hotkey:ClearAllPoints()
		hotkey:SetPoint("TOPRIGHT", 0, 0)
		hotkey:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		hotkey:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
		hotkey:SetWidth(C.actionbar.button_size - 1)
		hotkey.ClearAllPoints = T.dummy
		hotkey.SetPoint = T.dummy
	else
		hotkey:Kill()
	end

	if not button.isSkinned then
		if self:GetHeight() ~= C.actionbar.button_size and not InCombatLockdown() and not name:match("ExtraAction") then
			self:SetSize(C.actionbar.button_size, C.actionbar.button_size)
		end
		button:CreateBackdrop("Transparent")
		button.backdrop:SetAllPoints()
		if C.actionbar.classcolor_border == true then
			button.backdrop:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
		end

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:SetPoint("TOPLEFT", button, 2, -2)
		icon:SetPoint("BOTTOMRIGHT", button, -2, 2)

		button.isSkinned = true
	end

	if normal and button:GetChecked() then
		ActionButton_UpdateState(button)
	end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

local function StyleSmallButton(normal, button, icon, name, pet)
	local flash = _G[name.."Flash"]
	local hotkey = _G[name.."HotKey"]

	button:SetNormalTexture("")

	hooksecurefunc(button, "SetNormalTexture", function(self, texture)
		if texture and texture ~= "" then
			self:SetNormalTexture("")
		end
	end)

	flash:SetTexture(0.8, 0.8, 0.8, 0.5)
	flash:SetPoint("TOPLEFT", button, 2, -2)
	flash:SetPoint("BOTTOMRIGHT", button, -2, 2)

	if C.actionbar.hotkey == true then
		hotkey:ClearAllPoints()
		hotkey:SetPoint("TOPRIGHT", 0, 0)
		hotkey:SetFont(C.font.action_bars_font, C.font.action_bars_font_size, C.font.action_bars_font_style)
		hotkey:SetShadowOffset(C.font.action_bars_font_shadow and 1 or 0, C.font.action_bars_font_shadow and -1 or 0)
		hotkey:SetWidth(C.actionbar.button_size - 1)
		hotkey.ClearAllPoints = T.dummy
		hotkey.SetPoint = T.dummy
	else
		hotkey:Kill()
	end

	if not button.isSkinned then
		button:SetSize(C.actionbar.button_size, C.actionbar.button_size)
		button:CreateBackdrop("Transparent")
		button.backdrop:SetAllPoints()
		if C.actionbar.classcolor_border == true then
			button.backdrop:SetBackdropBorderColor(T.color.r, T.color.g, T.color.b)
		end

		icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", button, 2, -2)
		icon:SetPoint("BOTTOMRIGHT", button, -2, 2)

		if pet then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetSize((C.actionbar.button_size * 2) - 10, (C.actionbar.button_size * 2) - 10)
			autocast:ClearAllPoints()
			autocast:SetPoint("CENTER", button, 0, 0)

			local shine = _G[name.."AutoCast"]
			shine:SetSize(C.actionbar.button_size, C.actionbar.button_size)

			local cooldown = _G[name.."Cooldown"]
			cooldown:SetSize(C.actionbar.button_size - 2, C.actionbar.button_size - 2)
		end

		button.isSkinned = true
	end

	if normal then
		normal:ClearAllPoints()
		normal:SetPoint("TOPLEFT")
		normal:SetPoint("BOTTOMRIGHT")
	end
end

function T.StyleShift()
	for i = 1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button = _G[name]
		local icon = _G[name.."Icon"]
		local normal = _G[name.."NormalTexture"]
		StyleSmallButton(normal, button, icon, name)
	end
end

function T.StylePet()
	for i = 1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button = _G[name]
		local icon = _G[name.."Icon"]
		local normal = _G[name.."NormalTexture2"]
		StyleSmallButton(normal, button, icon, name, true)
	end
end

local function UpdateHotkey(self, actionButtonType)
	local self = this -- TBC Compatibility
	local hotkey = _G[self:GetName().."HotKey"]
	local text = hotkey:GetText()

	text = gsub(text, "(s%-)", "S")
	text = gsub(text, "(a%-)", "A")
	text = gsub(text, "(а%-)", "A") -- fix ruRU
	text = gsub(text, "(c%-)", "C")
	text = gsub(text, "(Mouse Button )", "M")
	text = gsub(text, "(Кнопка мыши )", "M")
	text = gsub(text, KEY_BUTTON3, "M3")
	text = gsub(text, KEY_PAGEUP, "PU")
	text = gsub(text, KEY_PAGEDOWN, "PD")
	text = gsub(text, KEY_SPACE, "SpB")
	text = gsub(text, KEY_INSERT, "Ins")
	text = gsub(text, KEY_HOME, "Hm")
	text = gsub(text, KEY_DELETE, "Del")
	text = gsub(text, KEY_NUMPADDECIMAL, "Nu.")
	text = gsub(text, KEY_NUMPADDIVIDE, "Nu/")
	text = gsub(text, KEY_NUMPADMINUS, "Nu-")
	text = gsub(text, KEY_NUMPADMULTIPLY, "Nu*")
	text = gsub(text, KEY_NUMPADPLUS, "Nu+")
	text = gsub(text, KEY_NUMLOCK, "NuL")
	text = gsub(text, KEY_MOUSEWHEELDOWN, "MWD")
	text = gsub(text, KEY_MOUSEWHEELUP, "MWU")

	if hotkey:GetText() == _G["RANGE_INDICATOR"] then
		hotkey:SetText("")
	else
		hotkey:SetText(text)
	end
end

local function HideHighlightButton(self)
	if self.overlay then
		self.overlay:Hide()
		ActionButton_HideOverlayGlow(self)
	end
end

do
	for i = 1, 12 do
		_G["ActionButton"..i]:StyleButton()
		_G["BonusActionButton"..i]:StyleButton()
		_G["MultiBarBottomLeftButton"..i]:StyleButton()
		_G["MultiBarBottomRightButton"..i]:StyleButton()
		_G["MultiBarLeftButton"..i]:StyleButton()
		_G["MultiBarRightButton"..i]:StyleButton()
	end

	for i = 1, 10 do
		_G["ShapeshiftButton"..i]:StyleButton()
		_G["PetActionButton"..i]:StyleButton()
	end
end

hooksecurefunc("ActionButton_Update", StyleNormalButton)
if C.actionbar.hotkey == true then
	hooksecurefunc("ActionButton_OnEvent", function(self, event, ...) if event == "PLAYER_ENTERING_WORLD" then ActionButton_UpdateHotkeys(self, self.buttonType) end end)
	hooksecurefunc("ActionButton_UpdateHotkeys", UpdateHotkey)
end
if C.actionbar.hide_highlight == true then
	hooksecurefunc("ActionButton_ShowOverlayGlow", HideHighlightButton)
end