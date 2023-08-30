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
        if $gtk.args.state.level > 5
            @baddies[:orc] = 
            {
             hp: 10,
             atk: [1,5],
             value: 7,
             name: "Orc",
             tile_key: :n, 
             armor: 4  
            }
        end
        if $gtk.args.state.level > 8
            @baddies[:troll] = 
            {
             hp: 20,
             atk: [2,6],
             value: 10,
             name: "Troll",
             tile_key: :o, 
             armor: 6
            }
        end
        if $gtk.args.state.level > 4
            @baddies[:shaman] = 
            {
             hp: 6,
             atk: [1,4],
             value: 8,
             name: "Orc Shaman",
             tile_key: :s, 
             armor: 1  
            }
        end
        if $gtk.args.state.level > 3
            @baddies[:xbowgob] = 
            {
             hp: 5,
             atk: [1,2],
             value: 6,
             name: "Goblin Bowman",
             tile_key: :f, 
             armor: 1  
            }
        end
        @undead = {
            skeleton: {
            hp: 6,
            atk: [1,3],
            value: 2,
            name: "Skeleton",
            tile_key: :skeleton,
            armor: 1
            },
            slime: {
            hp: 4,
            atk: [1,1],
            value: 1,
            name: "Slime",
            tile_key: :slime,
            armor: 0
            }            
        }
        if $gtk.args.state.level > 3
            @undead[:spirit] = 
            {
             hp: 5,
             atk: [1,4],
             value: 6,
             name: "Spirit",
             tile_key: :spirit, 
             armor: 0  
            }
        end
        if $gtk.args.state.level > 4
            @undead[:necro] = 
            {
             hp: 6,
             atk: [1,4],
             value: 8,
             name: "Necromancer",
             tile_key: :necro, 
             armor: 0  
            }
        end
        if $gtk.args.state.level > 5
            @undead[:golem] = 
            {
             hp: 20,
             atk: [2,3],
             value: 7,
             name: "Flesh Golem",
             tile_key: :golem, 
             armor: 2  
            }
        end
        if $gtk.args.state.level > 8
            @undead[:demon] = 
            {
             hp: 20,
             atk: [2,6],
             value: 10,
             name: "Demon",
             tile_key: :demon, 
             armor: 15
            }
        end
    end

    def spawn_enemies
        if $bad_guys == 'Greenskins'
            spawn_baddie
        else
            spawn_undead
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

    def spawn_undead
        if $gtk.args.state.budget > 0
            type = @undead[@undead.keys.sample]
            until $gtk.args.state.budget - type.value > -1 do
                type = @undead[@undead.keys.sample]
            end
            cords = spawn_location
            bad_guy = { x: cords[0], y: cords[1], type: type.name, tile_key: type.tile_key, hp: type.hp, atk: type.atk, armor: type.armor, value: type.value}
            $gtk.args.state.enemies << bad_guy
            $gtk.args.state.budget -= type.value
        end
    end

    def spawn_zombie_rat(summoner)
        cords = BasicPath.new(summoner).random_direction
        bad_guy = { x: cords[0], y: cords[1], type: 'Zombie Rat', tile_key: :zrat, hp: 2, atk: [1,2], armor: 0, value: 1}
        $gtk.args.state.enemies << bad_guy
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