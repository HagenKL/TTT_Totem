if SERVER then
  AddCSLuaFile()
  resource.AddFile("models/gamefreak/frenchie/bulkytotem.mdl")
  resource.AddFile("materials/frenchie/bulkytotem/ed3555af.vmt")
  resource.AddFile("materials/frenchie/bulkytotem/a4c3dbeb.vmt")
  resource.AddFile("materials/frenchie/bulkytotem/6348b211.vmt")
end

ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Model = Model("models/gamefreak/frenchie/bulkytotem.mdl")
ENT.CanUseKey = true
ENT.CanPickup = true

function ENT:Initialize()
  self:SetModel(self.Model)

  if SERVER then
    self:PhysicsInit(SOLID_VPHYSICS)
  end

  self:SetMoveType(MOVETYPE_NONE)
  self:SetSolid(SOLID_VPHYSICS)
  self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

  if SERVER then
    self:SetMaxHealth(100)
    self:SetHealth(100)
    self:SetUseType(SIMPLE_USE)
  end

  self:PhysWake()
end

function ENT:UseOverride(activator)
  if IsValid(activator) and activator:IsTerror() and self:GetOwner() == activator and activator.totemuses < 2 then
    activator.CanSpawnTotem = true
    activator.PlacedTotem = false
    activator:SetNWEntity("Totem",NULL)
    if !activator.totemuses then activator.totemuses = 0 end
    activator.totemuses = activator.totemuses + 1
    net.Start("TTTTotem")
    net.WriteInt(4,8)
    net.Send(activator)
    self:Remove()
    timer.Simple(0.01, function() if SERVER then TotemUpdate() end end)
  elseif IsValid(activator) and activator:IsTerror() and self:GetOwner() == activator and activator.totemuses >= 2 then
    net.Start("TTTTotem")
    net.WriteInt(7,8)
    net.Send(activator)
  end
end

local zapsound = Sound("npc/assassin/ball_zap1.wav")
function ENT:OnTakeDamage(dmginfo)
  if GetRoundState() != ROUND_ACTIVE then return end

  local owner, att, infl, dmg = self:GetOwner(), dmginfo:GetAttacker(), dmginfo:GetInflictor(), dmginfo:GetDamage()

  if !IsValid(owner) then return end
  if infl == owner or att == owner or owner:IsEvil() then return end

  if !infl.IsHunter and !att.IsHunter then return end
  if ((infl:IsPlayer() and infl:IsHunter()) or (att:IsPlayer() and att:IsHunter())) and infl:GetClass() == "weapon_ttt_totemknife" then

    if SERVER and owner:IsValid() and att:IsValid() and att:IsPlayer() then
      net.Start("TTTTotem")
      net.WriteInt(5,8)
      net.Broadcast()
    end

    GiveTotemHunterCredits(att,self)

    local effect = EffectData()
    effect:SetOrigin(self:GetPos())
    util.Effect("cball_explode", effect)
    sound.Play(zapsound, self:GetPos())
    self:GetOwner():SetNWEntity("Totem",NULL)
    self:Remove()
    timer.Simple(0.01, function() if SERVER then TotemUpdate() end end)
  end
end

function ENT:FakeDestroy()
  local effect = EffectData()
  effect:SetOrigin(self:GetPos())
  util.Effect("cball_explode", effect)
  sound.Play(zapsound, self:GetPos())
  self:GetOwner():SetNWEntity("Totem",NULL)
  self:Remove()
  timer.Simple(0.01, function() if SERVER then TotemUpdate() end end)
end

hook.Add("PlayerDisconnected", "TTTTotemDestroy", function(ply)
  if IsValid(ply:GetTotem()) then
    ply:GetTotem():FakeDestroy()
  end
end)

if CLIENT then
  hook.Add("HUDDrawTargetID", "DrawTotem", function()
    local client = LocalPlayer()
    local e = client:GetEyeTrace().Entity


    if IsValid(e) and IsValid(e:GetOwner()) and e:GetClass() == "ttt_totem" and (e:GetOwner() == client or (client.IsHunter and client:IsHunter())) then
      local owner = e:GetOwner():Nick()

      if string.EndsWith(owner, "s") or string.EndsWith(owner, "x") or string.EndsWith(owner, "z") or string.EndsWith(owner, "ß") then
        draw.SimpleText(e:GetOwner():Nick() .. "' Totem", "TargetID", ScrW() / 2.0 + 1, ScrH() / 2.0 + 41, COLOR_BLACK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(e:GetOwner():Nick() .. "' Totem", "TargetID", ScrW() / 2.0, ScrH() / 2.0 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      else
        draw.SimpleText(e:GetOwner():Nick() .. "s Totem", "TargetID", ScrW() / 2.0 + 1, ScrH() / 2.0 + 41, COLOR_BLACK, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(e:GetOwner():Nick() .. "s Totem", "TargetID", ScrW() / 2.0, ScrH() / 2.0 + 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
      end
    end
  end)
end
