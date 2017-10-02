local changelogmenu = nil

local function OpenChangelogMenu()
  if changelogmenu and IsValid(changelogmenu) then changelogmenu:Close() end

  local html = net.ReadString()
  if isstring(html) and string.len(html) > 0 then
    file.Write("vote/changelog.txt", html)
  else
    html = file.Read("vote/changelog.txt", "DATA")
  end

  local frame = vgui.Create("DFrame")
  local sw,sh = ScrW(), ScrH()
  frame:SetSize(sw / 1.5 , sh / 1.5)
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
    draw.RoundedBox(5,0,0,w,h,Color(250,250,250))
    draw.RoundedBox(5,4,4,w-8,h-8,Color(219, 219, 219))
  end

  local dhtml = vgui.Create("DHTML",frame)

  local fw, fh = frame:GetWide(), frame:GetTall()
  local button = vgui.Create( "DButton", frame )
  button:SetText( "Close" )
  button.DoClick = function() changelogmenu:Close() end
  button:Dock(BOTTOM)
  button:DockMargin(fw/2-50,50,fw/2-50,fh/50)

  dhtml:Dock(FILL)
  dhtml:SetHTML(html)

  changelogmenu = frame

end

net.Receive("VoteChangelog", OpenChangelogMenu)
