ROGUE.CurrentRoom = 0
local currentSpawnedNpcs = {}
// index = targetname of spawns (starting from 1)
// roomSpawns.allySpawns = {} list of ally spawns
// roomSpawns.enemySpawns = {} you know
local roomSpawns = roomSpawns or {}

local function buildRoomSpawnsList()
	local allPlayerSpawns = ents.FindByClass("rogue_spawn")
	local allNpcSpawns = ents.FindByClass("rogue_npc_spawn")
	local usedNums = {1}
	for k, v in ipairs(allPlayerSpawns) do
		local num = tonumber(v:GetName())
		//if tonumber(v:GetName()) > highestNumberOfRooms then
			//highestNumberOfRooms = tonumber(v:GetName())
		//end
		if not roomSpawns[num] then roomSpawns[num] = {} end
		if not roomSpawns[num].allySpawns then roomSpawns[num].allySpawns = {} end
		if not usedNums[num] then usedNums[num] = 1 end
		roomSpawns[num].allySpawns[usedNums[num]] = v
		usedNums[num] = usedNums[num] + 1
	end
	usedNums = {1}
	for k, v in ipairs(allNpcSpawns) do
		local num = tonumber(v:GetName())
		//if tonumber(v:GetName()) > highestNumberOfRooms then
			//highestNumberOfRooms = tonumber(v:GetName())
		//end
		if not roomSpawns[num] then roomSpawns[num] = {} end
		if not roomSpawns[num].enemySpawns then roomSpawns[num].enemySpawns = {} end
		if not usedNums[num] then usedNums[num] = 1 end
		roomSpawns[num].enemySpawns[usedNums[num]] = v
		usedNums[num] = usedNums[num] + 1
	end
	print("Room spawns set up!")
	PrintTable(roomSpawns)
end

local function spawnNpc(position)
	local npc = ents.Create("npc_vj_bmssold_marines")
	if not IsValid(npc) then return nil end

	npc:SetPos(position)
	npc:Spawn()
	npc:Give("weapon_vj_smg1")
	return npc
end

local function newWave()
	if not roomSpawns or next(roomSpawns) == nil then buildRoomSpawnsList() end
	local randInt = math.random(#roomSpawns)
	print(randInt)
	PrintTable(roomSpawns)
	local randRoom = roomSpawns[randInt]
	local players = player.GetHumans()
	for k, v in ipairs(players) do
		local spawn = randRoom.allySpawns[math.random(#randRoom.allySpawns)]
		v:SetPos(spawn:GetPos())
	end

	local numberOfSpawns = math.random(3, 5) + (ROGUE.CurrentRoom * 0.5)
	numberOfSpawns = math.ceil(numberOfSpawns)
	local spawnList = roomSpawns[randInt].enemySpawns
	// spawn if player isnt in eyesight
	ROGUE.CurrentRoom = ROGUE.CurrentRoom + 1
	for i=1, numberOfSpawns do
		local npc = spawnNpc(spawnList[math.random(#spawnList)]:GetPos())
		currentSpawnedNpcs[npc:EntIndex()] = npc
	end
	print("new wave", ROGUE.CurrentRoom)
end

local function endWave()
	print("wave ended!")
	net.Start("rogue_WaveCleared")
	net.Broadcast()
	timer.Simple(2, newWave)
end

local function gameStarted()
	net.Start("rogue_GameStarted")
	net.Broadcast()
	newWave()
end

hook.Add("RogueHook_TouchTrigger", "StartGameHook", gameStarted)
hook.Add("OnNPCKilled", "DecrementCurrentEnemies", function(npc, attacker, inflictor)
	currentSpawnedNpcs[npc:EntIndex()] = nil
	local count = 0
	for _ in pairs(currentSpawnedNpcs) do count = count + 1 end
	if count == 0 then endWave() end
end)
hook.Add("InitPostEntity", "BuildSpawnLists", buildRoomSpawnsList)

/*
start game: choose weapon, head into xen portal
 = weapons: smg, revolver, shotgun

spawn into room with objective, defend/attack objective and defend against waves of enemies

clear room in 3 waves, room gains 1 wave per 2 cleared rooms
clearing room gives money and XP, also get XP from killing enemies
money is the per-run resource, XP is the overall resource
XP and money is shared with all players
player XP progress carries over from multiplayer to singleplayer, all players

after every cleared room, go to merchant with MVM style upgrades with no limit
*/