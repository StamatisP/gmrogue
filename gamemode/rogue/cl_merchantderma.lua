local _width, _height = ScrW(), ScrH()
local shopFrame

local function buildShopDerma()
	if shopFrame then return end
	local ply = LocalPlayer()
	local weapons = ply:GetWeapons()

	shopFrame = vgui.Create("DFrame")
	shopFrame:SetSize(1600, 900)
	shopFrame:SetTitle("Shop")
	shopFrame:MakePopup()
	shopFrame:Center()
	shopFrame.OnClose = function()
		shopFrame = nil
	end

	local weaponLayout = vgui.Create("DIconLayout", shopFrame)
	weaponLayout:Dock(TOP)
	weaponLayout:DockMargin(25, 25, 25, 0)
	weaponLayout:SetSpaceX(5)
	function weaponLayout:Paint(w, h)
		draw.RoundedBox(8, 0, 0, w, h, Color(255, 0, 0, 255))
	end
	for i=1, #weapons do
		local weaponPanel = vgui.Create("DModelPanel", weaponLayout)
		weaponPanel:SetModel(weapons[i]:GetWeaponViewModel())
		weaponPanel:SetSize(100, 100)
	end

	local weaponUpgradeList = vgui.Create("DPanel", shopFrame)

	// RPM (if weapon is automatic) swep.Primary.Automatic
	local rpmCost = 450
	local rpmButton = vgui.Create("DButton", shopFrame)
	rpmButton:SetSize(80, 40)
	rpmButton:SetEnabled(ply.rogue.Money >= rpmCost)
	local rpmMult = ply:GetActiveWeapon().RpmMult or 1
	rpmButton:SetText("RPM: "..rpmMult.."x")
	rpmButton.DoClick = function()
		local weap = ply:GetActiveWeapon()
		if not weap.RpmMult then weap.RpmMult = 1 end
		ply.rogue.Money = ply.rogue.Money - rpmCost
		rpmButton:SetEnabled(ply.rogue.Money >= rpmCost)
		weap.RpmMult = weap.RpmMult + 0.25
		rpmButton:SetText("RPM: "..weap.RpmMult.."x")
		net.Start("rogue_C2SClientUpgradeWeapon")
			net.WriteUInt(UPGRADE_RPM, 4)
			net.WriteEntity(weap)
		net.SendToServer()
	end
end

hook.Add("RogueHook_ShopTriggerTouched", "openShopDerma", buildShopDerma)

concommand.Add("rogue_openbuymenu", buildShopDerma)