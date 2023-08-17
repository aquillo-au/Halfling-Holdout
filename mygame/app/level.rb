class Level
  attr_gtk
  def initialize(args)
    @armor_buff = 0
    @labels = []
    @labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Choose your Power Up",
      size_enum: 6,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 100,
      text: "h for 2 new villagers",
    }
    if $player_choice == 'hero'
      @labels << {
        x: 40,
        y: args.grid.h - 120,
        text: "a for 1 more attack",
      }
      @labels << {
        x: 40,
        y: args.grid.h - 140,
        text: "p for 5 more max hit points",
      }
      @labels << {
        x: 40,
        y: args.grid.h - 160,
        text: "q for a 3 larger quiver",
      }
    elsif $player_choice == 'warrior'
      @labels << {
        x: 40,
        y: args.grid.h - 120,
        text: "a for 2 more armor",
      }
      @labels << {
        x: 40,
        y: args.grid.h - 140,
        text: "p for 5 more max hit points",
      }
      @labels << {
        x: 40,
        y: args.grid.h - 160,
        text: "q for 1 more arrow slot",
      }
    end      
  end

  def next_level(args)
    args.state.combat_log = []
    args.state.score += args.state.level
    args.state.info_message = nil
    args.state.level += 1
    args.state.budget = args.state.level * 5
    args.state.player.hp += 5
    args.state.player.hp = args.state.player.hp.clamp(1, args.state.player.maxhp)
    args.state.hotpot.hp +=1
    args.state.player.arrows = args.state.player.quiver
    args.state.player.armor = Players.new().player_data($player_choice).armor + @armor_buff
    spawn_villager('villager')
    event_random = rand(100)
    events(event_random)
    Baddies.new.spawn_baddie
    $my_game.add_bush
    args.state.scene = "gameplay"
    return

  end

  def tick
    if args.inputs.keyboard.key_down.h
      h_bonus
    elsif args.inputs.keyboard.key_down.a
      a_bonus
    elsif args.inputs.keyboard.key_down.p
      p_bonus
    elsif args.inputs.keyboard.key_down.q
      q_bonus
    end
    args.outputs.labels << @labels
  end

  private

  def h_bonus
    2.times.spawn_villager()
    next_level(args)
  end

  def a_bonus
    args.state.player.atk[0] += 1 if $player_choice == 'hero'
    @armor_buff += 2 if $player_choice == 'warrior'
    next_level(args)
  end

  def p_bonus
    args.state.player.maxhp += 5
    next_level(args)
  end

  def q_bonus
    args.state.player.quiver += 3 if $player_choice == 'hero'
    args.state.player.quiver += 1 if $player_choice == 'warrior'
    next_level(args)
  end

  def events(event_random)
    if event_random % 4 == 0
      args.state.walls << $my_game.spawn_tree
      args.state.combat_log << "A new tree has grown at [#{args.state.walls[-1].x}, #{args.state.walls[-1].y}]"
    end
    if event_random % 3 == 0
      target = args.state.walls.sample
      args.state.combat_log << "The Enemies have fired a catapult destroying a #{target.tree_type ? "tree": "wall"}"
      args.state.walls.delete(target)
    end
    if event_random % 5 == 0
      args.state.combat_log << "A pie wagon has arrived, protect it until it reaches the Hot Pot!"
      args.state.goodies << spawn_pie_wagon
    end
    if event_random % 7 == 0 || event_random % 6 == 0
      args.state.combat_log << "A wandering ranger aids your cause"
      args.state.goodies << spawn_ranger
    end
    if event_random % 2 == 0
      args.state.dragon = spawn_dragon
    end
  end

  def spawn_dragon
    size = rand(50).clamp(20, 50)
    {
      x: 0 - rand(20),
      y: rand($gtk.args.grid.h - size),
      w: size,
      h: size,
      path: "sprites/dragon-0.png",
      alive: true,
    }
  end
end