local mod = {}

function mod.INIT()
    return true
end

mod.tiles = {
    [0] = {
        name = "dirt",
        color = Color(79, 55, 35),
        maxHeight = 10,
        minHeight = 0,
        offset = 2,
        health = 1,
    },
    [1] = {
        name = "stone",
        color = Color(107, 114, 115),
        maxHeight = 20,
        minHeight = 10,
        offset = 2,
        health = 2,
    },
    [2] = {
        name = "granite",
        color = Color(69, 71, 71),
        maxHeight = 30,
        minHeight = 20,
        offset = 2,
        health = 4,
    }
}

function mod.generate()
    local width = 10

    mod.map = {}
    for i=0, #mod.tiles do
        local tile = mod.tiles[i]

        for y = 0 + tile.minHeight, tile.minHeight + tile.maxHeight + tile.offset do
            mod.map[y] = {}
            for x = 0, width do
                if y <= tile.minHeight + tile.maxHeight then
                    if mod.map[y][x] ~= nil then
                        mod.map[y][x] = i
                    end
                else
                    mod.map[y][x] = i + math.random(0, 1)
                end
            end
        end
    end
end

function mod.build()
    mod.mapObject = MutableShape()
    local height = 30
    local width = 10

    for y = 0, height do
        for x = 0, width do
            local tile = mod.tiles[mod.map[y][x]]

            if tile ~= nil then
                mod.mapObject:AddBlock(tile.color, Number3(x, y, 0))
            end
        end
    end
    mod.mapObject:SetParent(World)
end

return mod