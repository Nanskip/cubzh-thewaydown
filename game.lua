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
    _PLAYING = false
    _SPEED = 1

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
    Camera.Rotation = Rotation(0, 0, 0)
    Camera.FOV = 25
    Camera.Tick = function(self, dt)
        self.Position = _PLAYER.Position + Number3(0, 0, -10)

        _PLAYER.Rotation:Slerp(_PLAYER.Rotation, Rotation(0, math.pi, _rotations[_currentrot]), 0.3)

        game.beat.Pitch = _SPEED
        if _PLAYING then
            _beatTick = _beatTick + dt * _SPEED
            if _beatTick > 1.008 then
                _beatTick = _beatTick - 1.008
                _offsetfix = _offsetfix + 1
                if _offsetfix >= 4 then
                    _offsetfix = 0
                    game.beat:Stop()
                    game.beat:Play()
                end
                
                if _currentrot == "right" then
                    _PLAYER:move(Number3(1, 0, 0))
                elseif _currentrot == "left" then
                    _PLAYER:move(Number3(-1, 0, 0))
                elseif _currentrot == "up" then
                    _PLAYER:move(Number3(0, 1, 0))
                elseif _currentrot == "down" then
                    _PLAYER:move(Number3(0, -1, 0))
                end
            end
        end
    end
end

game.play = function()
    game.beat = AudioSource()
    game.beat:SetParent(Camera)
    game.beat.Sound = _SOUNDS.beat
    game.beat.Loop = true
    game.beat:Play()
    _beatTick = 0
    _offsetfix = 0

    _PLAYING = true
end

return game