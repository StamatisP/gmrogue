local metatable = FindMetaTable("Player")
if not metatable then print("Wtf") return end
print("shared players load")

function metatable:GetCharacter()
	return self.rogue.Character
end

function metatable:GetCharacterDetails()
	local char = self:GetCharacter()
	if !ROGUE.Characters[ char ] then return nil end
	
	return ROGUE.Characters[ char ]
end

function metatable:IsModifierActive(modifier)
	return self.rogue.Modifiers[modifier]
end

hook.Add("M_Hook_Mult_RPM", "rpmfunc", function(swep, data)
	local tab = {}
	if not swep.RpmMult then
		print("No RPM Mult!")
		swep.RpmMult = 1
		return 
	end
	tab.mult = swep.RpmMult
	return tab
end)

hook.Add("M_Hook_Mult_ReloadTime", "testreload", function(swep, data)
	local tab = {}
	if not swep.ReloadMult then
		print("No Reload Mult!")
		swep.ReloadMult = 1
		return 
	end
	tab.mult = swep.ReloadMult
	return tab
end)