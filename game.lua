local game = {}

game.INIT = function()
    _rotations = {
        up = math.pi,
        down = 0,
        left = math.pi/2,
        right = -math.pi/2
    }
    _currentrot = "down"

    return true
end

game.start = function()
    worldgen.generate()
    worldgen.build()
    _PLAYER = player.spawn()
    
    swipe.listen()
    swipe.right = function()
        _currentrot = "right"
    end
    swipe.left = function()
        _currentrot = "left"
    end
    swipe.up = function()
        _currentrot = "up"
    end
    swipe.down = function()
        _currentrot = "down"
    end

    Camera:SetModeFree()
    Camera.FOV = 25
    Camera.Tick = function(self, dt)
        self.Position = _PLAYER.Position + Number3(0, 0, -10)

        _PLAYER.Rotation:Slerp(_PLAYER.Rotation, Rotation(0, math.pi, _rotations[_currentrot]), 0.1)
    end
end

return game