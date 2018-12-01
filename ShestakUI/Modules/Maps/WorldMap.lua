local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Font replacement
----------------------------------------------------------------------------------------
WorldMapFrameAreaLabel:SetFont(C.media.normal_font, 45)
WorldMapFrameAreaLabel:SetShadowOffset(2, -2)
WorldMapFrameAreaLabel:SetTextColor(0.9, 0.83, 0.64)

WorldMapFrameAreaDescription:SetFont(C.media.normal_font, 30)
WorldMapFrameAreaDescription:SetShadowOffset(2, -2)

----------------------------------------------------------------------------------------
--	Change position
----------------------------------------------------------------------------------------
function SetUIPanelAttribute(frame, name, value)
	local info = UIPanelWindows[frame:GetName()]
	if not info then return end

	if not frame:GetAttribute("UIPanelLayout-defined") then
		frame:SetAttribute("UIPanelLayout-defined", true)
		for name,value in pairs(info) do
			frame:SetAttribute("UIPanelLayout-"..name, value)
		end
	end

	frame:SetAttribute("UIPanelLayout-"..name, value)
end

BlackoutWorld:SetTexture(nil)
WorldMapFrame:SetParent(UIParent)
WorldMapFrame:SetScale(1)
WorldMapFrame:EnableKeyboard(false)
WorldMapFrame:EnableMouse(false)
WorldMapFrame:SetToplevel()

table.insert(UISpecialFrames, WorldMapFrame:GetName())

if WorldMapFrame:GetAttribute("UIPanelLayout-area") ~= "center" then
	SetUIPanelAttribute(WorldMapFrame, "area", "center")
end

if WorldMapFrame:GetAttribute("UIPanelLayout-allowOtherPanels") ~= true then
	SetUIPanelAttribute(WorldMapFrame, "allowOtherPanels", true)
end

DropDownList1:HookScript("OnShow", function()
	if DropDownList1:GetScale() ~= UIParent:GetScale() then
		DropDownList1:SetScale(UIParent:GetScale())
	end
end)

WorldMapTooltip:SetFrameLevel(WorldMapPositioningGuide:GetFrameLevel() + 110)

----------------------------------------------------------------------------------------
--	Creating coordinate
----------------------------------------------------------------------------------------
local coords = CreateFrame("Frame", "CoordsFrame", WorldMapFrame)
-- coords:SetFrameLevel(90)
coords:SetFrameLevel(WorldMapFrame:GetFrameLevel() + 2)
coords:SetFrameStrata(WorldMapFrame:GetFrameStrata())
coords.PlayerText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.PlayerText:SetPoint("BOTTOMLEFT", WorldMapButton, "BOTTOMLEFT", 5, 5)
coords.PlayerText:SetJustifyH("LEFT")
coords.PlayerText:SetText(UnitName("player")..": 0,0")

coords.MouseText = coords:CreateFontString(nil, "ARTWORK", "GameFontNormal")
coords.MouseText:SetJustifyH("LEFT")
coords.MouseText:SetPoint("BOTTOMLEFT", coords.PlayerText, "TOPLEFT", 0, 5)
coords.MouseText:SetText(L_MAP_CURSOR..": 0,0")

local int = 0
WorldMapFrame:HookScript("OnUpdate", function(self, elapsed)
	int = int + 1
	if int >= 3 then
		local x, y = GetPlayerMapPosition("player")

		if not GetPlayerMapPosition("player") then
			x = 0
			y = 0
		end

		x = math.floor(100 * x)
		y = math.floor(100 * y)
		if x ~= 0 and y ~= 0 then
			coords.PlayerText:SetText(UnitName("player")..": "..x..","..y)
		else
			coords.PlayerText:SetText(UnitName("player")..": ".."|cffff0000"..L_MAP_BOUNDS.."|r")
		end

		local scale = WorldMapDetailFrame:GetEffectiveScale()
		local width = WorldMapDetailFrame:GetWidth()
		local height = WorldMapDetailFrame:GetHeight()
		local centerX, centerY = WorldMapDetailFrame:GetCenter()
		local x, y = GetCursorPosition()
		local adjustedX = (x / scale - (centerX - (width/2))) / width
		local adjustedY = (centerY + (height/2) - y / scale) / height

		if adjustedX >= 0 and adjustedY >= 0 and adjustedX <= 1 and adjustedY <= 1 then
			adjustedX = math.floor(100 * adjustedX)
			adjustedY = math.floor(100 * adjustedY)
			coords.MouseText:SetText(L_MAP_CURSOR..adjustedX..","..adjustedY)
		else
			coords.MouseText:SetText(L_MAP_CURSOR.."|cffff0000"..L_MAP_BOUNDS.."|r")
		end
		int = 0
	end
end)
