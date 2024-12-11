local mod = {}

mod.INIT = function()
    mod.lastmove = {0, 0}
    mod.lastclick = {0, 0}
    mod._listen = false

    return true
end

mod.listen = function()
    mod.downlistener = LocalEvent:Listen(LocalEvent.Name.PointerDown, function(payload)
        if not mod._listen then
            mod.lastclick = {payload.X, payload.Y}
            mod._listen = true

            Timer(0.03, function()
                if mod._listen then
                    mod._listen = false
                    local dx = mod.lastclick[1] - mod.lastmove[1]
                    local dy = mod.lastclick[2] - mod.lastmove[2]

                    if math.abs(dx) > math.abs(dy) then
                        if dx < 0 then
                            mod.right()
                        elseif dx > 0 then
                            mod.left()
                        end
                    else
                        if dy < 0 then
                            mod.up()
                        elseif dy > 0 then
                            mod.down()
                        end
                    end

                    mod.lastmove = {mod.lastclick[1], mod.lastclick[2]}
                end
            end)
        end
    end)

    mod.uplistener = LocalEvent:Listen(LocalEvent.Name.PointerUp, function(payload)
        mod._listen = false
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