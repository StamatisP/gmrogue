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
	if not swep.RogueUpgrades then swep.RogueUpgrades = {} end
	if not swep.RogueUpgrades[UPGRADE_RPM] then
		print("No RPM Mult!")
		swep.RogueUpgrades[UPGRADE_RPM] = 1
		return 
	end
	tab.mult = swep.RogueUpgrades[UPGRADE_RPM]
	return tab
end)

hook.Add("M_Hook_Mult_ReloadTime", "testreload", function(swep, data)
	local tab = {}
	if not swep.RogueUpgrades then swep.RogueUpgrades = {} end
	if not swep.RogueUpgrades[UPGRADE_RELOAD] then
		print("No Reload Mult!")
		swep.RogueUpgrades[UPGRADE_RELOAD] = 1
		return 
	end
	tab.mult = swep.RogueUpgrades[UPGRADE_RELOAD]
	return tab
end)