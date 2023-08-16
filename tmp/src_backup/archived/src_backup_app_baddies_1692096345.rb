class Baddies
    def initialize()
        @baddies = {
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
    end

    def spawn_baddie
        if $gtk.args.state.budget > 0
            type = @baddies[@baddies.keys.sample]
            cords = spawn_location
            bad_guy = { x: cords[0], y: cords[1], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
            $gtk.args.state.enemies << bad_guy
            $gtk.args.state.budget -= type.value
        end
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
end