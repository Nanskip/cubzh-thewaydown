local game = {}

game.INIT = function()
    return true
end

game.start = function()
    worldgen.generate()
    worldgen.build()
    _PLAYER = player.spawn()

    Camera:SetModeFree()
    Camera.FOV = 25
    Camera.Tick = function(self, dt)
        self.Position = _PLAYER.Position + Number3(0, 0, -10)
    end
end

return game