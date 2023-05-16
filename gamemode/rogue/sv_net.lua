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


local function rpmUpgrade(ply, weapon)
	if not weapon.RpmMult then weapon.RpmMult = 1 end
	weapon.RpmMult = weapon.RpmMult + 0.25
end
local function reloadUpgrade(ply, weapon)
	if not weapon.ReloadMult then weapon.ReloadMult = 1 end
	weapon.ReloadMult = weapon.ReloadMult + 0.25
end
local upgradeTable = {
	[UPGRADE_RPM] = rpmUpgrade,
	[UPGRADE_RELOAD] = reloadUpgrade
}
local function handleWeaponUpgrade(len, ply)
	local upgradeType = net.ReadUInt(4)
	local weapon = net.ReadEntity()
	if upgradeTable[upgradeType] then upgradeTable[upgradeType](ply, weapon) end
end
net.Receive("rogue_C2SClientUpgradeWeapon", handleWeaponUpgrade)