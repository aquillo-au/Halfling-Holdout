GOODIES = {
    guard: {
    hp: 10,
    atk: 1,
    value: 2,
    name: "Guard",
    tile_key: :h
    },
    villager: {
    hp: 5,
    atk: 1,
    value: 1,
    name: "Villager",
    tile_key: :v
    },
    cook: {
    hp: 5,
    atk: 1,
    value: 1,
    name: "Cook",
    tile_key: :c
    }
}

def spawn_villager(type = 'random')
    if type == 'Villager'
        type = GOODIES[:villager] 
    elsif type == 'Cook'
        type = GOODIES[:cook]
    else
        type = GOODIES[GOODIES.keys.sample]
    end
    good_guy = { x: rand(23) + 18, y: rand(22) + 9, type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
    $gtk.args.state.goodies << good_guy
end

def spawn_pie_wagon
    cords = spawn_location
    { x: cords[0], y: cords[1], type: "Pie Wagon", tile_key: :W, hp: 15, atk: 0}
end

def spawn_location
    side = rand(4)
    case side
    when 1
        return [0, rand(HEIGHT)]
    when 2
        return [WIDTH, rand(HEIGHT)]
    when 3
        return [rand(WIDTH), 0]
    else
        return [rand(WIDTH), HEIGHT - 1 ]
    end
end