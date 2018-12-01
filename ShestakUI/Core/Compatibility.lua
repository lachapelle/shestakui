local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Lua API
----------------------------------------------------------------------------------------
function table.wipe(t)
	assert(type(t) == "table", format("bad argument #1 to 'wipe' (table expected, got %s)", t and type(t) or "no value"))

	for k in pairs(t) do
		t[k] = nil
	end

	return t
end
wipe = table.wipe

local LOCAL_ToStringAllTemp = {}
function tostringall(...)
	local n = select('#', ...)
	-- Simple versions for common argument counts
	if (n == 1) then
		return tostring(...)
	elseif (n == 2) then
		local a, b = ...
		return tostring(a), tostring(b)
	elseif (n == 3) then
		local a, b, c = ...
		return tostring(a), tostring(b), tostring(c)
	elseif (n == 0) then
		return
	end

	local needfix
	for i = 1, n do
		local v = select(i, ...)
		if (type(v) ~= "string") then
			needfix = i
			break
		end
	end
	if (not needfix) then return ... end

	wipe(LOCAL_ToStringAllTemp)
	for i = 1, needfix - 1 do
		LOCAL_ToStringAllTemp[i] = select(i, ...)
	end
	for i = needfix, n do
		LOCAL_ToStringAllTemp[i] = tostring(select(i, ...))
	end
	return unpack(LOCAL_ToStringAllTemp)
end

local LOCAL_PrintHandler = function(...)
	DEFAULT_CHAT_FRAME:AddMessage(strjoin(" ", tostringall(...)))
end

function setprinthandler(func)
	if (type(func) ~= "function") then
		error("Invalid print handler")
	else
		LOCAL_PrintHandler = func
	end
end

function getprinthandler() return LOCAL_PrintHandler end

local function print_inner(...)
	local ok, err = pcall(LOCAL_PrintHandler, ...)
	if (not ok) then
		local func = geterrorhandler()
		func(err)
	end
end

function print(...)
	securecall(pcall, print_inner, ...)
end

SLASH_PRINT1 = "/print"
SlashCmdList["PRINT"] = print

----------------------------------------------------------------------------------------
--	WoW API
----------------------------------------------------------------------------------------
CLASS_SORT_ORDER = {
	"WARRIOR",
	"PALADIN",
	"PRIEST",
	"SHAMAN",
	"DRUID",
	"ROGUE",
	"MAGE",
	"WARLOCK",
	"HUNTER"
}

QuestDifficultyColors = {
	["impossible"] = {r = 1.00, g = 0.10, b = 0.10},
	["verydifficult"] = {r = 1.00, g = 0.50, b = 0.25},
	["difficult"] = {r = 1.00, g = 1.00, b = 0.00},
	["standard"] = {r = 0.25, g = 0.75, b = 0.25},
	["trivial"] = {r = 0.50, g = 0.50, b = 0.50},
	["header"] = {r = 0.70, g = 0.70, b = 0.70}
}

function GetQuestDifficultyColor(level)
	local levelDiff = level - UnitLevel("player")
	if levelDiff >= 5 then
		return QuestDifficultyColors["impossible"]
	elseif levelDiff >= 3 then
		return QuestDifficultyColors["verydifficult"]
	elseif levelDiff >= -2 then
		return QuestDifficultyColors["difficult"]
	elseif -levelDiff <= GetQuestGreenRange() then
		return QuestDifficultyColors["standard"]
	else
		return QuestDifficultyColors["trivial"]
	end
end

function IsSpellKnown(spell)
	assert((type(spell) == "string" or type(spell) == "number"), "Usage: IsSpellKnown(\"spellName\" | spellID)")

	local spellName

	if type(spell) == "number" then
		spellName = GetSpellInfo(spell)
	else
		spellName = spell
	end

	if GetSpellTexture(spellName) then
		return true
	else
		return false
	end
end

function UnitAura(unit, i, filter)
	assert((type(unit) == "string" or type(unit) == "number") and (type(i) == "string" or type(i) == "number"), "Usage: UnitAura(\"unit\", index[, \"filter\"])")

	if not filter or strmatch(filter, "(HELPFUL)") then
		local name, rank, aura, count, duration, maxDuration = UnitBuff(unit, i, filter)
		return name, rank, aura, count, nil, duration or 0, maxDuration or 0
	else
		local name, rank, aura, count, dType, duration, maxDuration = UnitDebuff(unit, i, filter)
		return name, rank, aura, count, dType, duration or 0, maxDuration or 0
	end
