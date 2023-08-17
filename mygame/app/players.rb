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
                type: "Hero"    
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
                type: "Hero"
            }
        }
    end

    def player_data(player_choice)
        choice = player_choice.to_s.to_sym
        @players[choice]
    end

end