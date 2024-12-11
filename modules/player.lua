local mod = {}

mod.INIT = function()
    return true
end

mod.spawn = function()
    local player = Shape(Items.nanskip.dril)
    player.Position = Number3(5.5, 0.35, 0.35)
    player.Scale = 0.1
    player.Pivot.Y = 0.5

    player.Rotation.Y = math.pi
    player.Tick = function(self, dt)
        local part = self:GetChild(1)
        part.LocalRotation.Y = part.LocalRotation.Y + dt*5
    end
    player.cords = {5, -1}

    player.move = function(self, dir)
        local tile = worldgen.map[self.cords[2]+dir.Y][self.cords[1]+dir.X]
        if tile ~= nil then
            worldgen.map[self.cords[2]+dir.Y][self.cords[1]+dir.X] = nil
            local block = worldgen.mapObject:GetBlock(Number3(self.cords[1]+dir.X, self.cords[2]+dir.Y, 0))
            block:Remove()
        else
            self.cords[1] = math.round(self.cords[1] + dir.X)
            self.cords[2] = math.round(self.cords[2] - dir.Y)

            self.Position =  self.Position + Number3(self.cords[1]/10, self.cords[2]/10, 0.35)
        end
    end

    player:SetParent(World)
    return player
end

return mod