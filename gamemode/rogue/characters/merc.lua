CHARACTER.Name			= "Merc"
CHARACTER.Model			= "models/player/alyx.mdl"
CHARACTER.Health 		= 200
CHARACTER.DamagePercent = 1
CHARACTER.SpeedPercent	= 1
CHARACTER.CritChance 	= 0.05
CHARACTER.CritDamage 	= 2
CHARACTER.SpecialEnergyNeeded = 800
CHARACTER.SpecialDuration = 10

CHARACTER.Special = function(ply)
	print("Special casted")
	ply.rogue.DamagePercent = ply.rogue.DamagePercent + 0.5
end
CHARACTER.SpecialEnd = function(ply)
	print("Special Ended")
	ply.rogue.DamagePercent = ply.rogue.DamagePercent - 0.5
end

CHARACTER.OnDeath = function(ply)
end

CHARACTER.OnInitialize = function(ply)
end