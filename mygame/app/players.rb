class Players
    def initialize()
        @players = {
            warrior: {
                y: 20,
                x: 28,
                hp: 30,
                maxhp: 30,
                atk: [1,6],
                arrows: 1,
                quiver: 1,
                armor: 8,
                mana: 0,
                maxmana: 0,
                type: "Warrior", 
                sprite_key: :warrior, 
                spells: false
            },
            hero: {
                y: 20,
                x: 28,
                hp: 20,
                maxhp: 20,
                atk: [1,6],
                arrows: 5,
                quiver: 5,
                armor: 4,
                mana: 0,
                maxmana: 10,
                type: "Hero",
                sprite_key: :hero,
                spells: {
                    lightning: true,
                }
            },
            archer: {
                y: 20,
                x: 28,
                hp: 15,
                maxhp: 15,
                atk: [1,4],
                arrows: 10,
                quiver: 10,
                armor: 1,
                mana: 5,
                maxmana: 10,
                type: "Archer",
                sprite_key: :archer,
                spells: {
                    lightning: 5,
                }
            }
        }
    end

    def player_data(player_choice)
        choice = player_choice.to_s.to_sym
        @players[choice]
    end

end