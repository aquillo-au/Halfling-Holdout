class Goodies
    def initialize 
        GOODIES = {
            guard: {
            hp: 10,
            atk: [1,4],
            value: 2,
            name: "Guard",
            armor: 5,
            tile_key: :h
            },
            villager: {
            hp: 5,
            atk: [1,2],
            value: 1,
            name: "Villager",
            armor: 0,
            tile_key: :v
            },
            cook: {
            hp: 5,
            atk: [1,3],
            value: 1,
            name: "Cook",
            armor: 1,
            tile_key: :c
            }
        }

    end

    def spawn_villager(type = 'random')
        if type == 'villager'
            type = GOODIES[:villager] 
        elsif type == 'Cook'
            type = GOODIES[:cook]
        else
            type = GOODIES[GOODIES.keys.sample]
        end
        good_guy = { x: rand(23) + 18, y: rand(22) + 9, type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk, armor: type.armor}
        $gtk.args.state.goodies << good_guy
        return
    end

    def place_villager(x,y, type)
        type = type.to_sym
        {x: x, y: y, type: GOODIES[type].name, tile_key: GOODIES[type].tile_key, hp: GOODIES[type].hp, atk: GOODIES[type].atk, armor: GOODIES[type].armor }
    end

    def spawn_pie_wagon
        cords = spawn_location
        { x: cords[0], y: cords[1], type: "Pie Wagon", tile_key: :W, hp: 15, atk: [0,0], armor: 5}
    end

    def spawn_ranger
        cords = spawn_location
        { x: cords[0], y: cords[1], type: "Ranger", tile_key: :R, hp: 6, atk: [0,4], arrows: 0, armor: 2}
    end

    private

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
end