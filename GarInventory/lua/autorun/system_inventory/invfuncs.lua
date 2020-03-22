//Functions that will occur when certain items are used
include("invdata.lua")
invData = getInvData()

if SERVER then 
	util.AddNetworkString("Use_Func") 
end


net.Receive("Use_Func", function(len, ply)
	local name = net.ReadString()
	if (name == "inv_Console") then
		inv_ConsoleFunc(ply)
	elseif (name == "inv_Clipboard") then
		inv_ClipboardFunc(ply)
	end
end)

function inv_ConsoleFunc(ply)
	ply:Kill()
end

function inv_ClipboardFunc(ply)
	ply:Give("weapon_clipboard")
end