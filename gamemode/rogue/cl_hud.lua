local _width = ScrW()
local _height = ScrH()
local initPost = initPost or false
local ply = ply or LocalPlayer()
local chara = chara or nil
if not chara and initPost then
	chara = ply:GetCharacterDetails()
end

hook.Add("InitPostEntity", "SetupHud", function()
	initPost = true
	timer.Create("UpdateChara", 1, 0, function ()
		if chara then
			timer.Remove("UpdateChara")
		else
			ply = LocalPlayer()
			chara = ply:GetCharacterDetails()
		end
	end)
end)

// ty maurits
local function lerpColor(frac,from,to)
	local col = Color(
		Lerp(frac,from.r,to.r),
		Lerp(frac,from.g,to.g),
		Lerp(frac,from.b,to.b),
		Lerp(frac,from.a,to.a)
	)
	return col
end

local fullEnergyColor = Color(42, 232, 93, 255)
local emptyEnergyColor = Color(232, 55, 42, 255)
local function drawEnergyBar()
	local w, h = 300, 30
	local x, y = _width / 2 - (w / 2), _height * 0.85
	surface.SetDrawColor(0, 0, 0, 128)
	surface.DrawRect(x, y, w, h)
	local width = ply.rogue.CurrentSpecialEnergy / chara.SpecialEnergyNeeded
	if ply.rogue.SpecialStatus then
		local animDuration = ply:GetCharacterDetails().SpecialDuration
		local specialEnd = ply.rogue.LastCastSpecial + animDuration
		width = Lerp((specialEnd - SysTime()) / animDuration, 0, 1)
	end
	surface.SetDrawColor(lerpColor(width, emptyEnergyColor, fullEnergyColor))
	surface.DrawRect(x, y, width * w, h)
end

local function drawXPBar()
	local x, y = _width / 2 - 100, _height * 0.9
	surface.SetFont("DermaLarge")
	surface.SetDrawColor(0, 0, 0, 128)
	surface.DrawRect(x + 50, y, 100, 30)
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(x + 75, y)
	surface.DrawText(ply.rogue.XP)
end

local function drawMoneyBar()
	local x, y = _width / 2 - 100, _height * 0.95
	surface.SetFont("DermaLarge")
	surface.SetDrawColor(0, 0, 0, 128)
	surface.DrawRect(x + 50, y, 100, 30)
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(x + 75, y)
	surface.DrawText("$"..ply.rogue.Money)
end

local function drawHud()
	if not ply then ply = LocalPlayer() end
	if not chara or not ply.rogue then return end
	drawEnergyBar()
	drawXPBar()
	drawMoneyBar()
end
hook.Add("HUDPaint", "HudPaint_SpecialEnergyBar", drawHud)