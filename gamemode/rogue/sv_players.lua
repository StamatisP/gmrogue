function GM:PlayerInitialSpawn( ply )
	ply:Initialize()
	ply:AllowFlashlight(true)
	ply:SetNoCollideWithTeammates(true)
end

local function playerSpawn(ply, transition)
	timer.Simple(1, function()
		ply:SetCharacter("merc")
	end)
end
hook.Add("PlayerSpawn", "PlayerSetCharacter", playerSpawn)

local function scalePlayerDamage(ply, hitgroup, dmginfo)
	net.Start("rogue_AttackPhaseStarted")
	net.Send(ply)
end
hook.Add("ScalePlayerDamage", "CheckForAttackPhase", scalePlayerDamage)

local function playerNoclip(ply, desiredState)
	if desiredState == false then return true end
	if ply:IsAdmin() then return true end
end
hook.Add("PlayerNoClip", "AllowNoclip", playerNoclip)

function GM:PlayerLoadout(ply)
	ply:Give("arccw_go_ace")
end

function GM:ShouldCollide(ent1, ent2)
	if ent1:IsPlayer() and ent2:IsPlayer() then return false end
	return true
end

local metatable = FindMetaTable("Player")
if not metatable then return end

function metatable:Initialize()
	self.rogue = {}
	self.rogue.Modifiers = {}
	self.rogue.Character = ""
	self.rogue.DamagePercent = 1
	self.rogue.SpeedPercent = 1
	self.rogue.CritChance = 0.05
	self.rogue.CritDamagePercent = 2
	self.rogue.SpecialEnergyNeeded = 20
	self.rogue.CurrentSpecialEnergy = 0
end

function metatable:SetCharacter(character)
	self.rogue.Character = character
	net.Start("rogue_CharacterChange")
		net.WriteString(character)
	net.Send(self)

	local char = self:GetCharacterDetails()
	if not char then
		print("How is char nil")
	end
	PrintTable(char, 1)
	self:SetTeam(TEAM_PLAYERS)

	self:SetModel(char.Model)
	self:SetMaxHealth(char.Health)
	self:SetHealth(char.Health)
	self.rogue.DamagePercent = char.DamagePercent
	self.rogue.SpeedPercent	= char.SpeedPercent
	self.rogue.CritChance 	= char.CritChance
	self.rogue.CritDamage 	= char.CritDamage
	self.rogue.SpecialEnergyNeeded = char.SpecialEnergyNeeded
	self.rogue.CurrentSpecialEnergy = 0
end

function metatable:SetEnergy(energy)
	self.rogue.CurrentSpecialEnergy = energy
	net.Start("rogue_EnergySet")
		net.WriteFloat(energy)
	net.Send(self)
end