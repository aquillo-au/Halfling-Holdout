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
    elsif $player_choice == 'dwarf'
      dwarf_level(args)
    elsif $player_choice == 'archer'
      archer_level(args)
    elsif $player_choice == 'wizard'
      wizard_level(args)
    end
    @labels << {
      x: 40,
      y: 100,
      text: "Level  Cleared!",
      size_enum: 4,
    }
  end

  
  def tick
    args.outputs.sprites << {
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      a: 175,
      path: 'sprites/level.png'
    }
    args.outputs.sprites << {
      x: args.grid.w - 400,
      y: 10,
      w: 375,
      h: 150,
      path: 'sprites/title.png'
    }
    if args.inputs.keyboard.key_down.h
      h_bonus
    elsif args.inputs.keyboard.key_down.a
      a_bonus
    elsif args.inputs.keyboard.key_down.p
      p_bonus
    elsif args.inputs.keyboard.key_down.q
      q_bonus
    elsif args.inputs.keyboard.key_down.m
      m_bonus
    end
    args.outputs.labels << @labels
  end
  
  private

  def next_level
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
    next_level
  end

  def a_bonus
    case $player_choice
    when 'hero', 'dwarf'
      args.state.player.atk[0] += 1
    when 'archer'
      args.state.player.atk[1] += 1
    when 'wizard'
      spell = args.state.player.spells.keys.sample
      args.state.player.spells[spell] -= 1
      args.state.player.spells[spell] = args.state.player.spells[spell].clamp(1, 10)
    end
    next_level
  end

  def p_bonus
    case $player_choice
    when 'hero', 'dwarf'
      args.state.player.maxhp += 5
    when 'archer', 'wizard'
      args.state.player.maxhp += 3
    end  
    next_level
  end

  def q_bonus
    case $player_choice
    when 'hero'
      args.state.player.quiver += 3
    when 'archer'
      args.state.player.quiver += 5
    when 'dwarf', 'wizard'
      args.state.player.quiver += 1
    end      
    next_level
  end

  def m_bonus
    case $player_choice
    when 'hero'
      args.state.player.maxmana += 1
    when 'archer'
      args.state.player.maxmana += 3
    when 'wizard'
      args.state.player.maxmana += 5
    when 'dwarf'
      @armor_buff += 2
    end
    next_level
  end

  def dwarf_level(args)
    @labels << {
      x: 40,
      y: args.grid.h - 130,
      text: "a for 1 more attack",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "p for 5 more max hit points",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 190,
      text: "q for 1 more arrow slot",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 220,
      text: "m for 2 more armor",
    }
  end

  def wizard_level(args)
    @labels << {
      x: 40,
      y: args.grid.h - 130,
      text: "a for a random spells mana cost to be reduced",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "p for 3 more max hit points",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 190,
      text: "q for 1 more arrow slot",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 220,
      text: "m for 5 more max mana",
    }
  end

  def hero_level(args)
    @labels << {
      x: 40,
      y: args.grid.h - 130,
      text: "a for 1 more attack",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "p for 5 more max hit points",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 190,
      text: "q for a 3 larger quiver",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 220,
      text: "m for 1 more max manna",
    }
  end

  def archer_level(args)
    @labels << {
      x: 40,
      y: args.grid.h - 130,
      text: "a for 1 to max attack",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "p for 3 more max hit points",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 190,
      text: "q for a 5 larger quiver",
    } 
    @labels << {
      x: 40,
      y: args.grid.h - 220,
      text: "m for 3 more max manna",
    }
  end

  def spawn_dragon
    size = rand(50).clamp(20, 50)
    {
      x: 0 - rand(20),
      y: rand(args.grid.h - size) - 100,
      w: size,
      h: size,
      path: "sprites/dragon-0.png",
      alive: true,
    }
  end
end