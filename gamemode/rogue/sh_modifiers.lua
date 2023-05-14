if CLIENT then end

local function addModifier(ply, cmd, args, argStr)
	if not args or not ROGUE.Modifiers[args[1]] then
		print(args[1] .. " is not a correct modifier! Here's a list:")
		PrintTable(ROGUE.Modifiers)
		return
	end
	local modifier = args[1]
	local mod = ROGUE.Modifiers[modifier]
	ply.rogue.Modifiers[modifier] = mod
	hook.Add(mod.Hook, mod.HookName, mod.Function)
	print("Modifier " .. mod.Name .. " added!")
end


concommand.Add("rogue_addmodifier", addModifier)