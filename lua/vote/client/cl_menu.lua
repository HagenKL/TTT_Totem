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

local function SettingsTab(dtabs)
	local PANEL = {}

	function PANEL:Init()
		-- set bool
		DBInsertData(totem_info_bindings_key, "true")
	end
	vgui.Register("DTotemSettingsPanelList", PANEL, "DPanelList")

	local dsettings = vgui.Create("DTotemSettingsPanelList", dtabs)
	local padding = dtabs:GetPadding()
	dsettings:StretchToParent(0,0,padding,0)
	dsettings:EnableVerticalScrollbar(true)
	dsettings:SetPadding(10)
	dsettings:SetSpacing(10)

	local dgui = vgui.Create("DForm", dsettings)
	dgui:SetName("Bindings") --TODO Add localization

	-- Totem placement
	local dTPlabel = vgui.Create("DLabel")
	dTPlabel:SetText("Place Totem:")

	local dTPBinder = vgui.Create("DBinder")
	dTPBinder:SetSize( 170, 30 )
	local curBindingT = bind.Find( "placetotem" )
	dTPBinder:SetValue( curBindingT )

	function dTPBinder:OnChange( num )
		if( num == 0 ) then
			bind.Remove( curBindingT, "placetotem" )
		else
			bind.Remove( curBindingT, "placetotem" )
			bind.Add( num, "placetotem", true)
			LocalPlayer():ChatPrint( "New bound key for placing a totem: "..input.GetKeyName( num ) )
		end
		curBindingT = num
	end
	dgui:AddItem(dTPlabel, dTPBinder)

	-- Voting
	local dVlabel = vgui.Create("DLabel")
	dVlabel:SetText("Vote:")

	local dVBinder = vgui.Create("DBinder")
	dVBinder:SetSize( 170, 30 )
	local curBindingV = bind.Find( "votemenu" )
	dVBinder:SetValue( curBindingV )

	function dVBinder:OnChange( num )
		if( num == 0 ) then
			bind.Remove( curBindingV, "votemenu" )
		else
			bind.Remove( curBindingV, "votemenu" )
			bind.Add( num, "votemenu", true)
			LocalPlayer():ChatPrint( "New bound key for voting: "..input.GetKeyName( num ) )
		end
		curBindingV = num
	end
	dgui:AddItem(dVlabel, dVBinder)

	dsettings:AddItem(dgui)

	local dguiT = vgui.Create("DForm", dsettings)
	dguiT:SetName("Totem")

	dguiT:CheckBox( "Automaticially try placing a Totem", "ttt_totem_auto" )
	dguiT:CheckBox( "TTT Enhancements activated? (Equip-HUD)", "ttt_enhancements" )

	dsettings:AddItem(dguiT)

	dtabs:AddSheet("Totem", dsettings, "icon16/wrench.png", false, false, "Totem Settings")
end

-- Register binding functions
bind.Register("placetotem", function() LookUpTotem(nil, nil, nil, nil) end)
bind.Register("votemenu", function() LookUpVoteMenu(nil, nil, nil, nil) end)


concommand.Add("votemenu", LookUpVoteMenu,nil,"Opens / Closes the vote menu", { FCVAR_DONTRECORD })
net.Receive("TTTVoteMenu", LookUpVoteMenu)
concommand.Add("placebeacon", LookUpTotem,nil,"Places a Totem", { FCVAR_DONTRECORD }) -- for backwards compatibility reasons
concommand.Add("placetotem", LookUpTotem,nil,"Places a Totem", { FCVAR_DONTRECORD })
hook.Add("TTTSettingsTabs", "TTTTotemBindings", SettingsTab)
