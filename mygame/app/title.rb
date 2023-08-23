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
    if args.inputs.keyboard.key_down.m
      if args.audio[:music].paused
        args.audio[:music].paused = false
      else
        args.audio[:music].paused = true
      end
    end
    @labels = []
    args.outputs.sprites << {
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      a: 115,
      path: 'sprites/background.png'
    }
    args.outputs.sprites << {
      x: 40,
      y: args.grid.h - 125,
      w: 605,
      h: 125,
      path: 'sprites/title.png'
    }
    @labels << {
      x: 653,
      y: args.grid.h - 70,
      text: "Version #{VERSION}",
      size_enum: 2,
    }
    @labels << {
      x: 653,
      y: args.grid.h - 40,
      text: "by Aquillo",
      size_enum: -2,
    }
    
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
      x: 20,
      y: 90,
      text: "Press: i for instructions",
      size_enum: -5,
    }
    @labels << {
      x: 93,
      y: 65,
      text: "c for character list",
      size_enum: -5,
    }
    @labels << {
      x: 93,
      y: 40,
      text: "s for high scores",
      size_enum: -5,
    }
    @labels << {
      x: 93,
      y: 15,
      text: "m to turn the music on/off",
      size_enum: -5,
    }
    @labels << {
      x: args.grid.w,
      y: 60,
      text: "Music: Forest Walk & The Great Battle by Alexander Nakarada (www.serpentsoundstudios.com)",
      size_enum: -8,
      alignment_enum: 2,
    }
    @labels << {
      x: args.grid.w,
      y: 40,
      size_enum: -8,
      alignment_enum: 2,
      text: "Licensed under Creative Commons: By Attribution 4.0 License"
    }
    
    args.outputs.labels << @labels

  end

  private

#  by Alexander Nakarada | https://www.serpentsoundstudios.com
# Music promoted by https://www.chosic.com/free-music/all/
# Attribution 4.0 International (CC BY 4.0)
# https://creativecommons.org/licenses/by/4.0/
  def character_page
    if args.inputs.keyboard.key_down.h
      $player_choice = 'hero'
      start_game
    end
    if args.inputs.keyboard.key_down.d
      $player_choice = 'dwarf'
      start_game
    end
    if args.inputs.keyboard.key_down.a
      $player_choice = 'archer'
      start_game
    end
    if args.inputs.keyboard.key_down.w
      $player_choice = 'wizard'
      start_game
    end
    @labels << {
      x: args.grid.w/2,
      y: args.grid.h - 125,
      alignment_enum: 1,
      text: "#{$name} you must choose your class",
      size_enum: -1,
    }
    @labels << {
      x: 50,
      y: 550,
      text: "The Hero is a good all rounder",
      size_enum: -6,
    }
    @labels << {
      x: 50,
      y: 525,
      text: "It's a great 1st choice",
      size_enum: -6,
    }
    @labels << {
      x: 50,
      y: 500,
      text: "But isn't very good at magic",
      size_enum: -6,
    }
    @labels << {
      x: 50,
      y: 270,
      text: "h to Select the Hero",
      size_enum: -6,
    }
    args.outputs.sprites << { x: 75, y: 311, w: 150, h: 150, path: 'sprites/hero.png' }
    @labels << {
      x: 625,
      y: 550,
      text: "The Dwarf is strong and powerful",
      size_enum: -6,
    }
    @labels << {
      x: 625,
      y: 525,
      text: "You have more Armor and Hit points",
      size_enum: -6,
    }
    @labels << {
      x: 625,
      y: 500,
      text: "But is slow and poor at range",
      size_enum: -6,
    }
    @labels << {
      x: 650,
      y: 270,
      text: "d to Select the Dwarf",
      size_enum: -6,
    }
    args.outputs.sprites << { x: 650, y: 250, w: 250, h: 250, path: 'sprites/dwarf.png' }
    @labels << {
      x: 375,
      y: 550,
      text: "The Wizard is magical",
      size_enum: -6,
    }
    @labels << {
      x: 375,
      y: 525,
      text: "many spells and tricks",
      size_enum: -6,
    }
    @labels << {
      x: 375,
      y: 500,
      text: "but poor in combat",
      size_enum: -6,
    }
    @labels << {
      x: 375,
      y: 270,
      text: "w to Select the Wizard",
      size_enum: -6,
    }
    args.outputs.sprites << { x: 375, y: 290, w: 155, h: 175, path: 'sprites/wizard.png' }
    @labels << {
      x: 1000,
      y: 550,
      text: "The Archer is quick",
      size_enum: -6,
    }
    @labels << {
      x: 1000,
      y: 525,
      text: "Low armor and Hit Points",
      size_enum: -6,
    }
    @labels << {
      x: 1000,
      y: 500,
      text: "But can kill from afar",
      size_enum: -6,
    }
    @labels << {
      x: 1000,
      y: 270,
      text: "a to Select the Archer",
      size_enum: -5,
    }
    args.outputs.sprites << { x: 1000, y: 275, w: 155, h: 180, path: 'sprites/ranger.png' }
  end

  def instruction_page
    @labels << {
      x: 40,
      y: args.grid.h - 160,
      text: "Protect the Halfling Hotpot in the center of the Village",
      size_enum: -5,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 185,
      text: "Each level more baddies will attack the village",
      size_enum: -5,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 210,
      text: "The village also grows in size and you can gain a small powerup",
      size_enum: -5,
    }
    @labels << {
      x: 40,
      y: args.grid.h - 235,
      text: "You gain points for each kill and each levelup",
      size_enum: -5,
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 23 * DESTINATION_TILE_SIZE,:H)
    @labels << {
      x: 50,
      y: 443,
      text: "<-- The Hotpot",
      size_enum: -5,
    }
    @labels << {
      x: 100,
      y: 394,
      text: "Your Friends -->",
      size_enum: -5,
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 21 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:h)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 26 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:v)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 32 * DESTINATION_TILE_SIZE, PADDING_Y + 20 * DESTINATION_TILE_SIZE,:c)
    @labels << {
      x: 325,
      y: 380,
      text: "Guard | Villager | Cook",
      size_enum: -5,
    }
    @labels << {
      x: 490,
      y: 360,
      text: "(healer)",
      size_enum: -5,
    }
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 1 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:r)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 5 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:g)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 9.5 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:n)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 14 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:s)
    args.outputs.sprites << SpriteGrid.new.tile(PADDING_X + 19 * DESTINATION_TILE_SIZE, PADDING_Y + 15 * DESTINATION_TILE_SIZE,:f)
    @labels << {
      x: 405,
      y: 315,
      text: "<-- The Baddies",
      size_enum: -5,
    }
    @labels << {
      x: 10,
      y: 293,
      text: "Rat | Goblin | Orc | Shaman | Bowman",
      size_enum: -5,
    }
    @labels << {
      x: 193,
      y: 275,
      text: "(healer)",
      size_enum: -5,
    }
    @labels << {
      x: args.grid.w - 550,
      y: 520,
      text: "Arrows to move or attack",
      size_enum: -5,
    }
    @labels << {
      x: args.grid.w - 550,
      y: 500,
      text: "space to wait",
      size_enum: -5,
    }
    @labels << {
      x: args.grid.w - 550,
      y: 480,
      text: "ASDW to fire an arrow",
      size_enum: -5,
    }
    @labels << {
      x: args.grid.w - 550,
      y: 460,
      text: "Click on an enemy to strike with lightning (5 mana)",
      size_enum: -5,
    }
    @labels << {
      x: args.grid.w - 550,
      y: 440,
      text: "Mouse Over to inspect/see stats",
      size_enum: -5,
    }
  end

  def score_page
    @labels << {
      x: args.grid.w/2 - 100,
      y: 550,
      text: "High Scores!",
      size_enum: 3,
    }
    args.state.high_scores.each_with_index do |score, index|
      args.outputs.labels << [555, (515 - (index*25)) , "#{score.name} with #{score.score} as the #{score.character}",-5]
    end
  end

  def start_game
    args.outputs.sounds << "sounds/click.wav"
    args.audio[:music] = { input: "sounds/thegreatbattle.ogg", looping: true }
    $level = Level.new(args)
    $my_game = Game.new(args)
    args.state.scene = "gameplay"
    return
  end
end