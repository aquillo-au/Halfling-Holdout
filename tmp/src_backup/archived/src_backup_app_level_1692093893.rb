class Level
  def next_level(args)
    args.state.score += 1
    args.state.info_message = nil
    args.state.level += 1
    args.state.budget = args.state.level * 5
    args.state.player.hp += 5
    args.state.player.hp.clamp(1, args.state.player.maxhp)
    args.state.hotpot.hp +=1
    spawn_villager('villager')
    args.state.scene = "gameplay"
    return 

  end

  def tick(args)
    labels = []
    if args.inputs.keyboard.key_down.h
        2.times.spawn_villager()
        next_level(args)
    elsif args.inputs.keyboard.key_down.a
        args.state.player.atk += 1
        next_level(args)
    elsif args.inputs.keyboard.key_down.p
        args.state.player.maxhp += 5
        next_level(args)
    end

    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Choose your Power Up",
      size_enum: 6,
    }
    labels << {
      x: 40,
      y: args.grid.h - 100,
      text: "h for 2 new villagers",
    }
    labels << {
      x: 40,
      y: args.grid.h - 120,
      text: "a for more attack",
    }
    labels << {
      x: 40,
      y: args.grid.h - 140,
      text: "p for more hit points",
    }
    args.outputs.labels << labels
  end

end