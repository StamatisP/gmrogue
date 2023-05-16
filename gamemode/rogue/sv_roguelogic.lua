ROGUE.CurrentWave = 0
ROGUE.RoomsCleared = 0
ROGUE.CurrentRoom = 0
local currentSpawnedNpcs = {}
// index = targetname of spawns (starting from 1)
// roomSpawns.allySpawns = {} list of ally spawns
// roomSpawns.enemySpawns = {} you know
local roomSpawns = roomSpawns or {}
local merchantSpawns = merchantSpawns or {}
local newWave, endWave
local spawnsLeft
local waveActive = false

local function buildRoomSpawnsList()
	local allPlayerSpawns = ents.FindByClass("rogue_spawn")
	local allNpcSpawns = ents.FindByClass("rogue_npc_spawn")
	for k, v in ipairs(allPlayerSpawns) do
		local num = tonumber(v:GetName())
		if num then
			// if name is a number, it's a numerical spawn
			if not roomSpawns[num] then roomSpawns[num] = {} end
			if not roomSpawns[num].allySpawns then roomSpawns[num].allySpawns = {} end
			table.insert(roomSpawns[num].allySpawns, v)
		elseif v:GetName() == "merchant" then
			table.insert(merchantSpawns, v)
		end
	end
	for k, v in ipairs(allNpcSpawns) do
		local num = tonumber(v:GetName())
		if not roomSpawns[num] then roomSpawns[num] = {} end
		if not roomSpawns[num].enemySpawns then roomSpawns[num].enemySpawns = {} end
		table.insert(roomSpawns[num].enemySpawns, v)
	end
	print("Room spawns set up!")
	PrintTable(roomSpawns)
	PrintTable(merchantSpawns)
end

local function isSpawnOccupied(positionVector)
	local startVec = positionVector + Vector(-64, -64, 0)
	local endVec = positionVector + Vector(64, 64, 64)
	local entsTab = ents.FindInBox(startVec, endVec)
	local npcTab = {}
	for k, v in ipairs(entsTab) do
		if v:IsNPC() or v:IsNextBot() or v:IsPlayer() then table.insert(npcTab, v) end
	end
	return next(npcTab) != nil
end

local function merchantRoom()
	local players = player.GetHumans()
	for k, v in ipairs(players) do
		local spawn = merchantSpawns[math.random(#merchantSpawns)]
		v:SetPos(spawn:GetPos())
	end
end

endWave = function()
	print("wave ended!")
	waveActive = false
	local isMerchantTime = ROGUE.CurrentWave % 3 == 0
	if isMerchantTime then
		timer.Simple(2, merchantRoom)
	else
		timer.Simple(2, function()
			newWave(ROGUE.CurrentRoom)
		end)
	end
	net.Start("rogue_WaveCleared")
		net.WriteBool(isMerchantTime)
	net.Broadcast()
end

local function spawnNpc(position)
	local npc = ents.Create("npc_vj_bmssold_marines")
	if not IsValid(npc) then return nil end

	npc:SetPos(position)
	npc:Spawn()
	npc:Give("weapon_vj_smg1")
	currentSpawnedNpcs[npc:EntIndex()] = npc
	return npc
end

newWave = function(roomInt)
	waveActive = true
	local numberOfSpawns = math.random(3, 6) + (ROGUE.CurrentWave * 0.6)
	numberOfSpawns = math.ceil(numberOfSpawns)
	spawnsLeft = numberOfSpawns
	local tab = roomSpawns[roomInt]
	local spawnList = tab.enemySpawns
	// spawn if player isnt in eyesight
	ROGUE.CurrentWave = ROGUE.CurrentWave + 1
	timer.Create("spawnNpcs", 1, 0, function()
		if spawnsLeft <= 0 then
			timer.Destroy("spawnNpcs")
			return
		end
		local spawnPos = spawnList[math.random(#spawnList)]:GetPos()
		if isSpawnOccupied(spawnPos) then
			print("spawn occupied!")
			return 
		end
		local npc = spawnNpc(spawnPos)
		spawnsLeft = spawnsLeft - 1
		print("spawnsleft: ", spawnsLeft)
	end)
	print("new wave", ROGUE.CurrentWave)
end

local function newRoom()
	if not roomSpawns or next(roomSpawns) == nil then buildRoomSpawnsList() end
	// teleport all players to new room
	local randInt = math.random(#roomSpawns)
	local randRoom = roomSpawns[randInt]
	local players = player.GetHumans()
	for k, v in ipairs(players) do
		local spawn = randRoom.allySpawns[math.random(#randRoom.allySpawns)]
		v:SetPos(spawn:GetPos())
	end
	ROGUE.CurrentRoom = randInt
	print("New room", ROGUE.CurrentRoom)
	newWave(randInt)
end

local function gameStarted()
	net.Start("rogue_GameStarted")
	net.Broadcast()
	newRoom()
end

hook.Add("RogueHook_TouchTrigger", "StartGameHook", gameStarted)
hook.Add("OnNPCKilled", "DecrementCurrentEnemies", function(npc, attacker, inflictor)
	currentSpawnedNpcs[npc:EntIndex()] = nil
	if spawnsLeft <= 0 and waveActive and next(currentSpawnedNpcs) == nil then endWave() end
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