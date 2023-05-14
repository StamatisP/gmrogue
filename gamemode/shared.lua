GM.Name = "GM Rogue"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

DeriveGamemode("base")

function GM:Initialize()
	self.BaseClass.Initialize(self)
	if CLIENT then return end
	local arccw_convar = GetConVar("arccw_enable_customization")
	local arccw_infammo = GetConVar("arccw_mult_infiniteammo")
	local arccw_shootwhilesprinting = GetConVar("arccw_mult_shootwhilesprinting")
	if arccw_convar then
		arccw_convar:SetBool(false)
		arccw_infammo:SetBool(true)
		arccw_shootwhilesprinting:SetBool(true)
		print("ArcCW convars set.")
	else
		print("ArcCW not installed!")
	end
	local hitnum_breakables = GetConVar("sv_hitnums_breakablesonly")
	local hitnum_enabled = GetConVar("sv_hitnums_enable")
	if hitnum_breakables then
		hitnum_breakables:SetBool(false)
		hitnum_enabled:SetBool(true)
		print("Hitnum convars set.")
	else
		print("Hit numbers addon not installed!")
	end
end

AddCSLuaFile("load.lua")
include("load.lua")