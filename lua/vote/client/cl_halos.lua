local function DrawVoteHalos()
  local tbl = {}

  for k,v in pairs(player.GetAll()) do -- probably not a good method but a working one.
    if v:GetNWInt("VoteCounter") >= 3 and v:IsTerror() and !v:GetNoDraw() then
      table.insert(tbl,v)
    end
  end

  halo.Add(tbl,Color(0,255,0),1,1,2,true,true)
end

hook.Add("PreDrawHalos","TTTVoteHalos", DrawVoteHalos)
