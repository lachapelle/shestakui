local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))
if C.unitframe.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Tags
----------------------------------------------------------------------------------------
local ns = oUF
local oUF = ns.oUF

--[[
oUF.Tags.Methods["Threat"] = function(unit)
	local _, status, percent = UnitDetailedThreatSituation("player", "target")
	if percent and percent > 0 then
		return ("%s%d%%|r"):format(Hex(GetThreatStatusColor(status)), percent)
	end
end
oUF.Tags.Events["Threat"] = "UNIT_THREAT_LIST_UPDATE"
--]]

oUF.Tags.Methods["DiffColor"] = function(unit)
	local r, g, b
	local level = UnitLevel(unit)
	if level < 1 then
		r, g, b = 0.69, 0.31, 0.31
	else
		local DiffColor = UnitLevel(unit) - UnitLevel("player")
		if DiffColor >= 5 then
			r, g, b = 0.69, 0.31, 0.31
		elseif DiffColor >= 3 then
			r, g, b = 0.71, 0.43, 0.27
		elseif DiffColor >= -2 then
			r, g, b = 0.84, 0.75, 0.65
		elseif -DiffColor <= GetQuestGreenRange() then
			r, g, b = 0.33, 0.59, 0.33
		else
			r, g, b = 0.55, 0.57, 0.61
		end
	end
	return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
end
oUF.Tags.Events["DiffColor"] = "UNIT_LEVEL"

oUF.Tags.Methods["PetNameColor"] = function(unit)
	return string.format("|cff%02x%02x%02x", T.color.r * 255, T.color.g * 255, T.color.b * 255)
end
oUF.Tags.Events["PetNameColor"] = "UNIT_POWER"

oUF.Tags.Methods["GetNameColor"] = function(unit)
	local reaction = UnitReaction(unit, "player")
	if UnitIsPlayer(unit) then
		return _TAGS["raidcolor"](unit)
	elseif reaction then
		local c = T.oUF_colors.reaction[reaction]
		return string.format("|cff%02x%02x%02x", c[1] * 255, c[2] * 255, c[3] * 255)
	else
		r, g, b = 0.33, 0.59, 0.33
		return string.format("|cff%02x%02x%02x", r * 255, g * 255, b * 255)
	end
end
oUF.Tags.Events["GetNameColor"] = "UNIT_POWER UNIT_FLAGS"

oUF.Tags.Methods["NameArena"] = function(unit)
	local name = UnitName(unit)
	return T.UTF(name, 4, false)
end
oUF.Tags.Events["NameArena"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["NameShort"] = function(unit)
	local name = UnitName(unit)
	return T.UTF(name, 8, false)
end
oUF.Tags.Events["NameShort"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["NameMedium"] = function(unit)
	local name = UnitName(unit)
	return T.UTF(name, 11, true)
end
oUF.Tags.Events["NameMedium"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["NameLong"] = function(unit)
	local name = UnitName(unit)
	return T.UTF(name, 18, true)
end
oUF.Tags.Events["NameLong"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["NameLongAbbrev"] = function(unit)
	local name = UnitName(unit)
	local newname = (string.len(name) > 18) and string.gsub(name, "%s?(.[\128-\191]*)%S+%s", "%1. ") or name
	return T.UTF(newname, 18, false)
end
oUF.Tags.Events["NameLongAbbrev"] = "UNIT_NAME_UPDATE"

oUF.Tags.Methods["LFD"] = function(unit)
	local role = UnitGroupRolesAssigned(unit)
	if role == "TANK" then
		return "|cff0070DE[T]|r"
	elseif role == "HEALER" then
		return "|cff00CC12[H]|r"
	elseif role == "DAMAGER" then
		return "|cffFF3030[D]|r"
	end
end
oUF.Tags.Events["LFD"] = "PLAYER_ROLES_ASSIGNED PARTY_MEMBERS_CHANGED"

--[[
if T.class == "DRUID" then
	for i = 1, 3 do
		oUF.Tags["WM"..i] = function(unit)
			_, _, _, dur = GetTotemInfo(i)
			if dur > 0 then
				return "|cffFF2222_|r"
			end
		end
		oUF.TagEvents["WM"..i] = "PLAYER_TOTEM_UPDATE"
		oUF.UnitlessTagEvents.PLAYER_TOTEM_UPDATE = true
	end
end
--]]

--[[
oUF.Tags.Methods["IncHeal"] = function(unit)
	local incheal = UnitGetIncomingHeals(unit) or 0
	local player = UnitGetIncomingHeals(unit, "player") or 0
	incheal = incheal - player
	if incheal > 0 then
		return "|cff00FF00+"..T.ShortValue(incheal).."|r"
	end
end
oUF.Tags.Events["IncHeal"] = "UNIT_HEAL_PREDICTION"
--]]