end

--Like date(), but localizes AM/PM. In the future, could also localize other stuff.
function BetterDate(formatString, timeVal)
	local dateTable = date("*t", timeVal);
	local amString = (dateTable.hour >= 12) and TIMEMANAGER_PM or TIMEMANAGER_AM;
	
	--First, we'll replace %p with the appropriate AM or PM.
	formatString = gsub(formatString, "^%%p", amString)	--Replaces %p at the beginning of the string with the am/pm token
	formatString = gsub(formatString, "([^%%])%%p", "%1"..amString); -- Replaces %p anywhere else in the string, but doesn't replace %%p (since the first % escapes the second)
	
	return date(formatString, timeVal);
end

function ToggleFrame(frame)
	if frame:IsShown() then
		HideUIPanel(frame)
	else
		ShowUIPanel(frame)
	end
end

local function OnSizeChanged(self, width, height)
	self.texturePointer.width = width
	self.texturePointer.height = height
	self.texturePointer:SetWidth(width)
	self.texturePointer:SetHeight(height)
end

local function OnValueChanged(self, value)
	local _, max = self:GetMinMaxValues()

	if self.texturePointer.verticalOrientation then
		self.texturePointer:SetHeight(self.texturePointer.height * (value / max))
	else
		self.texturePointer:SetWidth(self.texturePointer.width * (value / max))
	end
end

local threatColors = {
	[0] = {0.69, 0.69, 0.69},
	[1] = {1, 1, 0.47},
	[2] = {1, 0.6, 0},
	[3] = {1, 0, 0}
}

function GetThreatStatusColor(statusIndex)
	if not (type(statusIndex) == "number" and statusIndex >= 0 and statusIndex < 4) then
		statusIndex = 0
	end

	return threatColors[statusIndex][1], threatColors[statusIndex][2], threatColors[statusIndex][3]
end


function GetThreatStatus(currentThreat, maxThreat)
	assert(type(currentThreat) == "number" and type(maxThreat) == "number", "Usage: GetThreatStatus(currentThreat, maxThreat)")

	if not maxThreat or maxThreat == 0 then
		maxThreat = 0
		maxThreat = 1
	end

	local threatPercent = currentThreat / maxThreat * 100

	if threatPercent >= 100 then
		return 3, threatPercent
	elseif threatPercent < 100 and threatPercent >= 80 then
		return 2, threatPercent
	elseif threatPercent < 80 and threatPercent >= 50 then
		return 1, threatPercent
	else
		return 0, threatPercent
	end
end

local ThreatLib = LibStub("Threat-2.0", true)

function UnitDetailedThreatSituation(unit, mob)
	assert(type(unit) == "string" and (type(mob) == "string"), "Usage: UnitDetailedThreatSituation(\"unit\", \"mob\")")
	
	local firstGUID, secondGUID = UnitGUID(unit), UnitGUID(mob)
	local currentThreat, maxThreat = ThreatLib:GetThreat(firstGUID, secondGUID), ThreatLib:GetMaxThreatOnTarget(secondGUID)

	local isTanking = nil
	local status, rawthreatpct = GetThreatStatus(currentThreat, maxThreat)
	local threatpct = nil
	local threatvalue = currentThreat
	
	if status > 1 then
		isTanking = 1
	end

	return isTanking, status, threatpct, rawthreatpct, threatvalue
end

function UnitThreatSituation(unit, otherunit) -- need to make arg2 optional
	assert(type(unit) == "string" and (type(otherunit) == "string"), "Usage: UnitThreatSituation(\"unit\"[, \"otherunit\"])")
	
	local firstGUID, secondGUID = UnitGUID(unit), UnitGUID(otherunit)
	local currentThreat, maxThreat = ThreatLib:GetThreat(firstGUID, secondGUID), ThreatLib:GetMaxThreatOnTarget(secondGUID)

	local status = GetThreatStatus(currentThreat, maxThreat)

	return status
end