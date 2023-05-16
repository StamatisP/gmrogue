local pos = Vector(0, 0, 0)
local angles = Angle(0, 0, 0)

/*function ENT:DrawTranslucent()
    if not ui3d2d.startDraw(self:WorldToLocal(self:GetPos()), self:WorldToLocalAngles(angles), .1, self) then print("cring") return end --Skip drawing if the player can't see the UI

    --Draw your UI here
    surface.SetDrawColor(155, 155, 155, 155)
    surface.DrawRect(0, 0, 100, 50)
    local health = self:Health()
    local max = self:GetMaxHealth()
    surface.SetDrawColor(0, 200, 0, 255)
    surface.DrawRect(0, 0, 100 * (health / max), 50)

    ui3d2d.endDraw() --Finish the UI render
end*/