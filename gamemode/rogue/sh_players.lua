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