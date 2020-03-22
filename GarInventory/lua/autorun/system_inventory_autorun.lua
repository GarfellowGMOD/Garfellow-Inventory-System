//Runs Serverside and ClientSide Aspects
if SERVER then
	include("system_inventory/init.lua")
elseif CLIENT then
	include("system_inventory/cl_init.lua")
	include("system_inventory/invdata.lua")
end
