local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.skins.blizzard_frames ~= true then return end

----------------------------------------------------------------------------------------
--	WorldStateScore skin
----------------------------------------------------------------------------------------
local function LoadSkin()
	WorldStateScoreScrollFrame:StripTextures()
	WorldStateScoreFrame:StripTextures()
	WorldStateScoreFrame:SetTemplate("Transparent")
	T.SkinCloseButton(WorldStateScoreFrameCloseButton)
	-- WorldStateScoreFrameInset:Kill()
	WorldStateScoreFrameLeaveButton:SkinButton()

	for i = 1, WorldStateScoreScrollFrameScrollChildFrame:GetNumChildren() do
		local b = _G["WorldStateScoreButton"..i]
		b:StripTextures()
		b:StyleButton(false)
		b:SetTemplate("Default", true)
	end

	for i = 1, 3 do
		T.SkinTab(_G["WorldStateScoreFrameTab"..i])
	end
end

table.insert(T.SkinFuncs["ShestakUI"], LoadSkin)