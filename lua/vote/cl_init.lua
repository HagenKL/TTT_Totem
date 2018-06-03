if not TTTVote then
	TTTVote = {}

	CreateConVar("ttt_totem","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll TTT Totem aktiviert sein?"):GetBool()
	CreateConVar("ttt_vote","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll TTT Vote aktiviert sein?"):GetBool()
	CreateConVar("ttt_deathgrip","1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll TTT Death Grip aktiviert sein?"):GetBool()

	CreateConVar( "ttt_totem_auto", "1", {FCVAR_ARCHIVE}, "Soll das Totem automatisch plaziert werden?" )

	CreateConVar( "ttt_shinigami_hint", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll der DeathGrip/Shinigami Hinweis (Shinigami icon rechts oben) aktiviert sein?" )
	CreateConVar( "ttt_shinigami_gui", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll die GUI für Shinigami ( Namen in rot unten ) aktiviert sein?" )
	CreateConVar( "ttt_deathgrip_ch_warning", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Soll die DeathGrip Warnung am Crosshair aktiviert sein?" )

	function VoteEnabled() return GetGlobalBool("ttt_vote", false) end

	function TotemEnabled() return GetGlobalBool("ttt_totem", false) end

	function DeathGripEnabled() return GetGlobalBool("ttt_deathgrip", false) end

	-- Clientside bind lib
	include("bind/cl_bind.lua")

	include("vote/client/cl_db.lua")

	include("vote/vgui/AnimatedImage.lua")
	include("vote/client/cl_visuals.lua")
	include("vote/client/cl_changelog.lua")

	net.Receive("ClientInitVote", function()
		SetGlobalBool("ttt_vote", net.ReadBool())
		SetGlobalBool("ttt_deathgrip", net.ReadBool())
		SetGlobalBool("ttt_totem", net.ReadBool())

		if DeathGripEnabled() then
			include("vote/client/cl_deathgrip.lua")
		end
		if TotemEnabled() then
			include("vote/client/cl_totem.lua")
		end
		include("vote/shared/vote_overrides_shd.lua")
		include("vote/shared/player.lua")
		include("vote/client/cl_halos.lua")
		include("vote/client/cl_messages.lua")
		include("vote/client/cl_menu.lua")
	end)

	net.Receive("TTTLoadRoleInit", function()
		local tbl = net.ReadTable()
		if tbl then
			for _, s in ipairs(tbl) do
				include(s)
			end
		end
	end)
end
