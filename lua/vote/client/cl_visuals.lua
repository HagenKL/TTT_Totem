function vis_DeathGrip_start()
	local DImgDGS = vgui.Create("DImage")
	local size = 200
	local yoffset = 100
	local animyoffset = 100
	DImgDGS:SetSize(size, size)
	DImgDGS:SetPos(ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset - animyoffset)
	DImgDGS:SetImage("vgui/ttt/dg_start", "vgui/avatar_default") --TODO ANIMATION
	DImgDGS:AlphaTo( 255, 1 )
	--DImgDGS:SizeTo( 25, 25, 2, 1 )
	--DImgDGS:MoveTo( 10, ScrH() - 10, 2, 1, 2, function(tbl, pnl) pnl:Remove() end)
	DImgDGS:MoveTo( ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset, 1, 0, 2)
	DImgDGS:AlphaTo( 0, 1, 5, function(tbl, pnl) pnl:Remove() end )
end
--bind.Remove(24, "dgs")
bind.Register("dgs", vis_DeathGrip_start)
--bind.Add(24, "dgb", false)
function vis_DeathGrip_break()
	local DImg = vgui.Create("DImage")
	local size = 400
	local yoffset = 100
	local animyoffset = 50
	DImg:SetSize(size, size)
	DImg:SetPos(ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset - animyoffset)
	DImg:SetAlpha(0)
	DImg:AlphaTo( 255, 0.5 )
	--DImg:SizeTo( 25, 25, 2, 1 )
	--DImg:MoveTo( 10, ScrH() - 10, 2, 1, 2, function(tbl, pnl) pnl:Remove() end)
	DImg:MoveTo( ScrW()/2 - size/2, ScrH()/2 - size/2 - yoffset, 0.5, 0, 2)
	DImg:AlphaTo( 0, 0.5, 0.4, function(tbl, pnl) pnl:Remove() end )
	local mat = Material("vgui/ttt/death_grip_break")
	if mat then
		mat:SetInt("$frame", 0)
		mat:Recompute()
		DImg:SetMaterial(mat)
	end

end
bind.Register("dgb", vis_DeathGrip_break)
