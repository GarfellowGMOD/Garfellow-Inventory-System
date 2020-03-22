AddCSLuaFile()
include("invfuncs.lua")

ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Inventory Clipboard"

ENT.Spawnable = true

local function timerDelay(delay)
	if shouldOccur then
		shouldOccur = false
		timer.Simple( delay, function() shouldOccur = true end )
		return true
	else
		return false
	end
end


function ENT:Initialize()
	if SERVER then
		self:SetModel("models/props_lab/clipboard.mdl")
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

function ENT:Use(a, c)
	for i = 1, 30 do
		local invName = "invSpace_"..i..""
		local value = a:GetNWString(invName)
		if (value == '0') then
			a:SetNWString(invName, 'inv_Clipboard')
			self:Remove()
			break
		end
	end
end

function drawClipboardGui()
	draw.RoundedBox(2, (ScrW()/2), (ScrH()/2), 150, 40, Color(0, 0, 0, 175))
	surface.SetFont( "TitleFont" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( (ScrW()/2+20), (ScrH()/2+7) ) 
	surface.DrawText( "Clipboard" )
end

hook.Add("HUDPaint", "loadLookGUIclipboard", function()
	local eye = LocalPlayer():GetEyeTrace()
	local start_pos = LocalPlayer():GetEyeTrace().StartPos
	local offset = 100
	local ent_pos = eye.Entity:GetPos()
	if eye.Entity:GetClass() == "inv_clipboard" && eye.Entity:BeingLookedAtByLocalPlayer() then
		drawClipboardGui()
	end

end )
