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
    }
}

def spawn_villager(type = 'random')
    if type == 'random'
        type = GOODIES[GOODIES.keys.sample]
    else 
        type = GOODIES[:type]
        cords = spawn_location
        good_guy = { x: cords[rand(23) + 18], y: cords[rand(22) + 9], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
        args.state.goodies << good_guy
    end
end