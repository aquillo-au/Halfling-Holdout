HIGH_SCORE_FILE = "high-score.txt"
def fire_input?(args)
    args.inputs.keyboard.key_down.h
end

def title_tick args
    args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
    # setup the grid
    args.state.grid.padding_x = 40
    args.state.grid.padding_y = 60
    args.state.grid.size = 602
    args.state.grid.width = 53
    args.state.grid.height = 38
    if fire_input?(args)
        args.outputs.sounds << "sounds/game-over.wav"
#       args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
        args.state.scene = "gameplay"
        return
    end
    args.state.clouds ||= [
      spawn_cloud(args),
      spawn_cloud(args),
      spawn_cloud(args),
      spawn_cloud(args),
      spawn_cloud(args),
      spawn_cloud(args),
      spawn_cloud(args),
    ]
  
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
      text: "h to start",
      size_enum: 2,
    }
    args.outputs.labels << labels
  end