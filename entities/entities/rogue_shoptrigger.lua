ENT.Base = "base_brush"
ENT.Type = "brush"

if SERVER then
	function ENT:Initialize()
		self:SetSolid(SOLID_BBOX)
		self:SetTrigger(true)
		//self:SetCollisionBounds(Vector mins, Vector maxs)
	end

	function ENT:StartTouch(entity)
		if not entity:IsPlayer() then return end

		net.Start("rogue_ShopTriggerTouched")
		net.Send(entity)
	end
end