if not ROGUE then
	ROGUE = {}
	ROGUE.Characters = {}
	ROGUE.Modifiers = {}
end

TEAM_PLAYERS = 1

team.SetUp(TEAM_PLAYERS, "Players", Color(177, 177, 177, 255))
team.SetUp(TEAM_SPECTATOR, "Spectators", Color(100, 100, 100, 255))

if SERVER then
	util.AddNetworkString("rogue_CharacterChange")
	util.AddNetworkString("rogue_ClientRequestSpecial")
	util.AddNetworkString("rogue_EnergySet")
	util.AddNetworkString("rogue_AttackPhaseStarted")
	util.AddNetworkString("rogue_GameStarted")
	util.AddNetworkString("rogue_WaveCleared")
	util.AddNetworkString("rogue_S2CSpecialStatus")
	util.AddNetworkString("rogue_XPAdded")
end

local function loadCharacters(dir)
	
	for k, v in pairs(file.Find(dir .. "/*.lua", "LUA")) do
		CHARACTER = {}
		if SERVER then 
			AddCSLuaFile("rogue/characters/" .. v)
		end
		include("rogue/characters/" .. v)
		
		local class = string.gsub(v, ".lua", "")
		
		ROGUE.Characters[class] = CHARACTER
		
		print("Loaded Character", class)
	end
	CHARACTER = nil
end

local function loadCoreGame(dir)
	for k, v in pairs(file.Find(dir .. "/sv_*.lua", "LUA")) do
		 if SERVER then
			include("rogue/" .. v)
		end
	end
	for k, v in pairs(file.Find(dir .. "/cl_*.lua", "LUA")) do
		if SERVER then
			AddCSLuaFile("rogue/" .. v)
		else
			include("rogue/" .. v)
		end
	end
	for k, v in pairs(file.Find(dir .. "/sh_*.lua", "LUA")) do
		if SERVER then
			AddCSLuaFile("rogue/" .. v)
		end
		include("rogue/" .. v)
	end
end

local function loadModifiers(dir)
	
	for k, v in pairs(file.Find(dir .. "/*.lua", "LUA")) do
		MODIFIER = {}
		if SERVER then 
			AddCSLuaFile("rogue/modifiers/" .. v)
		end
		include("rogue/modifiers/" .. v)
		
		local modifier = string.gsub(v, ".lua", "")
		
		ROGUE.Modifiers[modifier] = MODIFIER
		
		print("Loaded Modifier", modifier)
	end
	MODIFIER = nil
end

loadCharacters("gmrogue/gamemode/rogue/characters")
loadCoreGame("gmrogue/gamemode/rogue")
loadModifiers("gmrogue/gamemode/rogue/modifiers")