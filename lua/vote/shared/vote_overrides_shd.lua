if SERVER then

	local function GetVoteMessage(sender, text, teamchat) -- for backwards compatibility reasons
		local msg = string.lower(text)
		if string.sub(msg,1,8) == "!prozent" and VoteEnabled() then
			net.Start("TTTVoteMenu")
			net.Send(sender)
			return false
		elseif string.sub(msg,1,11) == "!votebeacon" and GetRoundState() != ROUND_WAIT and sender:IsTerror() and TotemEnabled() then
			PlaceTotem(nil, sender)
			return false
		end
	end

	local function AdjustSpeed(ply)
		if ply:GetShinigami() and ply.ShinigamiRespawned then return 2.5 end
		if TotemEnabled() and (GetRoundState() == ROUND_ACTIVE or GetRoundState() == ROUND_POST) and TTTVote.AnyTotems then
			local Totem = ply:GetTotem()
			if IsValid(Totem) then
				local distance = Totem:GetPos():Distance(ply:GetPos())
				if distance >= 2500 then
					return math.Round(math.Remap(distance,2500,5000,1,0.75),2)
				elseif distance <= 1000 then
					return 1.25
				elseif distance > 1000 and distance < 2500 then
					return 1
				end
			else
				return 0.75
			end
		end
		return 1
	end

	local function SpeedOverride() --Overriding functions that dont have hooks to modify

		local plymeta = FindMetaTable("Player")
		function plymeta:SetSpeed(slowed)
			local mul = hook.Call("TTTPlayerSpeed", GAMEMODE, self, slowed) or AdjustSpeed(self)

			-- if mul >= 1 and hook.Call("TTTPlayerSpeed", GAMEMODE, self, slowed) then
			-- 	mul = hook.Call("TTTPlayerSpeed", GAMEMODE, self, slowed)
			-- elseif mul < 1 and hook.Call("TTTPlayerSpeed", GAMEMODE, self, slowed) then
			-- 	mul = math.min(mul, hook.Call("TTTPlayerSpeed", GAMEMODE, self, slowed),100)
			-- end

			if slowed then
				self:SetWalkSpeed(120 * mul)
				self:SetRunSpeed(120 * mul)
				self:SetMaxSpeed(120 * mul)
			else
				self:SetWalkSpeed(220 * mul)
				self:SetRunSpeed(220 * mul)
				self:SetMaxSpeed(220 * mul)
			end
		end
	end

	hook.Add("Initialize", "TTTOverrideSpeedFunction", SpeedOverride)
	hook.Add("PlayerSay","TTTVote", GetVoteMessage)
else
	local function VoteMakeCounter(pnl)
		pnl:AddColumn("Votes", function(ply)
			if ply:GetNWInt("VoteCounter",0) < 3 then
				return ply:GetNWInt("VoteCounter",0)
			elseif ply:GetNWInt("VoteCounter",0) >= 3 then
				return 3
			end
		end)
	end

	local function MakeVoteScoreBoardColor(ply)
		if ply:GetNWInt("VoteCounter",0) >= 3 then
			return Color(0,120,0)
		end
	end
	if VoteEnabled() then
		hook.Add("TTTScoreboardRowColorForPlayer", "TTTVoteColorScoreboard", MakeVoteScoreBoardColor)
		hook.Add("TTTScoreboardColumns", "TTTVoteCounteronScoreboard", VoteMakeCounter)
	end
end
