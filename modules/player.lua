local mod = {}

mod.INIT = function()
    return true
end

mod.spawn = function()
    local player = Shape(Items.nanskip.dril)
    player.Position = Number3(5.5, 0, 0.35)
    player.Scale = 0.1
    player.Pivot.Y = 0

    player.Rotation.Y = math.pi
    player.Tick = function(self, dt)
        local part = self:GetChild(1)
        part.LocalRotation.Y = part.LocalRotation.Y + dt*2
    end

    player:SetParent(World)
    return player
end

return mod