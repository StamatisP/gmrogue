local function HeadshotExplode(npc, hitgroup, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if not attacker:IsPlayer() then return nil end

	if hitgroup == HITGROUP_HEAD then
		local effectData = EffectData()
		effectData:SetOrigin( npc:GetPos() )
		util.Effect( "Explosion", effectData, true, true)
		util.BlastDamage(attacker, attacker, npc:GetPos(), 6, 10)
	end
end

MODIFIER.Name = "Headshots Explode"
MODIFIER.Hook = "ScaleNPCDamage"
MODIFIER.HookName = "Rogue_HeadshotExplode"
MODIFIER.Function = HeadshotExplode