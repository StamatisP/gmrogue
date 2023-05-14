local function tryCastSpecial()
	net.Start("rogue_ClientRequestSpecial")
	net.SendToServer()
end

local function handlePlayerInput(ply, button)
	if button == KEY_Q then
		tryCastSpecial()
	end
end
hook.Add("PlayerButtonDown", "PlayerInput", handlePlayerInput)
