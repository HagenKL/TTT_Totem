local votemenu = nil

local function OpenVoteMenu()
  local frame = vgui.Create("DFrame")
  frame:SetSize(500,360)
  frame:Center()
  frame:SetSizable(false)
  frame:SetTitle("")
  frame:SetVisible(true)
  frame:SetDraggable(false)
  frame:SetMouseInputEnabled(true)
  frame:SetScreenLock(true)
  frame:SetDeleteOnClose(true)
  frame:ShowCloseButton(true)
  frame:MakePopup()
  frame:SetKeyboardInputEnabled(false)
  frame.Paint = function(s,w,h)
    draw.RoundedBox(5,0,0,w,h,Color(0,0,0))
    draw.RoundedBox(5,4,4,w-8,h-8,Color(70,70,70))
  end
  local DLabel = vgui.Create("DLabel",frame)
  DLabel:SetPos(frame:GetWide() / 2 - 75 / 2, frame:GetTall() / 2 + 100)
  DLabel:SetText(LocalPlayer():GetCurrentVotes() .. " Votes Übrig." )
  DLabel:SetSize(75,100)
  DLabel:SetTextColor(COLOR_WHITE)

  local DLabel2 = vgui.Create("DLabel",frame)
  DLabel2:SetPos(frame:GetWide() / 2 - 75, frame:GetTall() / 2 - 285)
  DLabel2:SetText( "TTT Vote" )
  DLabel2:SetSize(150,300)
  DLabel2:SetTextColor(Color(255,50,50))
  DLabel2:SetFont("TTTVotefont")

  local ListView = vgui.Create("DListView",frame)
  ListView:SetSize(400,225)
  ListView:SetPos(frame:GetWide() / 2 - 200, frame:GetTall() / 2 - 100 )
  ListView:AddColumn("Spieler")
  ListView:AddColumn("SteamID"):SetFixedWidth(10)
  ListView:SetMultiSelect(false)
  for k,v in pairs(player.GetAll()) do
    if !v:IsBot() and v != LocalPlayer() and !v:GetDetective() then
      ListView:AddLine(v:Nick(),v:SteamID())
    end
  end
  ListView.DoDoubleClick = function(List, lineID,line)
    if LocalPlayer():IsTerror() and GetRoundState() == ROUND_ACTIVE and LocalPlayer():GetNWInt("UsedVotes", 0) <= 0 then
      local nick,steamid = line:GetColumnText(1), line:GetColumnText(2)
      if isstring(steamid) and steamid != "NULL" and steamid != "BOT" then
        local ply = player.GetBySteamID(steamid)
        if ply:GetNWInt("VoteCounter") < 3 then
          net.Start("TTTPlacedVote")
          net.WriteEntity(ply)
          net.SendToServer()
        else
          chat.AddText("TTT Vote: ", COLOR_RED, ply:Nick(), COLOR_WHITE, " ist schon frei zum Abschuss!")
          chat.PlaySound()
        end
      elseif nick == "" or !nick then
        chat.AddText("TTT Vote: ", COLOR_WHITE, "Du hast keinen Spieler ausgewählt.")
        chat.PlaySound()
      end
      frame:Close()
    else
      chat.AddText("TTT Vote: ", COLOR_WHITE, "Du kannst jetzt nicht mehr voten!")
      chat.PlaySound()
      frame:Close()
    end
  end
  votemenu = frame
end

local function LookUpVoteMenu(ply, cmd, args, argStr)
  if !VoteEnabled() then return end
  if votemenu and IsValid(votemenu) then votemenu:Close() return end
  if GetRoundState() == ROUND_ACTIVE and LocalPlayer():IsTerror() then
    if LocalPlayer():GetCurrentVotes() >= 1 then
      if LocalPlayer():GetNWInt("UsedVotes", 0) <= 0 then
        OpenVoteMenu()
      else
        chat.AddText("TTT Vote: ", COLOR_WHITE, "Du hast diese Runde schon gevotet!")
        chat.PlaySound()
      end
    else
      chat.AddText("TTT Vote: ", COLOR_WHITE, "Du hast keine Votes mehr!")
      chat.PlaySound()
    end
  else
    chat.AddText("TTT Vote: ", COLOR_WHITE, "Du bist nicht mehr am leben oder die Runde ist nicht aktiv!")
    chat.PlaySound()
  end
end

local function LookUpTotem(ply, cmd, args, argStr)
  if !TotemEnabled() then return end
  if GetRoundState() != ROUND_WAIT and LocalPlayer():IsTerror() then
    net.Start("TTTVotePlaceTotem")
    net.SendToServer()
  end
end

/*function TTTVote.CloseVoteMenu(ply, cmd, args, argStr)
  if votemenu and IsValid(votemenu) then votemenu:Close() end
end*/

--concommand.Add("+votemenu", TTTVote.LookUpVoteMenu,nil,"Opens the vote menu", { FCVAR_DONTRECORD })
--concommand.Add("-votemenu", TTTVote.CloseVoteMenu,nil,"Closes the vote menu", { FCVAR_DONTRECORD })

concommand.Add("votemenu", LookUpVoteMenu,nil,"Opens / Closes the vote menu", { FCVAR_DONTRECORD })
net.Receive("TTTVoteMenu", LookUpVoteMenu)
concommand.Add("placebeacon", LookUpTotem,nil,"Places a Totem", { FCVAR_DONTRECORD }) -- for backwards compatibility reasons
concommand.Add("placetotem", LookUpTotem,nil,"Places a Totem", { FCVAR_DONTRECORD })
