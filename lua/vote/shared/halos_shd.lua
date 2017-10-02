if SERVER then
  function TTTVote.RemoveHalos(ply)
    if ply:GetNWInt("VoteCounter",0) >= 3 then
      net.Start("TTTVoteRemoveHalos")
      net.WriteEntity(ply)
      net.Broadcast()
    end
  end

  function TTTVote.AddHalos(ply)
    if ply:GetNWInt("VoteCounter",0) >= 3 and ply:IsTerror() then
      net.Start("TTTVoteAddHalos")
      net.WriteEntity(ply)
      net.Broadcast()
    end
  end
  hook.Add("PlayerDeath", "TTTVoteRemoveHalos", TTTVote.RemoveHalos)
  hook.Add("PlayerSpawn", "TTTVoteAddHalos", TTTVote.AddHalos)
elseif CLIENT then
  TTTVote.halos = TTTVote.halos or {}

  function TTTVote.DrawVoteHalos()
    halo.Add(TTTVote.halos,Color(0,255,0),1,1,2,true,true)
  end

  function TTTVote.ClientRemoveHalos()
    local ent = net.ReadEntity()
    table.RemoveByValue(TTTVote.halos,ent)
  end

  function TTTVote.ClientAddHalos()
    local ent = net.ReadEntity()
    table.insert(TTTVote.halos,ent)
  end

  function TTTVote.RemoveAllHalos()
    table.Empty(TTTVote.halos)
  end

  net.Receive("TTTVoteRemoveAllHalos", TTTVote.RemoveAllHalos)
  net.Receive("TTTVoteRemoveHalos",TTTVote.ClientRemoveHalos)
  net.Receive("TTTVoteAddHalos",TTTVote.ClientAddHalos)
  hook.Add("TTTPrepareRound","TTTVoteReset", TTTVote.RemoveAllHalos)
  hook.Add("PreDrawHalos","TTTVoteHalos", TTTVote.DrawVoteHalos)
end
