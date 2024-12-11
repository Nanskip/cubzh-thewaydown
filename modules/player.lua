local mod = {}

mod.INIT = function()
    return true
end

mod.spawn = function()
    local player = Shape(Items.nanskip.dril)
    player.Position = Number3(5.5, 0.5, 0.35)
    player.Scale = 1/7
    player.Pivot.Y = 0.5
    player.pos = Number3(5.5, 0.5, 0.35)

    player.Rotation.Y = math.pi
    player.Tick = function(self, dt)
        local part = self:GetChild(1)
        part.LocalRotation.Y = part.LocalRotation.Y + dt*5
        
        self.Position:Lerp(self.Position, self.pos, 0.3)
    end
    player.cords = {5, -1}

    player.move = function(self, dir)
        local tile = worldgen.map[self.cords[2]-dir.Y][self.cords[1]+dir.X]
        if tile ~= nil then
            if tile[2] ~= nil then
                log("Got ore: " .. worldgen.ores[tile[2]].name .. " at [" .. self.cords[1] .. ", " .. self.cords[2] .. "]. Cost: " .. worldgen.ores[tile[2]].cost)
                local ore = worldgen.mapShapes[self.cords[2]-dir.Y][self.cords[1]+dir.X]
                if ore ~= nil then
                    ore:SetParent(nil)
                    ore = nil
                end
            end
            worldgen.map[self.cords[2]-dir.Y][self.cords[1]+dir.X] = nil
            local block = worldgen.mapObject:GetBlock(Number3(self.cords[1]+dir.X, self.cords[2]-dir.Y, 0))
            if block ~= nil then block:Remove() end
        else
            self.cords[1] = math.round(self.cords[1] + dir.X)
            self.cords[2] = math.round(self.cords[2] - dir.Y)

            self.pos = Number3(self.cords[1] + 0.5, -self.cords[2] - 0.5, 0.35)
        end
    end

    player:SetParent(World)
    return player
end

return mod