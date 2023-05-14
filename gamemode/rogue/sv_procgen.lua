local gridX, gridY = 20, 20

local function instantiateFloor(posX, posY, posZ)
	local floor = ents.Create("prop_physics")
	floor:SetModel("models/hunter/plates/plate2x2.mdl")
	floor:SetPos(Vector(posX, posY, posZ))
	floor:Spawn()
	floor:SetMoveType(MOVETYPE_NONE)
	floor:SetSolid(SOLID_NONE)
end

local function isSpotOccupied(posX, posY)
	if posX < 1 or posY < 1 then return false end
	if posX > gridX or posY > gridY then return false end
	return ROGUE.MapGraph[posX][posY] == 1
end

local function getDirection(int)
	local x, y = 0, 0
	if int == 1 then x = x - 1 end
	if int == 2 then y = y + 1 end
	if int == 3 then x = x + 1 end
	return Vector(x, y, 0)
end

function GenerateWorld()
	// cleanup
	for a,b in ipairs(ents.FindByClass("prop_physics")) do
		b:Remove()
	end
	ROGUE.MapGraph = {}
	for i=1, gridX do
		ROGUE.MapGraph[i] = {}
		for j=1, gridY do
			ROGUE.MapGraph[i][j] = 0
		end
	end
	local startVector = Entity(1):GetEyeTrace().HitPos
	local nextVector = startVector
	local curX, curY = 10, 1
	ROGUE.MapGraph[curX][curY] = 1
	instantiateFloor(startVector.x, startVector.y)
	for k=1, 20 do
		local rand = math.random(1, 3)
		nextVector = getDirection(rand)
		while isSpotOccupied(nextVector.x, nextVector.y) do
			rand = math.random(1, 3)
			nextVector = getDirection(rand)
		end
		curX = curX + nextVector.x
		curY = curY + nextVector.y
		// 1 = left, 2 = forward, 3 = right
		instantiateFloor(((curX - 10) * 128) + startVector.x, (curY * 128) + startVector.y, startVector.z)
		print(curX, curY, nextVector.x, nextVector.y)
		ROGUE.MapGraph[curX][curY] = 1
	end
end

concommand.Add("rogue_genworld", GenerateWorld)