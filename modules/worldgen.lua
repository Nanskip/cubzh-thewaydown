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

mod.ores = {
    [0] = {
        name = "coal",
        cost = 1,
        tiles = {
            0, 1
        },
        color = Color(30, 30, 30),
        chance = 0.1
    },
    [1] = {
        name = "iron",
        cost = 2,
        tiles = {
            1, 2
        },
        color = Color(227, 202, 154),
        chance = 0.075
    },
}

function mod.generate()
    local width = 10

    mod.map = {}
    for i=0, #mod.tiles do
        local tile = mod.tiles[i]

        for y = 0 + tile.minHeight, tile.minHeight + tile.maxHeight + tile.offset do
            if mod.map[y] == nil then mod.map[y] = {} end
            for x = 0, width do
                if y <= tile.minHeight + tile.maxHeight then
                    if mod.map[y][x] == nil then
                        mod.map[y][x] = {i}
                    end
                else
                    mod.map[y][x] = {i + math.random(0, 1)}
                end
            end
        end
    end

    for i=0, #mod.ores do
        local ore = mod.ores[i]

        for y = 0, #mod.map do
            for x = 0, width do
                if mod.map[y][x] ~= nil then
                    local ok = false
                    for k, v in pairs(ore.tiles) do
                        if mod.map[y][x][1] == v then
                            ok = true
                        end
                    end

                    if ok then
                        if math.random(1, 1//ore.chance) == 1 then
                            mod.map[y][x][2] = i
                        end
                    end
                end
            end
        end
    end
end

function mod.build()
    mod.mapObject = MutableShape()
    local height = #mod.map
    local width = 10

    mod.mapShapes = {}

    for y = 0, height do
        mod.mapShapes[y] = {}
        for x = 0, width do
            local tile = mod.tiles[mod.map[y][x][1]]

            if tile ~= nil then
                mod.mapObject:AddBlock(tile.color, Number3(x, y, 0))
            end
            local ore = mod.ores[mod.map[y][x][2]]
            if ore ~= nil then
                local shape = Shape(Items.nanskip.conv_ore_coal)

                for i=1, shape.ChildrenCount do
                    local s = shape:GetChild(i)
                    s.Palette[1].Color = ore.color
                    s.Palette[2].Color = Color(ore.color.R+10, ore.color.G+10, ore.color.B+10)
                end

                shape.Rotation.X = -math.pi/2
                shape.Position = Number3(x+0.5, -y-0.5, 0.2)
                shape.Scale = 0.1
                shape:SetParent(World)

                mod.mapShapes[y][x] = shape
            end
        end
    end
    mod.mapObject.Rotation.X = math.pi
    mod.mapObject.Pivot.Z = 1
    mod.mapObject:SetParent(World)
end

return mod