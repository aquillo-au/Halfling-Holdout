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
      hero_level(args)
    elsif $player_choice == 'warrior'
      warrior_level(args)
    elsif $player_choice == 'archer'
      archer_level(args)
    end
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

  def next_level(args)
    # args.state.combat_log = []
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
    spawn_dragon if args.state.tick_count % 2 == 0
    Baddies.new.spawn_baddie
    $my_game.add_bush
    args.state.scene = "gameplay"
    return
  end
  
  def h_bonus
    2.times.spawn_villager()
    next_level(args)
  end

  def a_bonus
    args.state.player.atk[0] += 1 if $player_choice == 'hero'
    args.state.player.atk[1] += 1 if $player_choice == 'archer'
    @armor_buff += 2 if $player_choice == 'warrior'
    next_level(args)
  end

  def p_bonus
    args.state.player.maxhp += 5 unless $player_choice == 'archer'
    args.state.player.maxhp += 3 if $player_choice == 'archer'
    next_level(args)
  end

  def q_bonus
    args.state.player.quiver += 5 if $player_choice == 'archer'
    args.state.player.quiver += 3 if $player_choice == 'hero'
    args.state.player.quiver += 1 if $player_choice == 'warrior'
    next_level(args)
  end

  def warrior_level(args)
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

  def hero_level(args)
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
  end

  def archer_level(args)
    @labels << {
      x: 40,
      y: args.grid.h - 120,
      text: "a for 1 to max attack",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 140,
      text: "p for 3 more max hit points",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "q for a 5 larger quiver",
    } 
  end

  def spawn_dragon
    size = rand(50).clamp(20, 50)
    {
      x: 0 - rand(20),
      y: rand($gtk.args.grid.h - size) - 100,
      w: size,
      h: size,
      path: "sprites/dragon-0.png",
      alive: true,
    }
  end
end