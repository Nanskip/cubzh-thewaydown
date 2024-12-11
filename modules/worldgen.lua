local mod = {}

function mod.INIT()
    return true
end

mod.tiles = {
    [0] = Color(79, 55, 35),
    [1] = Color(107, 114, 115),
    [2] = Color(69, 71, 71)
}

function mod.generate()
    local height = 30
    local width = 10

    mod.map = {}
    for y = 0, height do
        map[y] = {}
        for x = 0, width do
            map[y][x] = math.random(0, 2)
        end
    end
end

function mod.build()
    mod.mapObject = MutableShape()
    for y = 0, height do
        for x = 0, width do
            local color = mod.tiles[mod.map[y][x]]
            if color ~= nil then
                mod.mapObject:AddBlock(color, x, y, 0)
            end
        end
    end
    mod.mapObject:SetParent(World)
end

return mod