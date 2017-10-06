local function SameTeam( ply, ply_o )
    if IsValid( ply ) and IsValid( ply_o ) and ply:IsActive() and ply:IsSpecial() and ply_o:IsSpecial() and ( ( ply.GetTeam and ply:GetTeam() == ply_o:GetTeam() ) or ( ply:GetRole() == ply_o:GetRole() ) ) and ply != ply_o then
        return true
    end
    return false
end

local function GetAliveTeammemberTableDG( ply_o, dg )
    local teammembers = {}
    local players = player.GetAll()
    if not players then return teammembers end
    for _, ply in pairs( players ) do
      if SameTeam(ply, ply_o) then
          if dg then
              if ply != ply_o.DeathGrip then
                  table.insert(teammembers, ply)
              end
          else
              table.insert(teammembers, ply)
          end
      end
    end

    return teammembers
end

local function SendDeathGrip(ply)
  net.Start("TTTDeathGrip")
  net.WriteEntity(ply.DeathGrip)
  net.Send(ply)
end

local function SendDeathGripReset(ply)
  net.Start("TTTDeathGripReset")
  net.Send(ply)
end

local function SendDeathGripMessage()
  net.Start("TTTDeathGripMessage")
  net.Broadcast()
end

local function SendDeathGripInfo()
  net.Start("TTTDeathGripInfo")
  net.Broadcast()
end

