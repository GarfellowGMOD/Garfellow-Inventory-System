AddCSLuaFile()
include("invfuncs.lua")


ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Inventory Console"

ENT.Spawnable = true

//TAKEN FROM WIKI.
function Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end




function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_c17/consolebox03a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self.timer = CurTime()

		local phys = self:GetPhysicsObject()

		if phys:IsValid() then

			phys:Wake()

		end
	end
end



function isInRangeOf(ent_pos, start_pos, offset)
	if (start_pos > 0) then
		if (ent_pos > 0) then
			if ((ent_pos + offset) > start_pos) then
				return true
			else
				return false
			end
		else

		end
	end
end

function ENT:Think()
	
end

function ENT:Use(a, c)
	for i = 1, 30 do
		local invName = "invSpace_"..i..""
		local value = a:GetNWString(invName)
		if (value == '0') then
			a:SetNWString(invName, 'inv_Console')
			self:Remove()
			break
		end
	end
end

function drawConsoleGui()
	draw.RoundedBox(2, (ScrW()/2), (ScrH()/2), 150, 40, Color(0, 0, 0, 175))
	surface.SetFont( "TitleFont" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( (ScrW()/2+20), (ScrH()/2+7) ) 
	surface.DrawText( "Console" )
end

hook.Add("HUDPaint", "loadLookGUIconsole", function()
	local eye = LocalPlayer():GetEyeTrace()
	local start_pos = LocalPlayer():GetEyeTrace().StartPos
	local offset = 100
	local ent_pos = eye.Entity:GetPos()
	if eye.Entity:GetClass() == "inv_console" && eye.Entity:BeingLookedAtByLocalPlayer() then
		drawConsoleGui()
	end

end )
