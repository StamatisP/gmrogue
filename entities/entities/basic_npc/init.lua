AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

ENT.StartHealth = 50 + (ROGUE.CurrentRoom * 50)
ENT.Model = {"models/Humans/Group01/Female_01.mdl"}
ENT.HasMeleeAttack = false
ENT.WeaponSpread = 2.5
ENT.HasItemDropsOnDeath = false
ENT.BecomeEnemyToPlayer = true
ENT.VJ_NPC_Class = {CLASS_COMBINE}
ENT.AllowPrintingInChat = false
ENT.UsePlayerModelMovement = true
ENT.WeaponBackAway_Distance = 50
ENT.DropWeaponOnDeath = false
ENT.FindEnemy_CanSeeThroughWalls = false

function ENT:CustomOnPlayerSight(ent)
	print("sex")
	ENT.FindEnemy_CanSeeThroughWalls = true
end