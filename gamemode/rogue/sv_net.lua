local function callSpecial(len, ply)
	if ply.rogue.CurrentSpecialEnergy < ply:GetCharacterDetails().SpecialEnergyNeeded then return end
	local char = ply:GetCharacterDetails()
	char.Special(ply)
	ply:SetEnergy(0)
	ply.rogue.SpecialStatus = true
	timer.Simple(char.SpecialDuration, function()
		char.SpecialEnd(ply)
		ply.rogue.SpecialStatus = false
		net.Start("rogue_S2CSpecialStatus")
			net.WriteBool(false)
		net.Send(ply)
	end)
	net.Start("rogue_S2CSpecialStatus")
		net.WriteBool(true)
	net.Send(ply)
end
net.Receive("rogue_ClientRequestSpecial", callSpecial)

local function upgradeWeapon(ply, weapon, type)
	if not weapon.RogueUpgrades[type] then weapon.RogueUpgrades[type] = 1 end
	weapon.RogueUpgrades[type] = weapon.RogueUpgrades[type] + ROGUE.UpgradeAmounts[type]
end
local function handleWeaponUpgrade(len, ply)
	local upgradeType = net.ReadUInt(4)
	local weapon = net.ReadEntity()
	if not weapon.RogueUpgrades then weapon.RogueUpgrades = {} end
	if ROGUE.UpgradeAmounts[upgradeType] then
		upgradeWeapon(ply, weapon, upgradeType)
	end
end
net.Receive("rogue_C2SClientUpgradeWeapon", handleWeaponUpgrade)