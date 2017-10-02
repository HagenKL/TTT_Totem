//GeneralSettings\\
SWEP.Base = "weapon_tttbase"
SWEP.Spawnable = true
SWEP.AutoSpawnable = false
SWEP.HoldType = "pistol"
SWEP.AdminSpawnable = true
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

//Serverside\\
if SERVER then
	AddCSLuaFile( "weapon_ttt_sidekickdeagle.lua" )
end

//Clientside\\
if CLIENT then

	SWEP.PrintName = "Sidekick Deagle"
	SWEP.Slot = 7

	SWEP.ViewModelFOV = 70
	SWEP.ViewModelFlip = false

	SWEP.Icon = "vgui/ttt/icon_deagle"
	SWEP.EquipMenuData = {
		type = "Weapon",
		desc = "Get yourself a Sidekick to help you win!"
	};
end

//Damage\\
SWEP.Primary.Delay = 1
SWEP.Primary.Recoil = 0
SWEP.Primary.Automatic = false
SWEP.Primary.NumShots = 1
SWEP.Primary.Damage = 0
SWEP.Primary.Cone = 0.00001
SWEP.Primary.Ammo = ""
SWEP.Primary.ClipSize = 1
SWEP.Primary.ClipMax = 1
SWEP.Primary.DefaultClip = 1
SWEP.AmmoEnt = ""

//Verschiedenes\\
SWEP.InLoadoutFor = nil
SWEP.AllowDrop = true
SWEP.IsSilent = false
SWEP.NoSights = true
SWEP.UseHands = true
SWEP.HeadshotMultiplier = 1
SWEP.Kind = WEAPON_EQUIP2
SWEP.CanBuy = { }
SWEP.LimitedStock = true

//Sounds/Models\\
SWEP.ViewModel             = "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel            = "models/weapons/w_pist_deagle.mdl"
SWEP.Weight = 5
SWEP.Primary.Sound         = Sound( "Weapon_Deagle.Single" )

local function SendSidekickNotify(owner, ply)
	net.Start("TTT_RoleList")
	net.WriteUInt(ROLE_SIDEKICK , 4)
	net.WriteUInt(1,8)
	net.WriteUInt(ply:EntIndex() - 1, 7)
	net.Send(GetNeutralFilter())
	net.Start("TTT_Role")
	net.WriteUInt(ROLE_SIDEKICK, 4)
	net.Send(ply)
end

function SWEP:OnDrop()
	self:Remove()
end

function SWEP:ShootBullet( dmg, recoil, numbul, cone )

   self:SendWeaponAnim(self.PrimaryAnim)

   self.Owner:MuzzleFlash()
   self.Owner:SetAnimation( PLAYER_ATTACK1 )

   if not IsFirstTimePredicted() then return end

   local sights = self:GetIronsights()

   local bullet = {}
   bullet.Num    = 1
   bullet.Src    = self.Owner:GetShootPos()
   bullet.Dir    = self.Owner:GetAimVector()
   bullet.Spread = Vector( 0.01, 0.01, 0 )
   bullet.Force  = 0
   bullet.Damage = dmg
   if SERVER then
      bullet.Callback = function(atk, tr, dmg)
      	local ent = tr.Entity
      	if ent:IsPlayer() and ent:IsTerror() then
      		ent:SetRole(ROLE_SIDEKICK)
      		SendFullStateUpdate()
      		SendSidekickNotify(atk, ent)
      	end
      end
   end

   self.Owner:FireBullets( bullet )
end

