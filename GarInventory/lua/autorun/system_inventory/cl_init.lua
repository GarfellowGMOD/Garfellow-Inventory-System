//CLIENT
include("shared.lua")
//Creates table will all data on the inventory items
include("invdata.lua")
invData = getInvData()
local invFrame = nil
local infoPanel = nil
local optionPanel = nil

function repaintPANEL(panel, r, b, g, a)
	panel.Paint = function()
		surface.SetDrawColor( r, b, g, a ) -- (R, B, G, A)
		surface.DrawRect( 0, 0, panel:GetWide(), panel:GetTall())
	end
end

function endInfoPanel()
	if (infoPanel ~= nil) then
		infoPanel:Remove()
		infoPanel = nil
	end
end

function loadGUI()
	ply = LocalPlayer()
	if (invFrame == nil) then
		invFrame = vgui.Create("DFrame")
		invFrame:SetSize(800, 600)
		invFrame:Center()
		invFrame:MakePopup()
		invFrame:SetTitle("")
		invFrame:SetDraggable(false)
		invFrame:SetVisible(true)
		invFrame:ShowCloseButton(false)

		//=======DRAW INFO OF PLAYER=======//
		avatarImg = vgui.Create("AvatarImage", invFrame)
		avatarImg:SetPos(20, 40)
		avatarImg:SetSize( 50, 50 )
		avatarImg:SetPlayer( LocalPlayer(), 64 )

		playerName = vgui.Create("DLabel", invFrame)
		playerName:SetPos(90, 50)
		playerName:SetFont("TitleFont")
		playerName:SetSize(200, 30)
		playerName:SetText(LocalPlayer():Nick())

		playerName = vgui.Create("DLabel", invFrame)
		playerName:SetPos(15, 375)
		playerName:SetFont("TitleFont")
		playerName:SetSize(200, 30)
		playerName:SetText("Health:")

		function invFrame:Paint(w, h)
			draw.RoundedBox(2, 0, 0, 800, 600, Color(127, 159, 170))
			draw.RoundedBox(2, 100, 375, 200, 2, Color(255, 255, 255))
			draw.RoundedBox(2, 100, 400, 200, 2, Color(255, 255, 255))
			draw.RoundedBox(2, 100, 375, 2, 25, Color(255, 255, 255))
			draw.RoundedBox(2, 298, 375, 2, 25, Color(255, 255, 255))
			draw.RoundedBox(2, 102, 377, ((LocalPlayer():Health()/100)*196), 23, Color(255, 0, 0))
			draw.DrawText( LocalPlayer():Health(), "TargetID", 120, 379, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
			draw.RoundedBox(2, 0, 0, 800, 2, Color(255, 255, 255))
			draw.RoundedBox(2, 0, 0, 2, 600, Color(255, 255, 255))
			draw.RoundedBox(2, 0, 598, 800, 2, Color(255, 255, 255))
			draw.RoundedBox(2, 798, 0, 2, 600, Color(255, 255, 255))
		end

		local modelPanel = vgui.Create("DModelPanel", invFrame)
		modelPanel:SetPos(10, 60)
		modelPanel:SetSize(300, 300)
		modelPanel:SetModel(LocalPlayer():GetModel())
		function modelPanel:LayoutEntity( Entity ) return end
		modelPanel:SetAnimated(true)
		local dance = modelPanel:GetEntity():LookupSequence( "pose_standing_03" )
		modelPanel:GetEntity():SetSequence(dance)
		local headpos = modelPanel.Entity:GetBonePosition( modelPanel.Entity:LookupBone( "ValveBiped.Bip01_Head1" ) )
		modelPanel:SetCamPos(Vector(headpos[1]+60, headpos[2]-10, 60) )
		

		//=======DRAW INVENTORY SPACES=======//
		local grid = vgui.Create("DGrid", invFrame)
		grid:SetPos(350, 75)
		grid:SetCols(5)
		grid:SetColWide(85)
		grid:SetRowHeight(85)

		for i=1, 30 do
			local invSpace = vgui.Create("DButton")
			local invName = "invSpace_"..i..""
			invSpace:SetText("")
			invSpace:SetSize(75, 75)
			repaintPANEL(invSpace, 68, 87, 101, 100)

			local iconImage = vgui.Create("DImage", invSpace)
			iconImage:SetPos(0, 0)
			iconImage:SetSize(75, 75)
			if (getInvNameByNum(i) ~= "0") then
				iconImage:SetImage(invData[getInvNameByNum(i)].img)
			end

			grid:AddItem(invSpace)
			//HOVER
	    	invSpace.OnCursorEntered = function() 
	    		repaintPANEL(invSpace, 0, 255, 0, 100)
	    		if (getInvNameByNum(i) ~= '0' && optionPanel == nil) then
		    		infoPanel = vgui.Create("DPanel")
		    		infoPanel:SetPos(ScrW()-375, ScrH()-250)
		    		infoPanel:SetSize(325, 75)
		    		infoPanel.Paint = function()
		    			if (getInvNameByNum(i) ~= '0' && infoPanel ~= nil) then
							surface.SetDrawColor( 68, 87, 101, 255)
							surface.DrawRect( 0, 0, infoPanel:GetWide(), infoPanel:GetTall())

							surface.SetTextColor( 255, 255, 255 )
							surface.SetTextPos( 10, 10 )
							surface.SetFont( "TitleFont" )
							surface.DrawText( invData[getInvNameByNum(i)].title )

							surface.SetTextColor( 255, 255, 255 )
							surface.SetTextPos( 10, 40 )
							surface.SetFont( "RegFont" )
							surface.DrawText( invData[getInvNameByNum(i)].desc )
						end
					end
				else
					endInfoPanel()
				end
	    	end
	    	invSpace.OnCursorExited = function() 
	    		repaintPANEL(invSpace, 68, 87, 101, 100)
	    		endInfoPanel()
	    	end

	    	//Click
	    	invSpace.DoClick = function()
	    		if (getInvNameByNum(i) ~= '0') then
	    			if (drawOptionPanel(invFrame, iconImage, i)) then
	    				drawOptionPanel(invFrame, iconImage, i)
	    			end
	    		else
	    			if (optionPanel ~= nil) then 
	    				optionPanel:Remove() 
	    				optionPanel = nil
	    			end
	    			endInfoPanel()
	    		end
	    	end	
		end

	else
		invFrame:Close()
		invFrame = nil
		endInfoPanel()
	end
end	

function drawOptionPanel(invFrame, iconImage, i)
	if (optionPanel == nil) then
		optionPanel = vgui.Create("DPanel", invFrame)
		local cursor_x, cursor_y = invFrame:CursorPos()
		optionPanel:SetPos(cursor_x, cursor_y)
		optionPanel:SetSize(60, 90)

		//USE BUTTON
		local useBTN = vgui.Create("DButton", optionPanel)
		useBTN:SetText("Use")
		useBTN:SetSize(60, 30)
		useBTN:SetPos(0, 0)
		useBTN.DoClick = function()
			optionPanel:Remove()
			optionPanel = nil
			endInfoPanel()
			if (getInvNameByNum(i) ~= "0") then
				if (invData[getInvNameByNum(i)].equipable) then
					if !(ply:HasWeapon(invData[getInvNameByNum(i)].swep)) then
						setInvByNum(i, "0")
					    iconImage:SetSize(0, 0)
					    net.Start("Use_Func")
					    	net.WriteString(getInvNameByNum(i))
					    net.SendToServer()
					else
						ply:ChatPrint("Already Equipped")
					end
				else
					setInvByNum(i, "0")
					iconImage:SetSize(0, 0)
					net.Start("Use_Func")
					   	net.WriteString(getInvNameByNum(i))
					net.SendToServer()
				end
			end
		end

		//DROP BUTTON
		local dropBTN = vgui.Create("DButton", optionPanel)
		dropBTN:SetText("Drop")
		dropBTN:SetSize(60, 30)
		dropBTN:SetPos(0, 30)
		dropBTN.DoClick = function()
			optionPanel:Remove()
			optionPanel = nil
			endInfoPanel()
			if (getInvNameByNum(i) ~= "0") then
			    setInvByNum(i, "0")
			    iconImage:SetSize(0, 0)
		    	net.Start("CreateEnt")
		    		net.WriteString(invData[getInvNameByNum(i)].filename)
		    		net.WriteString(invData[getInvNameByNum(i)].model)
		    	net.SendToServer()
		    end
		end

		//DELETE BUTTON
		local deleteBTN = vgui.Create("DButton", optionPanel)
		deleteBTN:SetText("Delete")
		deleteBTN:SetSize(60, 30)
		deleteBTN:SetPos(0, 60)
		deleteBTN.DoClick = function()
			optionPanel:Remove()
			optionPanel = nil
			endInfoPanel()
			if (getInvNameByNum(i) ~= "0") then
				setInvByNum(i, "0")
		    	iconImage:SetSize(0, 0)
			end
			if (optionPanel ~= nil) then
				optionPanel:Remove()
				optionPanel = nil
			end
		end
		return false
	else
		endInfoPanel()
		optionPanel:Remove()
		optionPanel = nil
		return true
	end

end


//==================INV DATA ACCESSORS========================//

function getInvNameByNum(num)
	local invName = "invSpace_"..num..""
	return LocalPlayer():GetNWString(invName)
end

function setInvByNum(num, value)
	local invName = "invSpace_"..num..""
	net.Start("RecieveUpdate")
		net.WriteInt(num, 16)
		net.WriteString(value)
	net.SendToServer()
end


//==================GMOD FUNCTIONS========================//



// HOOK FUNCTIONS:

function pressedKey()
	plys = player.GetAll()
	if (input.WasKeyPressed(KEY_X)) then
		print("X PRESSED!")
		loadGUI()
	end
	if (input.WasKeyPressed(KEY_V)) then
		print("V PRESSED!!")

	end
end

function playerChatEquip(ply, strText)
	if (ply != LocalPlayer()) then return end
	strText = string.lower(strText)
	heldWeapon = ply:GetActiveWeapon()
	if (strText == "!equip") then
		for k, v in pairs(invData) do
			if (v.equipable) then
				if (heldWeapon:GetClass() == v.swep) then
					for i = 1, 30 do
						local invName = "invSpace_"..i..""
						local value = ply:GetNWString(invName)
						if (value == '0') then
							setInvByNum(i, k)
							net.Start("StripWeapon")
								net.WriteString(v.swep)
							net.SendToServer()
							break
						end
					end
				end
			end
		end
	end
end

hook.Add("OnPlayerChat", "playerchatEquip", playerChatEquip)
hook.Add("Move", "pressedKey", pressedKey)