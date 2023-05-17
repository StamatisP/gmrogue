local _width, _height = ScrW(), ScrH()
local shopFrame
local weaponUpgradeList
local upgradeCosts = {
	[UPGRADE_RPM] = 450,
	[UPGRADE_RELOAD] = 300
}

local UpgradeButton = {}
function UpgradeButton:SetupUpgrade(upgradeType, weapon)
	self.ply = LocalPlayer()
	self.cost = upgradeCosts[upgradeType]
	self.upgradeType = upgradeType
	self.weapon = weapon
	if not self.weapon.RogueUpgrades then self.weapon.RogueUpgrades = {} end
	self:SetEnabled(self.ply.rogue.Money >= self.cost)
	self:TextUpdate()
end
function UpgradeButton:TextUpdate()
	local multString, multAmount
	local upgradeTable = self.weapon.RogueUpgrades
	if self.upgradeType == UPGRADE_RPM then
		multString = "RPM"
	elseif self.upgradeType == UPGRADE_RELOAD then
		multString = "Reload"
	end
	multAmount = upgradeTable[self.upgradeType]
	self:SetText(string.format("%s: %Gx\n$%s", multString, multAmount, self.cost))
end
function UpgradeButton:DoClick()
	self.ply.rogue.Money = self.ply.rogue.Money - self.cost
	self:SetEnabled(self.ply.rogue.Money >= self.cost)
	local upgradeTable = self.weapon.RogueUpgrades
	if not upgradeTable[self.upgradeType] then upgradeTable[self.upgradeType] = 1 end
	
	upgradeTable[self.upgradeType] = upgradeTable[self.upgradeType] + ROGUE.UpgradeAmounts[self.upgradeType]
	self:TextUpdate()
	
	net.Start("rogue_C2SClientUpgradeWeapon")
		net.WriteUInt(self.upgradeType, 4)
		net.WriteEntity(self.weapon)
	net.SendToServer()
end
vgui.Register("UpgradeButton", UpgradeButton, "DButton")

local function buildWeaponUpgradeList(weapon)
	if weaponUpgradeList then weaponUpgradeList = nil end
	local function _createButton(upgradeType)
		local button = vgui.Create("UpgradeButton", weaponUpgradeList)
		button:SetupUpgrade(upgradeType, weapon)
		button:SetSize(100, 100)
	end
	weaponUpgradeList = vgui.Create("DIconLayout", shopFrame)
	weaponUpgradeList:Dock(FILL)
	weaponUpgradeList:DockMargin(0, 25, 0, 0)
	weaponUpgradeList:SetSpaceY(25)
	if weapon.Primary.Automatic then
		_createButton(UPGRADE_RPM)
		_createButton(UPGRADE_RELOAD)
	end
end

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
		weaponPanel.DoClick = function()
			buildWeaponUpgradeList(weapons[i])
		end
	end
end

hook.Add("RogueHook_ShopTriggerTouched", "openShopDerma", buildShopDerma)

concommand.Add("rogue_openbuymenu", buildShopDerma)