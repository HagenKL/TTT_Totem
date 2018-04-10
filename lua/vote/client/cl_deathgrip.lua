local bg = Color(0, 0, 10, 200)
local margin = 275

local DPanelGH = nil
local DPanelEG = nil

local health_colors = {
   border = COLOR_WHITE,
   background = Color(20, 20, 5, 222),
   fill = Color(205, 155, 0, 255)
};

local Tex_Corner8 = surface.GetTextureID( "gui/corner8" )
local function RoundedMeter( bs, x, y, w, h, color)
   surface.SetDrawColor(clr(color))

   surface.DrawRect( x+bs, y, w-bs*2, h )
   surface.DrawRect( x, y+bs, bs, h-bs*2 )

   surface.SetTexture( Tex_Corner8 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + bs/2, bs, bs, 0 )
   surface.DrawTexturedRectRotated( x + bs/2 , y + h -bs/2, bs, bs, 90 )

   if w > 14 then
      surface.DrawRect( x+w-bs, y+bs, bs, h-bs*2 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + bs/2, bs, bs, 270 )
      surface.DrawTexturedRectRotated( x + w - bs/2 , y + h - bs/2, bs, bs, 180 )
   else
      surface.DrawRect( x + math.max(w-bs, bs), y, bs/2, h )
   end

end

---- The bar painting is loosely based on:
---- http://wiki.garrysmod.com/?title=Creating_a_HUD

-- Paints a graphical meter bar
local function PaintBar(x, y, w, h, colors)
   -- Background
   -- slightly enlarged to make a subtle border
   draw.RoundedBox(8, x-1, y-1, w+2, h+2, colors.background)

   -- Fill
  RoundedMeter(8, x, y, w, h, colors.fill)
end

