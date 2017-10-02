local bg = Color(0, 0, 10, 200)
local margin = 275

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
  LocalPlayer().DeathGrip = ply // set buddy
  hook.Add("HUDPaint", "DeathGripHUD", DeathGripHUD)
end

local function ResetDeathGrip()
  LocalPlayer().DeathGrip = nil // Reset
  hook.Remove("HUDPaint", "DeathGripHUD")
end

local function DeathGripMessage()
  chat.AddText("TTT Death Grip: ", COLOR_WHITE, "The Death Grip got broken, two players are dead!")
  chat.PlaySound()
end

local function ShinigamiInfo()
  local num = net.ReadUInt(8)
  local str = {"A dark voice whispers: ", COLOR_WHITE, "The Traitors are ",}
  for i=1, num do
    table.insert(str, COLOR_RED)
    table.insert(str, net.ReadString())
    table.insert(str, COLOR_WHITE)
    table.insert(str, ", ")
  end
  table.insert(str, COLOR_WHITE)
  table.insert(str, "get them!")

  chat.AddText(unpack(str))
  chat.PlaySound()
end

local function DeathGripInfo()
  chat.AddText("A dark voice whispers: ", COLOR_WHITE, "The Shinigami is here, waiting...")
  chat.PlaySound()
end

hook.Add("TTTPrepareRound", "TTTDeathGrip", ResetDeathGrip)
net.Receive("TTTDeathGrip", DeathGripCL)
net.Receive("TTTDeathGripReset", ResetDeathGrip)
net.Receive("TTTDeathGripMessage", DeathGripMessage)
net.Receive("TTTShinigamiInfo", ShinigamiInfo)
net.Receive("TTTDeathGripInfo", DeathGripInfo)
