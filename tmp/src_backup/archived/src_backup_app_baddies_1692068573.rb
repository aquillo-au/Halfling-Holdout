BADDIES = {
    goblin: {
    hp: 5,
    atk: 2,
    value: 3,
    name: "goblin",
    tile_key: :g
    },
    rat: {
    hp: 2,
    atk: 1,
    value: 1,
    name: "rat",
    tile_key: :r
    }
}

def spawn_baddie(args)
    if args.state.budget > 0
        type = BADDIES[BADDIES.keys.sample]
        cords = spawn_location
        bad_guy = { x: cords[0], y: cords[1], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
        args.state.enemies << bad_guy
        args.state.budget -= type.value
    end
end

def spawn_location
    side = rand(4)
    case side
    when 1
        return [0,rand($gtk.args.state.grid.height)]
    when 2
        return [$gtk.args.state.grid.width,rand($gtk.args.state.grid.height)]
    when 3
        return [rand($gtk.args.state.grid.width),0]
    else
        return [rand($gtk.args.state.grid.width),$gtk.args.state.grid.height]
    end
end