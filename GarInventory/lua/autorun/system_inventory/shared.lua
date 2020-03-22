//SHARED
include("invfuncs.lua")

function initializeInvData() 
	//print("TABLE BEING INIT:")
	if (!sql.TableExists("player_inv")) then
		//print("creating table")
		query = "CREATE TABLE player_inv ( unique_ID varchar(255) )"
		result = sql.Query(query)
		for i = 1, 30 do
			local invName = "invSpace_"..i..""
			sql.Query("ALTER TABLE player_inv ADD COLUMN "..invName.." varchar(255)")
		end
	else
		//print("TABLES ALREADY CREATED!!!")
	end
end

function isInvTable() 
	if (sql.TableExists("player_inv")) then return true else return false end
end

function isPlayerInInvTable(steamID)
	result = sql.Query("SELECT unique_ID FROM player_inv WHERE unique_ID = '"..steamID.."'")
	if (result) then return true else return false end
end

function getPlayerInvByNum(steamID, num)
	local invName = "invSpace_"..num..""
	local value = sql.QueryValue("SELECT "..invName.." FROM player_inv WHERE unique_ID = '"..steamID.."'")
	return value
end

function setPlayerInvByNum(steamID, num, message)
	local invName = 'invSpace_'..num..''
	sql.Query("UPDATE player_inv SET "..invName.." = '"..message.."' WHERE unique_ID = '"..steamID.."'")
end


//==================GMOD FUNCTIONS========================//


// HOOK FUNCTIONS:

local function initializeGame()
	initializeInvData()
end

function playerInitSpawn(ply)
	local steamID = ply:SteamID()
	if isInvTable() && !isPlayerInInvTable(steamID) then
		startvalue = "0"
		sql.Query("INSERT INTO player_inv ('unique_ID') VALUES ('"..steamID.."')")
		for i = 1, 30 do
			local invName = "invSpace_"..i..""
			sql.Query("UPDATE player_inv SET "..invName.." = '0' WHERE unique_ID = '"..steamID.."'")
		end
		//print("Player inserted into inv_table")
	else	
		//print("Player already in table!!")
	end
	for i = 1, 30 do
		local invName = "invSpace_"..i..""
		ply:SetNWString(invName, getPlayerInvByNum(ply:SteamID(), i))
	end
end

hook.Add("Initialize", "init", initializeGame)
hook.Add("PlayerInitialSpawn", "playerinitspawn", playerInitSpawn)

hook.Add("PlayerDeath", "playerdisconnect", function(ply, inflictor, attacker)
	if SERVER then
		if isInvTable() && isPlayerInInvTable(ply:SteamID()) then
			for i = 1, 30 do
				local invName = "invSpace_"..i..""
				setPlayerInvByNum(ply:SteamID(), i, ply:GetNWString(invName))	
			end
			
		end
	end
end)

