local function onCharacterChange(len)
	local character = net.ReadString()
	local ply = LocalPlayer()
	ply.rogue = {}
	ply.rogue.Modifiers = {}
	ply.rogue.Character = character
	ply.rogue.CurrentSpecialEnergy = 0
	ply.rogue.Money = 0
end
net.Receive("rogue_CharacterChange", onCharacterChange)

local function onEnergySet(len)
	local energy = net.ReadFloat()
	local ply = LocalPlayer()
	if energy > ply:GetCharacterDetails().SpecialEnergyNeeded then
		energy = ply:GetCharacterDetails().SpecialEnergyNeeded
	end
	ply.rogue.CurrentSpecialEnergy = energy
end
net.Receive("rogue_EnergySet", onEnergySet)

net.Receive("rogue_AttackPhaseStarted", function(len)
	hook.Run("RogueHook_AttackStarted")
end)

net.Receive("rogue_GameStarted", function(len)
	hook.Run("RogueHook_GameStarted")
end)

net.Receive("rogue_WaveCleared", function(len)
	hook.Run("RogueHook_WaveCleared")
end)

net.Receive("rogue_S2CSpecialStatus", function(len)
	local status = net.ReadBool()
	local ply = LocalPlayer()
	ply.rogue.SpecialStatus = status
	ply.rogue.LastCastSpecial = SysTime()
end)

net.Receive("rogue_XPAdded", function(len)
	local amount = net.ReadFloat()
	ROGUE.XP = ROGUE.XP + amount
end)