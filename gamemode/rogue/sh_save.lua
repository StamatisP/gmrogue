hook.Add("InitPostEntity", "LoadXP", function()
	local xpFile = file.Read("rogue_xp.txt", "DATA")
	if not xpFile then
		file.Write("rogue_xp.txt", "0")
		xpFile = "0"
	end
	local xp = tonumber(xpFile) or 0
	ROGUE.XP = xp
	timer.Create("SaveXP", 10, 0, function()
		file.Write("rogue_xp.txt", ROGUE.XP)
	end)
end)