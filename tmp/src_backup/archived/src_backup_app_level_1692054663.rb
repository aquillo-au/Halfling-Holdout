def next_level(args)
    args.state.score += 1
    args.state.info_message = nil
    args.state.level += 1
    args.state.budget = args.state.level * 5
    args.state.player.hp += 5
    args.state.player.hp.clamp(1, 20 + args.state.level)
    args.state.hotpot.hp +=1
    args.state.scene = "gameplay"
    return    
end

def level_tick args
    labels = []
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Choose your Power Up",
      size_enum: 6,
    }
    labels << {
      x: 40,
      y: args.grid.h - 88,
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