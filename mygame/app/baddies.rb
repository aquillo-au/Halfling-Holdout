class Baddies
    def initialize()
        @baddies = {
            goblin: {
            hp: 5,
            atk: [1,3],
            value: 3,
            name: "Goblin",
            tile_key: :g,
            armor: 2
            },
            rat: {
            hp: 2,
            atk: [1,2],
            value: 1,
            name: "Rat",
            tile_key: :r,
            armor: 0
            }
        }
        if $gtk.args.state.level > 3
            @baddies[:orc] = 
            {
             hp: 10,
             atk: [1,5],
             value: 6,
             name: "Orc",
             tile_key: :o, 
             armor: 4  
            }
        end
        if $gtk.args.state.level > 3
            @baddies[:shaman] = 
            {
             hp: 6,
             atk: [1,4],
             value: 8,
             name: "Goblin Shaman",
             tile_key: :s, 
             armor: 1  
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
            bad_guy = { x: cords[0], y: cords[1], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk, armor: type.armor, value: type.value}
            $gtk.args.state.enemies << bad_guy
            $gtk.args.state.budget -= type.value
        end
    end
end