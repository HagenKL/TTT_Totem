function vis_DeathGrip_start()
	if(not GetConVar("ttt_totem_vis_deathgrip"):GetBool()) then return end
	local DImgDGS = vgui.Create("DAnimatedImage")
	local size = 600
	local yoffset = 100
	local animyoffset = 50
	DImgDGS:SetSize(size, size)
	DImgDGS:SetPos(ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset - animyoffset)
	DImgDGS:SetAlpha(0)
	DImgDGS:AlphaTo( 255, 0.5 )
	DImgDGS:MoveTo( ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset, 0.5, 0, 2)
	DImgDGS:AlphaTo( 0, 1.3, 0.4, function(tbl, pnl) pnl:Remove() end )
	local mat = Material("vgui/ttt/death_grip_sealing")
	DImgDGS:SetMaterial(mat)
	DImgDGS:SetFrames(8)
	DImgDGS:StartAnim(0.9)
end
--bind.Remove(24, "dgb")
--bind.Register("dgs", vis_DeathGrip_start)
--bind.Add(24, "dgb", false)
function vis_DeathGrip_break()
	if(not GetConVar("ttt_totem_vis_deathgrip"):GetBool()) then return end
	local DImg = vgui.Create("DAnimatedImage")
	local size = 600
	local yoffset = 100
	local animyoffset = 50
	DImg:SetSize(size, size)
	DImg:SetPos(ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset - animyoffset)
	DImg:SetAlpha(0)
	DImg:AlphaTo( 255, 0.5 )
	DImg:MoveTo( ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset, 0.5, 0, 2)
	DImg:AlphaTo( 0, 1, 0.4, function(tbl, pnl) pnl:Remove() end )
	local mat = Material("vgui/ttt/death_grip_break")
	DImg:SetMaterial(mat)
	DImg:SetFrames(8)
	DImg:StartAnim(0.9)
end
--bind.Register("dgb", vis_DeathGrip_break)

function vis_GetRole()
	if(not GetConVar("ttt_totem_vis_role"):GetBool()) then return end
	local ply = LocalPlayer()
	if(not IsValid(ply) or not ply:IsTerror()) then return end

	local banner = ply:GetRoleTable().roleBanner
	if not banner or ply.visrecentrole == ply:GetRole() then
		return
	end
	ply.visrecentrole = ply:GetRole()
	local DImg = vgui.Create("DImage")
	local size = 300
	local yoffset = 80
	local animyoffset = 60
	DImg:SetSize(size, size)
	DImg:SetPos(ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset - animyoffset)
	DImg:SetAlpha(0)
	DImg:AlphaTo( 240, 0.8 )
	DImg:MoveTo( ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset, 0.3, 0, -200)
	DImg:AlphaTo( 0, 1, 2.4, function(tbl, pnl) pnl:Remove() end )
	DImg:SetMaterial(banner)
end

--bind.Register("gr", vis_GetRole)
--bind.Remove(24, "gr")

hook.Add("TTTReceiveRole", "TTTVisualsRoleRecv", vis_GetRole)
hook.Add("TTTBeginRound", "TTTVisualsRoleRecvCleanup", function () LocalPlayer().visrecentrole = nil end)
