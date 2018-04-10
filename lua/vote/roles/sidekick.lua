local Sidekick = {  -- table to create new role
	Rolename = "Sidekick", -- Normal Name
	String = "sidekick", -- String Name
	IsGood = false, -- Fights for the good
	IsEvil = false, -- Fights for the bad
	IsSpecial = true, -- Is it special, eg. not innocent
	Creditsforkills = false, -- Gets Credits for kills
	ShortString = "side", -- for icons
	Short = "si", -- short for icons, ttt based
	IsDefault = false, -- Is default in TTT, obviously no
	DefaultColor = Color(0,175,255,255), -- Default Color
	DefaultPct = "0", -- Role Percentage
	DefaultMax = "0", -- Default Limit
	DefaultMin = "64", -- Default Min Players for Role to be there
	DontSelect = true,
	DefaultCredits = "0", -- Default Credits
	HasShop = false,
	IsGoodReplacement = false, -- Is Replacement for one traitor
	indicator_mat = Material("vgui/ttt/sprite_side"),
	roleBanner = Material("vgui/ttt/sidekick.png"),
	ShopFallBack = false, -- Falls back to normal shop items, eg. all traitor items
	winning_team = WIN_JACKAL, -- the team it wins with, available are "traitors" and "innocent"
	drawtargetidcircle = true, -- should draw circle
	AllowTeamChat = true, -- team chat
	RepeatingCredits = false,
	CanCollectCredits = false,
	HideRole = function(ply)
		return false
	end, -- Hide Role from player
	FakeRole = function(ply)
		return GAMEMODE.LastRole[ply:SteamID()]
	end
}

GAMEMODE:AddNewRole("SIDEKICK", Sidekick)
