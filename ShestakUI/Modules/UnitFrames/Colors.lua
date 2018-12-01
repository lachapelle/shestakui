local T, C, L, _ = unpack(select(2, ShestakAddonInfo()))

----------------------------------------------------------------------------------------
--	Colors
----------------------------------------------------------------------------------------
local ns = oUF
local oUF = ns.oUF

T.oUF_colors = setmetatable({
	tapped = {0.6, 0.6, 0.6},
	disconnected = {0.84, 0.75, 0.65},
	power = setmetatable({
		[0] = {0.31, 0.45, 0.63}, -- MANA
		[1] = {0.69, 0.31, 0.31}, -- RAGE
		[2] = {0.71, 0.43, 0.27}, -- FOCUS
		[3] = {0.65, 0.63, 0.35}, -- ENERGY
		[4] = {0.00, 0.82, 1.00}, -- HAPPINESS
		[5] = {0.55, 0.57, 0.61}, -- RUNES
		[6] = {0.00, 0.82, 1.00}, -- RUNIC_POWER
	}, {__index = oUF.colors.power}),
	reaction = setmetatable({
		[1] = {0.85, 0.27, 0.27}, -- Hated
		[2] = {0.85, 0.27, 0.27}, -- Hostile
		[3] = {0.85, 0.27, 0.27}, -- Unfriendly
		[4] = {0.85, 0.77, 0.36}, -- Neutral
		[5] = {0.33, 0.59, 0.33}, -- Friendly
		[6] = {0.33, 0.59, 0.33}, -- Honored
		[7] = {0.33, 0.59, 0.33}, -- Revered
		[8] = {0.33, 0.59, 0.33}, -- Exalted
	}, {__index = oUF.colors.reaction}),
}, {__index = oUF.colors})