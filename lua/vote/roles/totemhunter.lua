local Hunter = {  -- table to create new role
	Rolename = "Totemhunter", -- Normal Name
	String = "hunter", -- String Name
	IsGood = false, -- Fights for the good
	IsEvil = true, -- Fights for the bad
	IsSpecial = true, -- Is it special, eg. not innocent
	Creditsforkills = true, -- Gets Credits for kills
	ShortString = "hunter", -- for icons
	Short = "h", -- short for icons, ttt based
	IsDefault = false, -- Is default in TTT, obviously no
	DefaultColor = Color(255,128,0,255), -- Default Color
	DefaultPct = "0.15", -- Role Percentage
	DefaultMax = "1", -- Default Limit
	DefaultMin = "6", -- Default Min Players for Role to be there
	DefaultCredits = "0", -- Default Credits
	IsEvilReplacement = true, -- Is Replacement for one traitor
	HasShop = true,
	ShopFallBack = ROLE_TRAITOR, -- Falls back to normal shop items, eg. all traitor items
	indicator_mat = Material("vgui/ttt/sprite_hunter"), -- Icon above head
	winning_team = WIN_TRAITOR, -- the team it wins with, available are "traitors" and "innocent"
	drawtargetidcircle = true, -- should draw circle
	AllowTeamChat = true, -- team chat
	RepeatingCredits = false,
	DefaultEquip = EQUIP_RADAR,
	CanCollectCredits = true,
    DefaultWeapon = "weapon_ttt_totemknife",
    CustomRadar = function(ply) -- Custom Radar function
		if TTTVote.AnyTotems then
			local targets = {}
	    	local scan_ents = ents.FindByClass("ttt_totem")
	    	for k,t in pairs(scan_ents) do
	    	    local pos = t:LocalToWorld(t:OBBCenter())

	        	pos.x = math.Round(pos.x)
	        	pos.y = math.Round(pos.y)
	        	pos.z = math.Round(pos.z) - 100

	        	local owner = t:GetOwner()
	        	if owner != ply and !owner:IsEvil() then
	          	table.insert(targets, {role= 16, pos=pos})
	        	end
	      	end
			return targets
		else
			return false
		end
end,
}
GAMEMODE:AddNewRole("HUNTER", Hunter)
