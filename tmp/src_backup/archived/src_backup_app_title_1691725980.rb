HIGH_SCORE_FILE = "high-score.txt"
def title_tick args
    args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
    # if fire_input?(args)
    #   args.outputs.sounds << "sounds/game-over.wav"
    #   args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
    #   args.state.scene = "gameplay"
    #   return
    # end

  
    labels = []
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Halfling Holdout",
      size_enum: 6,
    }
    labels << {
      x: 40,
      y: args.grid.h - 88,
      text: "Protect the Halfling Village",
    }
    labels << {
      x: 40,
      y: args.grid.h - 120,
      text: "by Aquillo",
    }
    labels << {
      x: 40,
      y: 120,
      text: "Arrows to move | Mouse Over to inspect | gamepad works too",
    }
    labels << {
      x: 40,
      y: 80,
      text: "Fire to start",
      size_enum: 2,
    }
    args.outputs.labels << labels
  end