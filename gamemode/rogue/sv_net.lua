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