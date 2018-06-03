surface.CreateFont("TTTVotefont", {
    font = "Arial", -- Use the font-name which is shown to you by your operating system Font Viewer, not the file name
    extended = false,
    size = 40,
    outline = true,
    antialias = false
  })


local function InfoBindings()
	local res = DBLoadValue(totem_info_bindings_key)
	if res == "true" then return end
	chat.AddText("TTT Totem: ", COLOR_RED, "Sieh dir die Einstellungen für die Tastenbelegung unter > F1 < an, um Totem spielen zu können. (Dann verschwindet diese Nachricht)")
end


local function PrintCenteredKOSText(txt,delay,color)
  if hook.GetTable()["TTTVoteKOS"] then
    hook.Remove("HUDPaint", "TTTVoteKOS")
    hook.Add("HUDPaint", "TTTVoteKOS", function() draw.SimpleText(txt,"TTTVotefont",ScrW() / 2,ScrH() / 4 ,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) end)
    timer.Adjust("RemoveTTTVoteKOS",delay , 1, function() hook.Remove("HUDPaint", "TTTVoteKOS") hook.Remove("TTTPrepareRound", "TTTRemoveVote") hook.Remove("TTTEndRound", "TTTRemoveVote") end)
  else
    hook.Add("HUDPaint", "TTTVoteKOS", function() draw.SimpleText(txt,"TTTVotefont",ScrW() / 2,ScrH() / 4 ,color,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER) end)
    hook.Add("TTTPrepareRound", "TTTRemoveVote", function() hook.Remove("HUDPaint", "TTTVoteKOS") end)
    hook.Add("TTTEndRound", "TTTRemoveVote", function() hook.Remove("HUDPaint", "TTTVoteKOS") end)
    timer.Create("RemoveTTTVoteKOS",delay , 1, function() hook.Remove("HUDPaint", "TTTVoteKOS") hook.Remove("TTTPrepareRound", "TTTRemoveVote") hook.Remove("TTTEndRound", "TTTRemoveVote") end)
  end
end

net.Receive("TTTVoteMessage",function()
    local sender = net.ReadEntity()
    local target = net.ReadEntity()
    local totalvotes = net.ReadInt(16)
    if totalvotes < 3 then
      chat.AddText("TTT Vote: ", COLOR_GREEN, sender:Nick(), COLOR_WHITE, " votet auf den verdächtigen ", COLOR_RED, target:Nick(), COLOR_WHITE, "! (" .. totalvotes .. "/3)")
    else
      chat.AddText("TTT Vote: ", COLOR_RED, target:Nick(), COLOR_WHITE, " ist nun frei zum Abschuss, da " , COLOR_GREEN, sender:Nick(), COLOR_WHITE, " ihm die letzte Stimme gegeben hat!")
      PrintCenteredKOSText(target:Nick() .. " ist nun frei zum Abschuss!",5,Color( 255, 50, 50 ))
    end
    chat.PlaySound()
  end)

net.Receive("TTTResetVote",function()
    local all = net.ReadBool()
    if all then
      chat.AddText("TTT Vote: ", COLOR_WHITE, "Alle Votes wurden zurückgesetzt!")
    else
      chat.AddText("TTT Vote: ", COLOR_WHITE, "Alle deine Votes wurden von einem Admin zurückgesetzt!")
    end
    chat.PlaySound()
  end)

local function VoteFailure()
  local ply = net.ReadEntity()
  chat.AddText("TTT Vote: ", COLOR_RED, ply:Nick(), COLOR_WHITE, " ist schon frei zum Abschuss!")
  chat.PlaySound()
end

net.Receive("TTTVoteFailure", VoteFailure)

local function TotemMessage()
  local bool = net.ReadInt(8)
  if bool == 1 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Du hast schon ein Totem platziert!")
  elseif bool == 2 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Du musst beim Plazieren deines Totems auf dem Boden stehen!")
  elseif bool == 3 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Dein Totem wurde erfolgreich platziert!")
  elseif bool == 4 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Du hast dein Totem erfolgreich aufgehoben!")
  elseif bool == 5 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Ein Totem wurde zerstört!")
  elseif bool == 6 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Du verlierst nun leben weil du kein Totem platziert hast!")
  elseif bool == 7 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Du hast dein Totem schon 2 mal aufgehoben!")
  elseif bool == 8 then
    chat.AddText("TTT Totem: ", COLOR_WHITE, "Alle Totems wurden zerstört!")
  end
  chat.PlaySound()
end

net.Receive("TTTTotem", TotemMessage)
hook.Add( "TTTPrepareRound", "TTTInfoBindings", InfoBindings)
