local _width, _height = ScrW(), ScrH()
local shopFrame

local function buildShopDerma()
	if shopFrame then return end
	local ply = LocalPlayer()

	shopFrame = vgui.Create("DFrame")
	shopFrame:SetSize(300, 500)
	shopFrame:SetTitle("Shop")
	shopFrame:MakePopup()
	shopFrame:Center()

	// RPM (if weapon is automatic)
	local rpmCost = 450
	local rpmButton = vgui.Create("DButton", shopFrame)
	rpmButton:SetSize(80, 40)
	rpmButton:SetEnabled(ply.rogue.Money >= rpmCost)
	local rpmMult = ply:GetActiveWeapon().RpmMult or 1
	rpmButton:SetText("RPM: "..rpmMult.."x")
	rpmButton.DoClick = function()
		if not ply.GetActiveWeapon().RpmMult then ply.GetActiveWeapon().RpmMult = 1 end
		ply.GetActiveWeapon().RpmMult = ply.GetActiveWeapon().RpmMult + 0.25
		net.Start("rogue_C2SClientUpgradeWeapon")
			net.WriteUInt(UPGRADE_RPM, 4)
		net.SendToServer()
	end
end

hook.Add("RogueHook_ShopTriggerTouched", "openShopDerma", buildShopDerma)

concommand.Add("rogue_openbuymenu", buildShopDerma)