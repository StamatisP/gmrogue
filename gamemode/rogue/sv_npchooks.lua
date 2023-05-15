local function rewardNpcKill(npc, attacker, inflictor)
	net.Start("rogue_XPAdded")
		net.WriteFloat(100)
	net.Broadcast()
	for k, v in ipairs(player.GetHumans()) do
		v:AddMoney(100)
	end
end
hook.Add( "OnNPCKilled", "rogue_RewardNPCKill", rewardNpcKill)

local function rewardNpcDamage(npc, hitgroup, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if not attacker:IsPlayer() then return nil end
	if attacker.rogue.SpecialStatus then return nil end
	attacker:SetEnergy(attacker.rogue.CurrentSpecialEnergy + dmginfo:GetDamage())
end
hook.Add("ScaleNPCDamage", "rogue_RewardNPCDamage", rewardNpcDamage)

concommand.Add("rogue_spawnnpc", function(ply, cmd, args)
	local ent = ents.Create("basic_npc")
	if not IsValid(ent) then return nil end

	local trace = ply:GetEyeTrace()
	ent:SetPos(trace.HitPos)
	ent:Spawn()
	ent:Give("weapon_vj_smg1")
end)