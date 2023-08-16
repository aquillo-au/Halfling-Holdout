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
    cook: {
    hp: 5,
    atk: 1,
    value: 1,
    name: "Cook",
    tile_key: :v
    }
}

def spawn_villager(type = 'random')
    if type == 'random'
        type = GOODIES[GOODIES.keys.sample]
    else
        type = GOODIES[:villager]
    end
    good_guy = { x: rand(23) + 18, y: rand(22) + 9, type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
    $gtk.args.state.goodies << good_guy
end