local mod = {}

mod.INIT = function()
    return true
end

mod.listen = function()
    mod.downlistener = LocalEvent:Listen(LocalEvent.Name.PointerDown, function(payload)
        if not mod.listen then
            mod.lastclick = {payload.X, payload.Y}
            mod.listen = true

            Timer(1, function()
                if mod.listen then
                    mod.listen = false
                    local dx = mod.lastclick[1] - mod.lastmove[1]
                    local dy = mod.lastclick[2] - mod.lastmove[2]

                    if math.abs(dx) > math.abs(dy) then
                        if dx > 0 then
                            mod.right()
                        else
                            mod.left()
                        end
                    else
                        if dy > 0 then
                            mod.up()
                        else
                            mod.down()
                        end
                    end
                end
            end)
        end
    end)

    mod.uplistener = LocalEvent:Listen(LocalEvent.Name.PointerUp, function(payload)
        mod.listen = false
    end)

    mod.movelistener = LocalEvent:Listen(LocalEvent.Name.PointerDrag, function(payload)
        mod.lastmove = {payload.X, payload.Y}
    end)

    mod.right = function() print("right") end
    mod.left = function() print("left") end
    mod.up = function() print("up") end
    mod.down = function() print("down") end
end

return mod