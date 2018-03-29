-- Create notification framework
include( "enhancednotificationscore/shared.lua" )

if SERVER then
	init_files_roles = {}
	local files, _ = file.Find("vote/roles/*.lua", "LUA")
	for _, fil in pairs(files) do
		AddCSLuaFile("vote/roles/" .. fil)
		table.insert(init_files_roles, "vote/roles/" .. fil)
	end
	hook.Add("PostGamemodeLoaded", "TTTLoadRoleInit", function()
		if init_files_roles then
			for _, s in ipairs(init_files_roles) do
				include(s)
			end
		end
	end)
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
