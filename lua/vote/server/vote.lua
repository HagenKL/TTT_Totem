-- if !VoteEnabled() then print("TTT Vote is not enabled on this Server, set ttt_vote to 1 to activate!") return end

local function SendVoteNotify(sender, target, totalvotes)
  net.Start("TTTVoteMessage")
  net.WriteEntity(sender)
  net.WriteEntity(target)
  net.WriteInt(totalvotes,16)
  net.Broadcast()
end

local function CalculateVotes(ply, target, sender)
  target:SetNWInt("VoteCounter", target:GetNWInt("VoteCounter") + 1)
  TTTVote.VoteBetters[target:SteamID()] = TTTVote.VoteBetters[target:SteamID()] or {}
  table.insert(TTTVote.VoteBetters[target:SteamID()], ply)
  ply:SetNWInt("UsedVotes", ply:GetNWInt("UsedVotes",0) + 1 )
  if target:GetNWInt("VoteCounter",0) >= 3 then
    target:SetNWInt("VoteCounter", 3)
    for k,v in pairs(TTTVote.VoteBetters[target:SteamID()]) do
      v:UsedVote()
      if target:GetGood() and v:GetGood() then
        v.VotePunishment = true
      end
    end
    table.Empty(TTTVote.VoteBetters[target:SteamID()])
  end
  SendVoteNotify(sender, target, target:GetNWInt("VoteCounter",0))
end

local function ReceiveVotes(len, sender)
  local target = net.ReadEntity()
  if sender:IsTerror() and GetRoundState() == ROUND_ACTIVE and target:GetNWInt("VoteCounter") < 3 and sender:GetCurrentVotes() >= 1 and sender:GetNWInt("UsedVotes",0) <= 0 and not sender.ShinigamiRespawned then
    CalculateVotes(sender, target, sender)
  else
  	net.Start("TTTVoteFailure")
  	net.WriteEntity(target)
  	net.Send(sender)
  end
end

local function ResetVote(ply)
  ply:ResetVotes()
  ply:SetNWInt("VoteCounter",0)
  ply:SetNWInt("UsedVotes", 0)
  ply.VotePunishment = false
  -- if VoteEnabled() then

    local totem = ply:GetNWEntity("Totem")
    if IsValid(totem) then
      totem:FakeDestroy()
    end
    ply.totemuses = 0

    ply:SetNWEntity("Totem",NULL)
    ply.PlacedTotem = false
    ply.CanSpawnTotem = true
    ply.DamageNotified = false
    ply.TotemSuffer = 0
  -- end

  if SERVER and TTTVote.VoteBetters[ply:SteamID()] and istable(TTTVote.VoteBetters[ply:SteamID()]) then
    table.Empty(TTTVote.VoteBetters[ply:SteamID()])
  end
end

local function OpenChangelogMenu(ply)
  net.Start("VoteChangelog")
  net.WriteString(file.Read("vote/changelog.lua", "LUA"))
  net.Send(ply)
end

local function SetVoteDate(ply , date)
  ply:SetPData("vote_stored_date", date)
end

local function InitVoteviaDate(ply, date)
  local currentdate = os.date("%d/%m/%Y",os.time())
  if date != currentdate then
    SetVoteDate(ply , currentdate)
    ResetVote(ply)
    OpenChangelogMenu(ply)
  else
    ply:SetVotes(ply:GetPData("vote_stored"))
  end
end

local function InitVote(ply)
  if IsValid(ply) then
    local currentdate = os.date("%d/%m/%Y",os.time())
    if ply:GetPData("vote_stored_date") == nil then
      SetVoteDate(ply , currentdate)
      ResetVote(ply)
      OpenChangelogMenu(ply)
    end
    InitVoteviaDate(ply, ply:GetPData("vote_stored_date"))
  end
end

function ResetVoteforEveryOne( ply, cmd, args )
  if (!IsValid(ply)) or ply:IsAdmin() or ply:IsSuperAdmin() or cvars.Bool("sv_cheats", 0) then
    for k,v in pairs(player.GetAll()) do
      ResetVote(v)
    end
    TTTVote.AnyTotems = true
    net.Start("TTTResetVote")
    net.WriteBool(true)
    net.Broadcast()
  end
end

local function ResetVoteforOnePlayer(ply, cmd, args)
  if (!IsValid(ply) or ply:IsAdmin() or ply:IsSuperAdmin() or cvars.Bool("sv_cheats", 0)) and args[1] != nil then
    local _match = NULL;
    for k, v in pairs( player.GetAll( ) ) do
      local _find = string.find( string.lower( v:Nick( ) ), string.lower( args[ 1 ] ) ); -- Returns nil if pattern not found, otherwise it returns index or so: [url]http://maurits.tv/data/garrysmod/wiki/wiki.garrysmod.com/index15fa.html[/url]
      if ( !_find ) then
        continue;
      else
        _match = v;
        break;
      end
    end
    local pl = _match
    if IsValid(pl) then
      ResetVote(pl)
      net.Start("TTTResetVote")
      net.WriteBool(false)
      net.Send(pl)
    end
  end
end

local function SaveVote(ply)
  if IsValid(ply) then
    util.SetPData(ply:SteamID(),"vote_stored", ply:GetVotes() )
    ply:SetNWInt("UsedVotes", 0)
    ply:SetNWInt("VoteCounter", 0)
    ply.VotePunishment = false
  end
end

local function SaveVoteAll()
  for k, ply in pairs(player.GetAll()) do
    util.SetPData(ply:SteamID(),"vote_stored", ply:GetVotes() )
    ply:SetNWInt("UsedVotes", 0)
    ply:SetNWInt("VoteCounter", 0)
    ply.VotePunishment = false
  end
end

local function CalculateVoteRoundstart()
  for k,v in pairs(player.GetAll()) do
    v:SetNWInt("VoteCounter", 0)
    v:SetNWInt("UsedVotes",0)
  end
end

local function AutoCompleteVote( cmd, stringargs )

  stringargs = string.Trim( stringargs ) -- Remove any spaces before or after.
  stringargs = string.lower( stringargs )

  local tbl = {}

  for k, v in pairs( player.GetAll() ) do
    local nick = v:Nick()
    if string.find( string.lower( nick ), stringargs ) then
      nick = "\"" .. nick .. "\"" -- We put quotes around it incase players have spaces in their names.
      nick = "ttt_resetvotes " .. nick -- We also need to put the cmd before for it to work properly.

      table.insert( tbl, nick )
    end
  end

  return tbl
end

local function PunishtheInnocents()
  for k,v in pairs(player.GetAll()) do
    if v:IsTerror() and v.VotePunishment then
      v:SetHealth(v:GetMaxHealth() - 30)
      v.VotePunishment = false
    end
  end
end

concommand.Add("ttt_votechangelog", OpenChangelogMenu)
concommand.Add("ttt_resetallvotes", ResetVoteforEveryOne)
concommand.Add("ttt_resetvotes", ResetVoteforOnePlayer, AutoCompleteVote)
hook.Add("PlayerInitialSpawn", "InitialVote", InitVote)
net.Receive("TTTPlacedVote", ReceiveVotes)
hook.Add("PlayerDisconnected","TTTSavevote", SaveVote)
hook.Add("TTTPrepareRound", "ResetVotes", CalculateVoteRoundstart)
hook.Add("TTTBeginRound", "PunishtheInnocents", PunishtheInnocents)
hook.Add("TTTEndRound", "ResetVotes", CalculateVoteRoundstart)
hook.Add("ShutDown", "TTTSaveVotes", SaveVoteAll)