local function DeathGripHUD() // similar to TTT Code

  local client = LocalPlayer()

  if !client.DeathGrip or !IsValid(client.DeathGrip) then return end

  local width = 250
  local height = 90

  local x = margin
  local y = ScrH() - height - 10

  draw.RoundedBox(8, x, y, width, height, bg)
  draw.RoundedBox(8, x, y, 170, 30, Color(255,0,255))

  PaintBar(x + 10, y + 45, width - (10*2), 25, health_colors)

  x = x + 80
  draw.SimpleText("Death Grip", "TraitorState", x+2, y+16, COLOR_BLACK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
  draw.SimpleText("Death Grip", "TraitorState", x, y+14, COLOR_WHITE, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

  local str = client.DeathGrip:Nick()

  if surface.GetTextSize(str) > 250 then
    draw.SimpleText(string.sub(str,1,12) .. "...", "HealthAmmo", x-58, y+46, COLOR_BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    draw.SimpleText(string.sub(str,1,12) .. "...", "HealthAmmo", x-60, y+44, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
  else
    draw.SimpleText(str, "HealthAmmo", x-58, y+46, COLOR_BLACK, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
    draw.SimpleText(str, "HealthAmmo", x-60, y+44, COLOR_WHITE, TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT)
  end
end

local function DeathGripCL()
  local ply = net.ReadEntity()
  LocalPlayer().DeathGrip = ply -- set buddy
  hook.Add("HUDPaint", "DeathGripHUD", DeathGripHUD)
end

local function ClearEG()
    if DPanelEG and IsValid(DPanelEG) then
      DPanelEG:Remove()
    end
end

local function ResetDeathGrip()
  LocalPlayer().DeathGrip = nil // Reset
  if LocalPlayer().TeammatesDG then LocalPlayer().TeammatesDG = nil end
  if DPanelGH and IsValid( DPanelGH ) then
    DPanelGH:Remove()
  end
  hook.Remove("HUDPaint", "DeathGripHUD")
end

local function DeathGripMessage()
  chat.AddText("TTT Death Grip: ", COLOR_WHITE, "The Death Grip got broken, two players are dead!")
  chat.PlaySound()
end

local function ShinigamiGui( EvilTbl )
    if not GetConVar( "ttt_shinigami_gui" ):GetBool() then return end
    if not EvilTbl then return end

    --todo: add row / column system
    local lineHeight = 25
    local lineWidth = 300
    local margin = 5

    ClearEG()

    DPanelEG = vgui.Create( "DPanel" )
    local panelHeight = (lineHeight + margin) * #EvilTbl
    local panelWidth = lineWidth
    local panelPosX = ( ScrW() / 2 ) - ( panelWidth / 2 )
    local panelPosY = ScrH() - panelHeight - 95

    DPanelEG:SetPos( panelPosX, ScrH() ) -- Set the position of the panel
    DPanelEG:SetSize( panelWidth, panelHeight ) -- Set the size of the panel
    DPanelEG:SetBackgroundColor( Color( 0, 0, 0, 0 ) )
	DPanelEG:AlphaTo (255, 0.4)
	DPanelEG:MoveTo (panelPosX, panelPosY, 0.5)

    -- Create Labels
    for i, ply in pairs( EvilTbl ) do
        local pan = vgui.Create( "DPanel", DPanelEG )
        pan:SetPos( 0, ( lineHeight + margin ) * (i - 1) )
        pan:SetSize( panelWidth, lineHeight )
        pan:SetBackgroundColor( Color( 255, 0, 0, 170 ) )

        local lblPlayerNick = vgui.Create( "DLabel", pan )
        lblPlayerNick:SetText( ply )
        lblPlayerNick:SetTextColor( Color( 255, 250, 250 ) )
        lblPlayerNick:SetFont( "Trebuchet24" )
        lblPlayerNick:Dock( FILL )
        lblPlayerNick:SetContentAlignment( 5 )
    end
end

local function ShinigamiInfo()
  timer.Simple( 1, function() gamemode.Call( "HUDClear" ) end )

  local num = net.ReadUInt(8)
  local str = {"A dark voice whispers: ", COLOR_WHITE, "The Traitors are ",}
  local EvilTbl = {}
  for i=1, num do
    local tmp = net.ReadString()
    table.insert( EvilTbl, tmp )
    table.insert(str, COLOR_RED)
    table.insert(str, tmp)
    table.insert(str, COLOR_WHITE)
    table.insert(str, ", ")
  end
  table.insert(str, COLOR_WHITE)
  table.insert(str, "get them!")

  chat.AddText(unpack(str))
  chat.PlaySound()

  -- Shinigami GUI
  ShinigamiGui( EvilTbl )

end

local function DeathGripInfo()
  chat.AddText("A dark voice whispers: ", COLOR_WHITE, "The Shinigami is here, waiting...")
  chat.PlaySound()

  if GetConVar( "ttt_shinigami_hint" ):GetBool() then
      -- Shinigami GUI hint
      if DPanelGH and IsValid( DPanelGH ) then
        DPanelGH:Remove()
      end

      DPanelGH = vgui.Create( "DPanel" )
      DPanelGH:SetPos( ScrW() - 76, ScrH() / 4 )
      DPanelGH:SetSize( 66, 66 )
      DPanelGH:SetBackgroundColor( Color( 255, 255, 255, 150) )

      local icon = vgui.Create( "DImage", DPanelGH )
      icon:SetPos( 1, 1 )
      icon:SetSize( 64, 64 )
      icon:SetImage( "vgui/ttt/icon_shini" )
  end
end

local function DeathGripCHInfo()
  if not GetConVar( "ttt_deathgrip_ch_warning" ):GetBool() then return end
  local client = LocalPlayer()
  --local SafeTranslate = LANG.TryTranslation

  local trace = client:GetEyeTrace(MASK_SHOT)
  local ent = trace.Entity
  if (not IsValid(ent)) or ent.NoTarget then return end

  local text = "WARNING: ACTIVE DEATHGRIP"
  local color = Color( 255, 0, 255, 255 )
  local x = ScrW() / 2.0
  local y = ScrH() / 2.0
  surface.SetFont( "TargetID" )
  local w, h = surface.GetTextSize( text )
  x = x - w / 2
  y = y - 50

  if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
    ent = ent:GetNWEntity("ttt_driver", nil)
    if ent == client then return end
  end

  if ent:IsPlayer() then
    if not ent:GetNWBool("disguised", false) and ( client.DeathGrip == ent or client.TeammatesDG == ent ) then
      draw.SimpleText( text, "TargetID", x+1, y+1, COLOR_BLACK )
      draw.SimpleText( text, "TargetID", x, y, color )
    end
  end

end

local function ShinigamiTraitorInfo()
	local client = LocalPlayer()

	if (not client:IsShinigami()) then
		return
	end

	local trace = client:GetEyeTrace(MASK_SHOT)
    local ent = trace.Entity
    if (not IsValid(ent)) or ent.NoTarget then return end

    local text = "KILL!!!"
    local color = Color( 255, 0, 0, 255 )
    local x = ScrW() / 2.0
    local y = ScrH() / 2.0
    surface.SetFont( "TargetID" )
    local w, h = surface.GetTextSize( text )
    x = x - w / 2
    y = y - 50

    if IsValid(ent:GetNWEntity("ttt_driver", nil)) then
      ent = ent:GetNWEntity("ttt_driver", nil)
      if ent == client then return end
    end

    if ent:IsPlayer() then
      if not ent:GetNWBool("disguised", false) and ent:IsEvil() then
        draw.SimpleText( text, "TargetID", x+1, y+1, COLOR_BLACK )
        draw.SimpleText( text, "TargetID", x, y, color )
      end
    end
end

local function DeathGripNotification()
    -- Read sent information
    local ply = net.ReadEntity()
    local dgply = net.ReadEntity()
    local sameteam = net.ReadBool()
    local bgColor = Color( 240, 40, 140, 240 )
    ENHANCED_NOTIFICATIONS:NewNotification({title=ply:Nick(),subtext="in DeathGrip with " .. dgply:Nick(),color=bgColor,lifetime=20})
    if not sameteam then LocalPlayer().TeammatesDG = dgply end
end

hook.Add( "HUDDrawTargetID", "TA_DG_INFO", DeathGripCHInfo )
hook.Add( "HUDDrawTargetID", "TA_SHINI_TRAITOR", ShinigamiTraitorInfo )
hook.Add("TTTPrepareRound", "TTTDeathGrip", ResetDeathGrip)
hook.Add( "TTTPrepareRound", "TTTShinigamiGUICleanUp", ClearEG )
hook.Add( "TTTEndRound", "TTTShinigamiGUICleanUp", ClearEG )
net.Receive("TTTDeathGrip", DeathGripCL)
net.Receive("TTTDeathGripReset", ResetDeathGrip)
net.Receive("TTTDeathGripMessage", DeathGripMessage)
net.Receive("TTTShinigamiInfo", ShinigamiInfo)
net.Receive("TTTDeathGripInfo", DeathGripInfo)
net.Receive( "TTTDeathGripNotification", DeathGripNotification )
