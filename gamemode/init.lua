AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

hook.Add("EntityTakeDamage", "Rogue_DamageCalc", function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if not target:IsPlayer() and attacker:IsPlayer() then
		dmginfo:ScaleDamage(attacker.rogue.DamagePercent)
	end
end)