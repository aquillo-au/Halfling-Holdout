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
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 23 * DESTINATION_TILE_SIZE,:H)
    labels << {
      x: 50,
      y: 448,
      text: "<-- The Hotpot",
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,'@')
    labels << {
      x: 50,
      y: 398,
      text: "<-- You | Your Friends -->",
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 21 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:h)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 26 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:v)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 32 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:c)
    labels << {
      x: 325,
      y: 380,
      text: "Guard | Villager | Cook",
    }
    labels << {
      x: 490,
      y: 360,
      text: "(healer)",
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:r)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 4 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:g)
    labels << {
      x: 225,
      y: 313,
      text: "<-- The Baddies",
    }
    labels << {
      x: 10,
      y: 293,
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