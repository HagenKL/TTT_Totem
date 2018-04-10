local function PlaceTotem()
	if not GetConVar( "ttt_totem_auto" ):GetBool() then return end
	LocalPlayer():ConCommand("placetotem")
end

hook.Add("TTTBeginRound", "TTTTotemAutomaticPlacement", PlaceTotem)
