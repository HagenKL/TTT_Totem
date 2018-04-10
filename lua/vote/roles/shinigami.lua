local Shinigami = {  -- table to create new role
	Rolename = "Shinigami", -- Normal Name
	String = "shinigami", -- String Name
	IsGood = true, -- Fights for the good
	IsEvil = false, -- Fights for the bad
	IsSpecial = true, -- Is it special, eg. not innocent
	Creditsforkills = false, -- Gets Credits for kills
	ShortString = "shini", -- for icons
	Short = "s", -- short for icons, ttt based
	IsDefault = false, -- Is default in TTT, obviously no
	DefaultColor = Color(192,192,192,255), -- Default Color
	DefaultPct = "0.15", -- Role Percentage
	DefaultMax = "1", -- Default Limit
	DefaultMin = "4", -- Default Min Players for Role to be there
	DefaultCredits = "0", -- Default Credits
	roleBanner = Material("vgui/ttt/shinigami.png"),
	HasShop = false,
	IsGoodReplacement = false, -- Is Replacement for one traitor
	ShopFallBack = false, -- Falls back to normal shop items, eg. all traitor items
	winning_team = WIN_INNOCENT, -- the team it wins with, available are "traitors" and "innocent"
	drawtargetidcircle = false, -- should draw circle
	AllowTeamChat = false, -- team chat
	RepeatingCredits = false,
	CanCollectCredits = false,
	HideRole = function(ply)
		if ply.ShinigamiRespawned then
			return ROLE_SHINIGAMI
		else
			return ROLE_INNOCENT
		end
	end, -- Hide Role from player
	ShowRole = function(ply)
		return ply.ShinigamiRespawned
	end,
	Chanceperround = 0.66
}
GAMEMODE:AddNewRole("SHINIGAMI", Shinigami)
