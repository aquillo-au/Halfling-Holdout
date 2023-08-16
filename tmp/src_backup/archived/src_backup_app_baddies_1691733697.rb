BADDIES = {
    goblin: {
    hp: 5,
    atk: 2,
    value: 2,
    name: "goblin",
    tile_key: :G
    },
    rat: {
    hp: 2,
    atk: 1,
    value: 1,
    name: "rat",
    tile_key: :R
    }
}

def spawn_baddie(budget, enemies)
    while budget > 0
        type = BADDIES[BADDIES.keys.sample]
        cords = spawn_location
        bad_guy = { x: cords[0], y: cords[1], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
        enemies << bad_guy
        budget -= type.value
        p budget
    end
end

def spawn_location
    side = rand(4)
    case side
    when 1
        return [0,rand(42)]
    when 2
        return [60,rand(42)]
    when 3
        return [rand(60),0]
    else
        return [rand(60),42]
    end
end