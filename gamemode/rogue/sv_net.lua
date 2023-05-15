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


local function rpmUpgrade(ply)
	if not ply.GetActiveWeapon().RpmMult then ply.GetActiveWeapon().RpmMult = 1 end
	ply.GetActiveWeapon().RpmMult = ply.GetActiveWeapon().RpmMult + 0.25
end
local function reloadUpgrade(ply)
	if not ply.GetActiveWeapon().ReloadMult then ply.GetActiveWeapon().ReloadMult = 1 end
	ply.GetActiveWeapon().ReloadMult = ply.GetActiveWeapon().ReloadMult + 0.25
end
local upgradeTable = {
	[UPGRADE_RPM] = rpmUpgrade,
	[UPGRADE_RELOAD] = reloadUpgrade
}
local function handleWeaponUpgrade(len, ply)
	local upgradeType = net.ReadInt(8)
	if upgradeTable[upgradeType] then upgradeTable[upgradeType](ply) end
end
net.Receive("rogue_C2SClientUpgradeWeapon", handleWeaponUpgrade)