def game_over_tick(args)
    args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
  
    if !args.state.saved_high_score && args.state.score > args.state.high_score
      args.gtk.write_file(HIGH_SCORE_FILE, args.state.score.to_s)
      args.state.saved_high_score = true
    end
    labels = []
    if args.state.score > args.state.high_score
      labels << {
        x: 260,
        y: args.grid.h - 90,
        text: "New high-score!",
        size_enum: 3,
      }
    else
      labels << {
        x: 260,
        y: args.grid.h - 90,
        text: "Score to beat: #{args.state.high_score}",
        size_enum: 3,
      }
    end
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Game Over!",
      size_enum: 10,
    }
    labels << {
      x: 40,
      y: args.grid.h - 90,
      text: "Score: #{args.state.score}",
      size_enum: 4,
    }
    labels << {
      x: 40,
      y: args.grid.h - 132,
      text: "h to restart",
      size_enum: 2,
    }
    args.outputs.labels << labels
  
    if fire_input?(args)
      args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
       args.state.enemies ||= [
    ]

    args.state.budget ||= 5

    args.state.level ||= 1

    args.state.score ||= 0

    if args.state.enemies.empty? && args.state.budget == args.state.level * 5
      spawn_baddie(args)
    end

    args.state.player ||= {
      y: 20,
      x: 29,
      hp: 20,
      atk: 2,
    }
  
    args.state.hotpot ||= {
      y: 20,
      x: 30,
      hp: 20,
      atk: 0,
    }
  
    args.state.walls ||= [
      { x: 19, y: 16, tile_key: :wall },
      { x: 19, y: 17, tile_key: :wall },
      { x: 19, y: 18, tile_key: :wall },
      { x: 19, y: 19, tile_key: :wall },
      { x: 19, y: 20, tile_key: :wall },
    ]
      args.state.scene = "gameplay"
      return
    end
  end