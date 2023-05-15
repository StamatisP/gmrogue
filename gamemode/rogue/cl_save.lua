function CL_LoadXP()
	local ply = LocalPlayer()
	local xpFile = file.Read("rogue_xp.txt", "DATA")
	if not xpFile then
		file.Write("rogue_xp.txt", "0")
		xpFile = "0"
	end
	local xp = tonumber(xpFile) or 0
	ply.rogue.XP = xp
end

hook.Add("InitPostEntity", "LoadXP", function()
	local ply = LocalPlayer()
	ply.rogue = ply.rogue or {}
	CL_LoadXP()
	timer.Create("SaveXP", 10, 0, function()
		file.Write("rogue_xp.txt", ply.rogue.XP)
	end)
end)