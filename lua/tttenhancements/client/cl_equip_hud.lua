-- Equip icons or TEXT
hook.Add( "HUDPaint", "TTTEnhancementsEquipHUD", function()
	local ply = LocalPlayer()
	local equipbits = ply:GetEquipmentItems()
	local equipnum = 1
	local count = 0
	local spaces = 5
	local margin = 10
	local size = 30
	surface.SetDrawColor( 255, 255, 255, 255 )
	while (equipbits != 0) do
		if(bit.band(equipbits, 1) == 1) then
			local passive = GetEquipmentItem(ply:GetRole(), equipnum)
			if (not passive) then break end
			if( passive.hud_material ) then
				surface.SetMaterial( Material(passive.hud_material .. ".vmt") )
			else
				surface.SetMaterial( Material(passive.material .. ".vmt") )
			end
			surface.DrawTexturedRect( margin + (size + spaces) * count, ScrH() - 150 - size - margin, size, size )
			count = count + 1
		end
		equipnum = equipnum * 2
		equipbits = bit.rshift(equipbits, 1)
	end
end)
