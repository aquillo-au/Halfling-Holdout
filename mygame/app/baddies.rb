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
        if $gtk.args.state.level > 3
            @baddies[:orc] = 
            {
             hp: 10,
             atk: 5,
             value: 6,
             name: "Orc",
             tile_key: :o,   
            }
        end
    end

    def spawn_baddie
        if $gtk.args.state.budget > 0
            type = @baddies[@baddies.keys.sample]
            until $gtk.args.state.budget - type.value > -1 do
                type = @baddies[@baddies.keys.sample]
            end
            cords = spawn_location
            bad_guy = { x: cords[0], y: cords[1], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk}
            $gtk.args.state.enemies << bad_guy
            $gtk.args.state.budget -= type.value
        end
    end
end