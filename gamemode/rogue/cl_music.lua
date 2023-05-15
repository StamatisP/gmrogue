// https://wiki.facepunch.com/gmod/IGModAudioChannel:SetTime
local song = {
	bpm = 128,
	intro = "gamemodes/gmrogue/sound/gmod_loop.wav",
	loop = "gamemodes/gmrogue/sound/gmod_loop.wav",
	attack_intro = "gamemodes/gmrogue/sound/gmod_attackintro.wav",
	attack_phase = "gamemodes/gmrogue/sound/gmod_attackphase.wav",
	outro = "gamemodes/gmrogue/sound/example_outro.wav"
}
local soundchannel
local soundchannel_attack
local isInAttackPhase = false

local function fadeAudio(volumeTarget, duration, station, callback)
	local currentTime = 0
	local start = station:GetVolume()
	while currentTime < duration do
		currentTime = currentTime + RealFrameTime()
		local vol = Lerp(currentTime / duration, start, volumeTarget)
		//print(vol)
		station:SetVolume(vol)
		coroutine.yield()
	end
	callback()
end

local coroutines = {}
local function fadeMusic(volumeTarget, duration, station) 
	local identifier = "Fade" .. math.Rand(0, 100)
	local coroutineIndex = 1
	if coroutines[1] and not coroutines[2] then coroutineIndex = 2 end 
	local function removeHook()
		hook.Remove("Think", identifier)
		coroutines[coroutineIndex] = nil
	end
	coroutines[coroutineIndex] = coroutine.create(function()
		fadeAudio(volumeTarget, duration, station, removeHook)
	end)
	hook.Add("Think", identifier, function()
		for i, v in ipairs(coroutines) do
			if v then
				coroutine.resume(v)
			end
		end
	end)
end

local function switchToLoop()
	sound.PlayFile(song.loop, "noblock", function(station, errCode, errStr)
		if IsValid(station) then
			station:EnableLooping(true)
			soundchannel = station
			if isInAttackPhase then station:SetVolume(0) end
		else
			print( "Error playing sound!", errCode, errStr )
		end
	end)
end

local function onAttack()
	isInAttackPhase = true
	fadeMusic(0, (60/song.bpm) * 4, soundchannel)
	if timer.Exists("switchToLoop") then
		switchToLoop()
		timer.Remove("switchToLoop")
	end
	if IsValid(soundchannel_attack) then
		soundchannel_attack:Play()
		soundchannel_attack:SetVolume(0)
		fadeMusic(1, (60/128) * 2, soundchannel_attack)
	else
		sound.PlayFile(song.attack_phase, "noblock", function(station, errCode, errStr)
			if IsValid(station) then
				station:EnableLooping(true)
				soundchannel_attack = station
				soundchannel_attack:SetVolume(0)
				fadeMusic(1, (60/128) * 2, soundchannel_attack)
			else
				print( "Error playing sound!", errCode, errStr )
			end
		end)
	end
end

local function fromAttackToLoop()
	isInAttackPhase = false
	fadeMusic(0, (60/song.bpm) * 4, soundchannel_attack)
	fadeMusic(1, (60/song.bpm) * 4, soundchannel)
end

local function startIntroAndLoop()
	sound.PlayFile(song.intro, "", function(station, errCode, errStr)
		if IsValid(station) then
			soundchannel = station
			timer.Create("switchToLoop", station:GetLength(), 1, switchToLoop)
		else
			print( "Error playing sound!", errCode, errStr )
		end
	end)
end

concommand.Add("rogue_startmusic", startIntroAndLoop)

concommand.Add("rogue_musicattack", onAttack)

concommand.Add("rogue_musicchill", fromAttackToLoop)

hook.Add("RogueHook_GameStarted", "GameStart", startIntroAndLoop)
hook.Add("RogueHook_AttackStarted", "AttackStart", onAttack)
hook.Add("RogueHook_WaveCleared", "BackToChill", function(isMerchantTime)
	if isMerchantTime then fromAttackToLoop() end
end)

// On enter starting room, after procgen: intro, then idle loop
// On enter room with enemies: idle loop with more energy (?)
// On noticed by NPC: attack phase
// On room cleared: idle loop