local function SendShinigamiInfo(ply)
  local tbl = {}
  for k,v in pairs(player.GetAll()) do
    if v:GetEvil() then
      table.insert(tbl,v:Nick())
    end
  end
  net.Start("TTTShinigamiInfo")
  net.WriteUInt(#tbl,8)
  for k,v in pairs(tbl) do
    net.WriteString(v)
  end
  net.Send(ply)
end

local function SendDeathGripNotification( ply1, ply2 )
    if not GetConVar( "ttt_deathgrip_notification" ):GetBool() then return end

    if ply1:IsSpecial() then
        net.Start( "TTTDeathGripNotification" )
        net.WriteEntity( ply1 )
        net.WriteEntity( ply2 )
        net.WriteBool(SameTeam(ply1, ply2))
        net.Send( GetAliveTeammemberTableDG( ply1, true ) )
    end

    if not SameTeam( ply1, ply2 ) then
        net.Start( "TTTDeathGripNotification" )
        net.WriteEntity( ply2 )
        net.WriteEntity( ply1 )
        net.WriteBool(SameTeam(ply1, ply2))
        net.Send( GetAliveTeammemberTableDG( ply2, true ) )
    end
end

local function SelectDeathGripPlayers()
  if GetConVar( "ttt_shinigami_only" ):GetBool() then
      SendDeathGripInfo()
      return
  end
  timer.Simple(0.1, function()
    local aliveplayers = util.GetAlivePlayers()
    if #aliveplayers > 2 then
      local val = false
      for k,v in pairs(aliveplayers) do
        if v:GetShinigami() then
          v.ShinigamiRespawned = false
          val = true
          table.remove(aliveplayers,k)
          break
        end
      end
      if val then
        local index = math.random(1, #aliveplayers)
        local pick = aliveplayers[index]
        table.remove(aliveplayers, index)

        local index2 = math.random(1, #aliveplayers)
        local pick2 = aliveplayers[index2]
        table.remove(aliveplayers, index2) // Pick two random

        pick.DeathGrip = pick2
        pick2.DeathGrip = pick // assign them to each other

        SendDeathGrip(pick)
        SendDeathGrip(pick2)
        SendDeathGripInfo()

        SendDeathGripNotification( pick, pick2 )
      end
    end
  end)
end

local function DeathGrip(ply, inflictor, attacker)
  if ply.DeathGrip and IsValid(ply.DeathGrip) and ply.DeathGrip:IsTerror() and (attacker:IsPlayer() or inflictor:IsPlayer()) and attacker != ply and inflictor != ply then
    local temp = ply.DeathGrip // prevent infinite loop
    SendDeathGripReset(ply)
    SendDeathGripReset(ply.DeathGrip)
    ply.DeathGrip.DeathGrip = nil
    ply.DeathGrip = nil
    local dmginfo = DamageInfo()
    dmginfo:SetDamage(10000)
    dmginfo:SetAttacker(game.GetWorld())
    dmginfo:SetDamageType(DMG_GENERIC)
    temp:TakeDamageInfo(dmginfo) // kill the other guy
    SendDeathGripMessage()
  elseif ply.DeathGrip and IsValid(ply.DeathGrip) and ply.DeathGrip:IsTerror() and (attacker:IsWorld() or inflictor:IsWorld()) then
      SendDeathGripReset(ply)
      SendDeathGripReset(ply.DeathGrip)
      ply.DeathGrip.DeathGrip = nil
      ply.DeathGrip = nil
  end
  if attacker:IsPlayer() and attacker:GetShinigami() and attacker.ShinigamiRespawned and ply:GetGood() then
    local dmginfo = DamageInfo()
    dmginfo:SetDamage(10000)
    dmginfo:SetAttacker(game.GetWorld())
    dmginfo:SetDamageType(DMG_GENERIC)
    attacker:TakeDamageInfo(dmginfo) // kill the other guy
  end
end

local function FindCorpse(ply) -- From TTT Ulx Commands, sorry
  for _, ent in pairs( ents.FindByClass( "prop_ragdoll" )) do
    if IsValid(ent) and ent.sid == ply:SteamID() then
      return ent or false
    end
  end
end

local function BreakDeathGrip(ply)
  if ply:GetShinigami() and (GetRoundState() == ROUND_ACTIVE or GetRoundState() == ROUND_POST) then
    timer.Simple(0.15, function()
      ply:SetNWBool("body_found", true)
      local corpse = FindCorpse(ply)
      CORPSE.SetFound(corpse, true)
      corpse:Remove()
    end)
    ply.NOWINSHINI = false
    if !ply.ShinigamiRespawned then
      timer.Simple(0.15, function()
        ply:SpawnForRound(true)
        SendShinigamiInfo(ply)
        ply.ShinigamiRespawned = true
        ply.NOWINSHINI = true
        ply.ShiniDamage = 1
        ply:StripWeapons()
        ply:Give("weapon_ttt_shinigamiknife")
        ply:SelectWeapon("weapon_ttt_shinigamiknife")
      end)
      return
    end
  end
  if ply.NOWINASC then return end
  if #util.GetAlivePlayers() < 4 then
    for k,v in pairs(player.GetAll()) do
      v.DeathGrip = nil
      SendDeathGripReset(v)
    end
  end
end

local function ResetDeathGrips()
  for k,v in pairs(player.GetAll()) do
    v.DeathGrip = nil // Reset
    v.ShinigamiRespawned = false
    v.NOWINSHINI = false
  end
end

local function ShinigamiPreventWin()
  for k,v in pairs(player.GetAll()) do
    if v:GetShinigami() and v.NOWINSHINI and !v:IsTerror() then return WIN_NONE end
  end
end

local function PreventShinigamiPickUp(ply, wep)
  if ply:GetShinigami() and ply.ShinigamiRespawned and wep:GetClass() != "weapon_ttt_shinigamiknife" then
    return false
  end
end

local function TTTRemoveDeathGrip(ply)
  if ply.DeathGrip then
    SendDeathGripReset(ply.DeathGrip)
  end
end

local function TTTSetShinigami(ply)
  if ply:GetShinigami() and (GetRoundState() == ROUND_ACTIVE or GetRoundState() == ROUND_POST) then
    if ply.ShinigamiRespawned then
      ply.ShinigamiRespawned = false
      ply.NOWINSHINI = false
    end
    net.Start("TTT_RoleList")
    net.WriteUInt(ROLE_SHINIGAMI,4)
    net.WriteUInt(1,8)
    net.WriteUInt(ply:EntIndex() - 1,7)
    net.Broadcast()
  end
end

local function ShinigamiDamage()
	if GetRoundState() == ROUND_ACTIVE then
		for k,v in pairs(player.GetAll()) do
			if v:IsTerror() and v:IsShinigami() and v.ShinigamiRespawned and v.ShiniDamage <= CurTime() then
				v:TakeDamage(2)
				v.ShiniDamage = CurTime() + 1
			end
		end
	end
end

hook.Add("PlayerSpawn", "TTTSetShinigami", TTTSetShinigami)
hook.Add("PlayerDisconnected", "TTTRemoveDeathGrip", TTTRemoveDeathGrip)
hook.Add("PlayerCanPickupWeapon", "TTTShinigamiPrevent", PreventShinigamiPickUp)
hook.Add("PostPlayerDeath","TTTDeathGrip", BreakDeathGrip)
hook.Add("PlayerDeath", "TTTDeathGrip", DeathGrip)
hook.Add("TTTBeginRound", "TTTDeathGrip", SelectDeathGripPlayers)
hook.Add("TTTPrepareRound", "TTTDeathGrip", ResetDeathGrips)
hook.Add("TTTCheckForWin", "TTTShinigamiWin", ShinigamiPreventWin)
hook.Add("Think", "TTTShinigamiDamage", ShinigamiDamage)
