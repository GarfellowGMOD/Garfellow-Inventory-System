//SERVER
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("invdata.lua")
AddCSLuaFile("invfuncs")

include("shared.lua")

util.AddNetworkString("RecieveUpdate")
util.AddNetworkString("CreateEnt")
util.AddNetworkString("StripWeapon")

net.Receive("RecieveUpdate", function(len, ply)
	local num = net.ReadInt(16)
	local invName = "invSpace_"..num..""
	local value = net.ReadString()
	ply:SetNWString(invName, value)
end)

net.Receive("CreateEnt", function(len, ply)
	local name = net.ReadString()
	local model = net.ReadString()
	createEnt(ply, name, model)
end)

net.Receive("StripWeapon", function(len, ply)
	local weapon = net.ReadString()
	ply:StripWeapon(weapon)
end)

function calculateSpawnPos(ply)
	local start_pos = ply:GetEyeTrace().StartPos
	local aim_pos = ply:GetAimVector()
	local offset = 85
	local spawn_pos = Vector(start_pos[1]+(aim_pos[1]*offset), start_pos[2]+(aim_pos[2]*offset), start_pos[3]+(aim_pos[3]*offset))
	return spawn_pos
end

function createEnt(ply, ent, model) 
	local console = ents.Create(ent)
	console:SetModel(model)
	console:SetPos(calculateSpawnPos(ply))
	console:Spawn()
end

//==================GMOD FUNCTIONS========================//



// HOOK FUNCTIONS:


