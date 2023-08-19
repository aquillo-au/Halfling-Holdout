class Title
  attr_gtk
  def initialize(args)

    @page = "character"
    @labels = []
    input_string ||= args.gtk.read_file(HIGH_SCORE_FILE)
    args.state.high_scores = input_string.lines.map do |line|
      name, score_str, character = line.strip.split(' ^ ')
      { name: name, score: score_str.to_i, character: character }
    end
    args.state.high_scores = args.state.high_scores.sort_by { |hash| -hash[:score] }
  end

  def tick
    @labels = []
    
    # setup the grid
    if args.inputs.keyboard.key_down.i
      @page = 'instruction'
    elsif args.inputs.keyboard.key_down.c
      @page = 'character'
    elsif args.inputs.keyboard.key_down.s
      @page = 'scores'
    end
    if @page == 'character'
      character_page 
    elsif @page == 'instruction'
      instruction_page 
    elsif @page == 'scores'
      score_page
    end
    @labels << {
      x: 40,
      y: args.grid.h - 40,
      text: "Halfling Holdout Version 0.5",
      size_enum: 6,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 88,
      text: "by Aquillo",
    }
    @labels << {
      x: 20,
      y: 88,
      text: "Press i for instructions | c for character list | s for high scores",
    }
    args.outputs.labels << @labels

  end

  private

  def character_page
    if args.inputs.keyboard.key_down.h
      $player_choice = 'hero'
      args.outputs.sounds << "sounds/game-over.wav"
#     args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
      $level = Level.new(args)
      $my_game = Game.new(args) 
      args.state.scene = "gameplay"
      return
    end
    if args.inputs.keyboard.key_down.w
      $player_choice = 'warrior'
      args.outputs.sounds << "sounds/game-over.wav"
#     args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
      $level = Level.new(args)
      $my_game = Game.new(args) 
      args.state.scene = "gameplay"
      return
    end
    if args.inputs.keyboard.key_down.a
      $player_choice = 'archer'
      args.outputs.sounds << "sounds/game-over.wav"
      #     args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
      $level = Level.new(args)
      $my_game = Game.new(args)
      args.state.scene = "gameplay"
      return
    end
    @labels << {
      x: 0,
      y: 280,
      text: "Press:",
      size_enum: 3,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 110,
      text: "#{$name} you must choose your class",
    }
    @labels << {
      x: 100,
      y: 550,
      text: "The Hero is a good all rounder",
    }
    @labels << {
      x: 100,
      y: 525,
      text: "Its a great choice for 1st timers",
    }
    @labels << {
      x: 100,
      y: 500,
      text: "But isn't very good at magic",
    }
    @labels << {
      x: 125,
      y: 280,
      text: "h to Select the Hero",
      size_enum: 3,
    }
    args.outputs.sprites << { x: 225, y: 311, w: 150, h: 150, path: 'sprites/hero.png' }
    @labels << {
      x: 500,
      y: 550,
      text: "The warrior is strong and powerful",
    }
    @labels << {
      x: 500,
      y: 525,
      text: "You have more Armor and Hit points",
    }
    @labels << {
      x: 500,
      y: 500,
      text: "But is slow and poor at range",
    }
    @labels << {
      x: 525,
      y: 280,
      text: "w to Select the Warrior",
      size_enum: 3,
    }
    args.outputs.sprites << { x: 550, y: 250, w: 250, h: 250, path: 'sprites/dwarf.png' }
    @labels << {
      x: 900,
      y: 550,
      text: "The Archer is quick",
    }
    @labels << {
      x: 900,
      y: 525,
      text: "Low armor and Hit Points",
    }
    @labels << {
      x: 900,
      y: 500,
      text: "But can kill from afar",
    }
    @labels << {
      x: 925,
      y: 280,
      text: "a to Select the Archer",
      size_enum: 3,
    }
    args.outputs.sprites << { x: 950, y: 275, w: 155, h: 180, path: 'sprites/ranger.png' }
  end

  def instruction_page
    @labels << {
      x: 40,
      y: args.grid.h - 140,
      text: "Protect the Halfling Hotpot in the center of the Village",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 165,
      text: "Each level more Goblins and Rats will attack the village",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 190,
      text: "The village also grows in size and you can gain a small powerup",
    }
    @labels << {
      x: 40,
      y: args.grid.h - 215,
      text: "You gain points for each kill and each levelup",
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 23 * DESTINATION_TILE_SIZE,:H)
    @labels << {
      x: 50,
      y: 448,
      text: "<-- The Hotpot",
    }
    @labels << {
      x: 50,
      y: 398,
      text: "Your Friends -->",
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 21 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:h)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 26 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:v)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 32 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:c)
    @labels << {
      x: 325,
      y: 380,
      text: "Guard | Villager | Cook",
    }
    @labels << {
      x: 490,
      y: 360,
      text: "(healer)",
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:r)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 5 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:g)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 9.5 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:n)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 14 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:s)
    @labels << {
      x: 275,
      y: 315,
      text: "<-- The Baddies",
    }
    @labels << {
      x: 10,
      y: 293,
      text: "Rat | Goblin | Orc | Shaman",
    }
    @labels << {
      x: 205,
      y: 275,
      text: "(healer)",
    }
    @labels << {
      x: 40,
      y: 120,
      text: "Arrows to move or attack, space to wait | ASDW to fire an arrow | Mouse Over to inspect",
    }
  end

  def score_page
    @labels << {
      x: 585,
      y: 600,
      text: "High-scores!",
      size_enum: 3,
    }
    args.state.high_scores.each_with_index do |score, index|
      args.outputs.labels << [560, (570 - (index*25)) , "#{score.name} with #{score.score} as the #{score.character}",]
    end
  end
end