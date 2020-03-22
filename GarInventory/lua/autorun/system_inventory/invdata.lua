invData = { 
	["inv_Console"] = {["id"] = 1, ["title"] = "Test Console", ["desc"] = "A Test Box that when used will instantly kill you.", ["filename"] = "inv_console", ["img"] = "spawnicons/models/props_c17/consolebox01a_skin1_64.png", ["model"] = "models/props_c17/consolebox03a.mdl", ["equipable"] = false},
	["inv_Clipboard"] = {["id"] = 2, ["title"] = "Management Clipboard", ["desc"] = "For giving orders to lower ranking employees.", ["filename"] = "inv_clipboard", ["img"] = "spawnicons/models/props_lab/clipboard_64.png", ["model"] = "models/props_lab/clipboard.mdl", ["equipable"] = true,  ["swep"] = "weapon_clipboard"}
}

function getInvData() return invData end

if CLIENT then
	surface.CreateFont( "TitleFont", {
		font = "CloseCaption Normal", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 24	,
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = true,
	} )
	surface.CreateFont( "RegFont", {
		font = "CloseCaption Normal", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
		extended = false,
		size = 14,
		weight = 2000,
		blursize = 0,
		scanlines = 0,
		antialias = true,
		underline = false,
		italic = false,
		strikeout = false,
		symbol = false,
		rotary = false,
		shadow = false,
		additive = false,
		outline = false,
	} )
end