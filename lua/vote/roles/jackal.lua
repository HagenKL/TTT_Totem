local Jackal = { -- table to create new role
	Rolename = "Jackal", -- Normal Name
	String = "jackal", -- String Name
	IsGood = false, -- Fights for the good
	IsEvil = false, -- Fights for the bad
	IsSpecial = true, -- Is it special, eg. not innocent
	Creditsforkills = true, -- Gets Credits for kills
	ShortString = "jackal", -- for icons
	Short = "jk", -- short for icons, ttt based
	IsDefault = false, -- Is default in TTT, obviously no
	DefaultColor = Color(0, 255, 255), -- Default Color
	DefaultPct = "0.05", -- Role Percentage
	DefaultMax = "1", -- Default Limit
	DefaultMin = "7", -- Default Min Players for Role to be there
	DefaultCredits = "3", -- Default Credits
	IsGoodReplacement = false, -- Is Replacement for one traitor/detective
	HasShop = true,
	indicator_mat = Material("vgui/ttt/sprite_jackal"),
	ShopFallBack = ROLE_TRAITOR, -- Falls back to normal shop items, eg. all traitor items
	--indicator_mat = Material("vgui/ttt/sprite_jackal"), -- Icon above head
	newteam = true, -- the team it wins with, available are "traitors" and "innocent"
	drawtargetidcircle = true, -- should draw circle
	AllowTeamChat = true, -- team chat
	Description = [[You are the Jackal! Terrorist HQ has given you special resources to kill everybody.
	Use them to be the last survivor, but be careful:
	You are on your own and alone!

	Press {menukey} to receive your equipment!]],
	wintext = "The Jackal has won!",
	teampoints = 1,
	Bonus = 3,
	TeamkillPenalty = -5,
	Killpoints = 4,
	RepeatingCredits = false,
	Chanceperround = 0.5,
	DefaultEquip = EQUIP_ARMOR,
	CanCollectCredits = true,
	ExtraWeapons = {
		"weapon_ttt_sidekickdeagle"
	},
	DeathFunction = function(ply)
		if ply.NOWINASC then return end
		for k,v in pairs(player.GetAll()) do
			if v:IsTerror() and v:GetSidekick() then
				v:SetRole(ROLE_JACKAL)
				SendFullStateUpdate()
				v:SetDefaultCredits()
				break
			end
		end
	end
}
GAMEMODE:AddNewRole("JACKAL", Jackal)
