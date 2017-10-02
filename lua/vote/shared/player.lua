local plymeta = FindMetaTable("Player")

if SERVER then
  function plymeta:SetVotes(votes)
    self:SetNWInt("PlayerVotes", votes)
    util.SetPData(self:SteamID(),"vote_stored", votes )
  end

  function plymeta:AddVotes(votes)
    local v = self:GetNWInt("PlayerVotes",0) + votes
    self:SetNWInt("PlayerVotes", v )
    util.SetPData(self:SteamID(),"vote_stored", v )
  end

  function plymeta:SubtractVotes(votes)
    local v = self:GetNWInt("PlayerVotes",0) - votes
    self:SetNWInt("PlayerVotes", v )
    util.SetPData(self:SteamID(),"vote_stored", v )
  end

  function plymeta:UsedVote()
    local votes = self:GetNWInt("PlayerVotes",0) - 1
    self:SetNWInt("UsedVotes", self:GetNWInt("UsedVotes") + 1 )
    self:SetNWInt("PlayerVotes", votes)
    util.SetPData(self:SteamID(),"vote_stored", votes )
  end

  function plymeta:ResetVotes()
    local votes = GetConVar("ttt_startvotes"):GetInt()
    self:SetNWInt("PlayerVotes", votes)
    util.SetPData(self:SteamID(),"vote_stored", votes )
  end
end

function plymeta:GetVotes()
  return self:GetNWInt("PlayerVotes",0)
end

function plymeta:GetCurrentVotes()
  return self:GetNWInt("PlayerVotes",0) - self:GetNWInt("UsedVotes",0)
end

function plymeta:GetTotem()
  return self:GetNWEntity("Totem", NULL)
end

function plymeta:HasTotem()
  return IsValid(self:GetTotem())
end
