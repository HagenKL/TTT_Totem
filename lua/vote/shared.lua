local files, _ = file.Find("vote/roles/*.lua", "LUA")

for _, fil in pairs(files) do
	if SERVER then AddCSLuaFile("vote/roles/" .. fil) end
	include("vote/roles/" .. fil)
end

hook.Add("InitPostEntity", "TTTInsertWeapons", function()
	for k,v in pairs(TTTRoles) do
		if v.ExtraWeapons then
			for j,p in pairs(v.ExtraWeapons) do
				local wep = util.WeaponForClass(p)
				table.insert(wep.CanBuy,v.ID)
			end
		end
	end
end)