HIGH_SCORE_FILE = "high-score.txt"
def fire_input?(args)
    args.inputs.keyboard.key_down.h
end

def title_tick args
    args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
    # setup the grid
    if fire_input?(args)
        args.outputs.sounds << "sounds/game-over.wav"
#       args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
        args.state.scene = "gameplay"
        return
    end
    labels = []
    labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Halfling Holdout Version 0.1",
      size_enum: 6,
    }
    labels << {
      x: 40,
      y: args.grid.h - 88,
      text: "by Aquillo",
    }
    labels << {
      x: 40,
      y: args.grid.h - 140,
      text: "Protect the Halfling Hotpot in the center of the Village",
    }
    labels << {
      x: 40,
      y: args.grid.h - 165,
      text: "Each level more Goblins and Rats will attack the village",
    }
    labels << {
      x: 40,
      y: args.grid.h - 190,
      text: "The village also grows in size and you can gain a small powerup",
    }
    labels << {
      x: 40,
      y: args.grid.h - 215,
      text: "You gain 1 point for each kill and each levelup",
    }
    args.outputs.sprites << Game.new.tile_in_game(1, 23, :H)
    labels << {
      x: 50,
      y: 448,
      text: "<-- The Hotpot",
    }
    args.outputs.sprites << Game.new.tile_in_game(1, 20, '@')
    labels << {
      x: 50,
      y: 398,
      text: "<-- You | Your Friends -->",
    }
    args.outputs.sprites << Game.tile_in_game(21, 20, :h)
    args.outputs.sprites << Game.tile_in_game(25, 20, :v)
    labels << {
      x: 325,
      y: 380,
      text: "Guard | Villager",
    }
    args.outputs.sprites << Game.tile_in_game(1, 16, :r)
    args.outputs.sprites << Game.tile_in_game(4, 16, :g)
    labels << {
      x: 125,
      y: 333,
      text: "<-- The Baddies",
    }
    labels << {
      x: 10,
      y: 303,
      text: "Rat | Goblin",
    }
    labels << {
      x: 40,
      y: 120,
      text: "Arrows to move | ASDW to fire an arrow | Mouse Over to inspect (coming soon) | gamepad works too",
    }
    labels << {
      x: 40,
      y: 80,
      text: "h to start",
      size_enum: 2,
    }
    args.outputs.labels << labels
  end