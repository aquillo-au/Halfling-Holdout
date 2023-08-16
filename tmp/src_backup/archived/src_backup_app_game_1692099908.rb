class Game
  attr_gtk
  def initialize(args)
    args.state.info_message = "Welcome to Level #{args.state.level}."
    args.state.budget = 5
    args.state.enemies = []
    Baddies.new.spawn_baddie
    args.state.arrows = []
    args.state.level = 1
    args.state.score = 0
    args.state.combat_log = []
    args.state.player = {
      y: 20,
      x: 28,
      hp: 20,
      maxhp: 20,
      atk: 2,
      arrows: 5,
      quiver: 5,
      type: "You"
    }

    args.state.hotpot = {
      y: 20,
      x: 29,
      hp: 20,
      atk: 0,
    }

    args.state.walls = [
      { x: 21, y: 14, tile_key: :secorn },

      { x: 21, y: 15, tile_key: :wall },
      { x: 21, y: 16, tile_key: :wall },
      { x: 21, y: 17, tile_key: :wall },

      { x: 21, y: 24, tile_key: :wall },
      { x: 21, y: 25, tile_key: :wall },
      { x: 21, y: 26, tile_key: :wall },

      { x: 21, y: 27, tile_key: :necorn },

      { x: 22, y: 27, tile_key: :hwall },
      { x: 23, y: 27, tile_key: :hwall },
      { x: 24, y: 27, tile_key: :hwall },
      { x: 25, y: 27, tile_key: :hwall },

      { x: 32, y: 27, tile_key: :hwall },
      { x: 33, y: 27, tile_key: :hwall },
      { x: 34, y: 27, tile_key: :hwall },
      { x: 35, y: 27, tile_key: :hwall },

      { x: 36, y: 27, tile_key: :nwcorn },

      { x: 36, y: 26, tile_key: :wall },
      { x: 36, y: 25, tile_key: :wall },
      { x: 36, y: 24, tile_key: :wall },

      { x: 36, y: 17, tile_key: :wall },
      { x: 36, y: 16, tile_key: :wall },
      { x: 36, y: 15, tile_key: :wall },

      { x: 36, y: 14, tile_key: :swcorn },

      { x: 35, y: 14, tile_key: :hwall },
      { x: 34, y: 14, tile_key: :hwall },
      { x: 33, y: 14, tile_key: :hwall },
      { x: 32, y: 14, tile_key: :hwall },

      { x: 22, y: 14, tile_key: :hwall },
      { x: 23, y: 14, tile_key: :hwall },
      { x: 24, y: 14, tile_key: :hwall },
      { x: 25, y: 14, tile_key: :hwall },

      #trees are walls
      spawn_tree,
      spawn_tree,
      spawn_tree,
      spawn_tree,
      spawn_tree,
      spawn_tree,
      spawn_tree,
      spawn_tree,
    ]
    args.state.goodies = [
      { x: 26, y: 13, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 31, y: 13, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 37, y: 18, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 37, y: 23, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 31, y: 28, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 26, y: 28, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 20, y: 18, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 20, y: 23, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk},
      { x: 30, y: 20, type: GOODIES[:cook].name, tile_key: GOODIES[:cook].tile_key, hp: GOODIES[:cook].hp, atk: GOODIES[:cook].atk},
    ]
    args.state.clouds = [
      spawn_cloud('start'),
      spawn_cloud('start'),
      spawn_cloud('start'),
      spawn_cloud('start'),
      spawn_cloud('start'),
      spawn_cloud('start'),
      spawn_cloud('start'),
    ]
  end

  def tick
    
    @allies = [args.state.player, args.state.hotpot]
    args.state.goodies.each { |villager| @allies << villager }
  
    # handle keyboard input
    handle_input(args)
  

    #handle game logic
    # determine if there is an enemy on that square,
    # if so, don't let the player move there
    if @player_moved
      game_turn(args)
    end
  
    check_arrows(args)
    args.state.enemies.reject! { |e| e.dead }
    if args.state.player.dead || args.state.hotpot.dead
        #args.audio[:music].paused = true
        args.outputs.sounds << "sounds/game-over.wav"
        args.state.scene = "game_over"
      end
  
    args.state.clouds.each do |cloud|
      cloud.x -= 0.25
      if cloud.x < 0
        cloud.dead = true
        next
      end
    end   
    args.state.clouds.reject! { |c| c.dead }
    if args.state.clouds.size < 6
      args.state.clouds << spawn_cloud(args)
    end
    # render game
    args.outputs.sprites << tile_in_game(args.state.player.x, args.state.player.y, '@')
    args.outputs.sprites << tile_in_game(args.state.hotpot.x, args.state.hotpot.y, :H)
  
    # render the arrows
    args.outputs.sprites << args.state.arrows.map do |a|
      tile_in_game(a[:x], a[:y], a[:tile_key])
    end    
    # render enemies at locations
    args.outputs.sprites << args.state.enemies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key])
    end
    #render the village
    args.outputs.sprites << args.state.goodies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key])
    end
    # render walls at locations
    args.outputs.sprites << args.state.walls.map do |w|
      tile_in_game(w[:x], w[:y], w[:tile_key])
    end
    args.outputs.sprites << args.state.clouds
  
    # render the border
    border_x = PADDING_X - DESTINATION_TILE_SIZE
    border_y = PADDING_Y - DESTINATION_TILE_SIZE
    border_size = SIZE + DESTINATION_TILE_SIZE + 1
  
    args.outputs.borders << [border_x + DESTINATION_TILE_SIZE,
                             border_y + DESTINATION_TILE_SIZE,
                             border_size + 250,
                             border_size]
  
    if args.state.enemies.empty?
      args.outputs.sounds << "sounds/game-over.wav"
      args.state.scene = "level"
    end

    # render label stuff
    args.outputs.labels << [border_x + 10, border_y - 10, "You have #{args.state.player.hp}/#{args.state.player.maxhp}HP left | #{args.state.player.arrows}/#{args.state.player.quiver} arrows and an attack of #{args.state.player.atk}"]
    args.outputs.labels << [border_x + 10, border_y + 35 + border_size, args.state.info_message]
    args.state.combat_log = args.state.combat_log.flatten.last(10)
    args.state.combat_log.each_with_index do |log, index|
      args.outputs.labels << [885, (670 - (index*20)) , "#{log}", 0.1,]
    end
    args.outputs.labels << [border_x + 600, border_y + 35 + border_size, "The hotpot has #{args.state.hotpot.hp} hps left"]
    args.outputs.solids << {
      x: PADDING_X,
      y: PADDING_Y,
      w: SIZE + 250 + SOURCE_TILE_SIZE,
      h: SIZE + SOURCE_TILE_SIZE,
      r: 55,
      g: 60,
      b: 25,
      a: 175,
    }
    args.outputs.solids << {
      x: PADDING_X + SOURCE_TILE_SIZE * 18,
      y: PADDING_Y + SOURCE_TILE_SIZE * 10,
      w: SOURCE_TILE_SIZE * 22,
      h: SOURCE_TILE_SIZE * 21,
      r: 100,
      g: 150,
      b: 0,
    }
  end
  
  def handle_input(args)
    @new_player_x = args.state.player.x
    @new_player_y = args.state.player.y
    @player_moved = false
    if args.inputs.keyboard.key_down.up
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      @new_player_y += 1
      @player_direction = "north"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.down
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      @new_player_y -= 1
      @player_direction = "south"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.right
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      @new_player_x += 1
      @player_direction = "east"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.left
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      @new_player_x -= 1
      @player_direction = "west"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.s
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      if args.state.player.arrows > 0
        args.state.arrows << {
          x: args.state.player.x,
          y: args.state.player.y - 1,
          tile_key: :sarrow,
          direction: 's' #down
        }
        @player_moved = true
        args.state.player.arrows -= 1
      end
    elsif args.inputs.keyboard.key_down.a
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      if args.state.player.arrows > 0
        args.state.arrows << {
          x: args.state.player.x - 1,
          y: args.state.player.y,
          tile_key: :aarrow,
          direction: 'a' #left
        }
        @player_moved = true
        args.state.player.arrows -= 1
      end
    elsif args.inputs.keyboard.key_down.w
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      if args.state.player.arrows > 0
        args.state.arrows << {
          x: args.state.player.x,
          y: args.state.player.y + 1,
          tile_key: :warrow,
          direction: 'w' #down
        }
        @player_moved = true
        args.state.player.arrows -= 1
      end
    elsif args.inputs.keyboard.key_down.d
      args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
      if args.state.player.arrows > 0
        args.state.arrows << {
          x: args.state.player.x + 1,
          y: args.state.player.y,
          tile_key: :darrow,
          direction: 'd' #down
        }
        @player_moved = true
        args.state.player.arrows -= 1
      end
    end
  end

  def game_turn(args)
    found_enemy = args.state.enemies.find do |e|
      e[:x] == @new_player_x && e[:y] == @new_player_y
    end
    found_wall = args.state.walls.find do |w|
      w[:x] == @new_player_x && w[:y] == @new_player_y
    end
    blocking_friend = @allies.find do |a|
      a[:x] == @new_player_x && a[:y] == @new_player_y
    end
    if still_in_map?(@new_player_x, @new_player_y)
      if !found_enemy && !found_wall
        args.state.player.x = @new_player_x
        args.state.player.y = @new_player_y
        message = "You moved #{@player_direction}."
      elsif found_enemy
        message = your_combat(args.state.player, found_enemy)
        args.state.score += 1 if found_enemy.dead
        args.state.enemies.reject! { |e| e.dead }
      else
        message = "You can't move through walls!"
      end
      args.state.info_message = message
    end
    args.state.goodies.each do |goody|
      if goody.type != 'Cook'
        target_distances = args.state.enemies.map { |enemy| [enemy, proximity_to_target(goody, enemy)] }
      else
        target_distances = args.state.goodies.map { |good| [good, proximity_to_target(goody, enemy)] }
      end
      nearest_target, min_distance = target_distances.min_by { |_, distance| distance }
      if min_distance && min_distance < 3
        new_spot = BasicPath.new(goody, nearest_target, args.state.walls).move_step
      else
        new_spot = BasicPath.new(goody, goody, args.state.walls).random_direction
      end
      blocking_friend = @allies.find do |a|
        a[:x] == new_spot.x && a[:y] == new_spot.y
      end
      blocking_opponent = args.state.enemies.find do |e|
        e[:x] == new_spot.x && e[:y] == new_spot.y
      end
      found_wall = args.state.walls.find do |w|
        w[:x] == new_spot.x && w[:y] == new_spot.y
      end
      if blocking_friend
        #don't move unless healer
        if goody.type == 'Cook'
      elsif found_wall
        #don't move
      elsif blocking_opponent
        args.state.combat_log << other_combat(goody, blocking_opponent)
        args.state.enemies.reject! { |e| e.dead }
        args.state.goodies.reject! { |e| e.dead }
      else
        goody.x = new_spot.x unless !(in_village?(new_spot))
        goody.y = new_spot.y unless !(in_village?(new_spot))
      end
    end 

    args.state.enemies.each do |enemy|
      ally_distances = @allies.map { |ally| [ally, proximity_to_target(enemy, ally)] }
      nearest_target, min_distance = ally_distances.min_by { |_, distance| distance } 
      new_spot = BasicPath.new(enemy, nearest_target, args.state.walls).move_step
      blocking_friend = args.state.enemies.find do |e|
        e[:x] == new_spot.x && e[:y] == new_spot.y
      end
      blocking_opponent = args.state.goodies.find do |g|
        g[:x] == new_spot.x && g[:y] == new_spot.y
      end
      if args.state.player.x == new_spot.x && args.state.player.y == new_spot.y
        args.state.combat_log << other_combat(enemy, args.state.player)
      elsif blocking_friend
        #don't move
      elsif args.state.hotpot.x == new_spot.x && args.state.hotpot.y == new_spot.y
        args.state.combat_log << other_combat(enemy, args.state.hotpot)
      elsif blocking_opponent
        args.state.combat_log << other_combat(enemy, blocking_opponent)
      else
        enemy.x = new_spot.x
        enemy.y = new_spot.y
      end
    end
    Baddies.new.spawn_baddie
  end

  def tile_in_game(x, y, tile_key)
    SpriteGrid.new.tile(PADDING_X + x * DESTINATION_TILE_SIZE,
         PADDING_Y + y * DESTINATION_TILE_SIZE,
         tile_key)
  end
  
  def proximity_to_target(me, target)
    (me.x - target.x).abs + (me.y - target.y).abs
  end

  def still_in_map?(x, y)
    x > -1 && x < WIDTH + 1 && y > -1 && y < HEIGHT
  end

  def in_village?(me)
    me.x > 17 && me.x < 40 && me.y > 9 && me.y < 31 
  end

  def arrow_flight(arrows)
    arrows.each do |arrow|
      case arrow.direction
        when "s"
          arrow.y -= 1
        when "w"
          arrow.y += 1
        when "d"
          arrow.x += 1
        when "a"
          arrow.x -= 1
      end
    end
  end

  def check_arrows(args)
    args.state.arrows.each do |arrow|
      #check if they run into a friend
      blocking_friend = @allies.find do |a|
        a[:x] == arrow.x && a[:y] == arrow.y
      end
      found_wall = args.state.walls.find do |w|
        w[:x] == arrow.x && w[:y] == arrow.y
      end 
      blocking_opponent = args.state.enemies.find do |e|
        e[:x] == arrow.x && e[:y] == arrow.y
      end
      if blocking_friend || found_wall || !still_in_map?(arrow.x, arrow.y)
        arrow.dead = true
      elsif blocking_opponent
        args.state.combat_log << your_arrow(blocking_opponent)
        arrow.dead = true
      end
    end
    args.state.arrows.reject! { |arrow| arrow.dead }
  end

  def spawn_cloud(start = false)
    size = rand(50).clamp(20, 50)
    if start
      x_spot = rand(SIZE + size * 3) 
    else
      x_spot = (SIZE + DESTINATION_TILE_SIZE + 251)
    end
    sprite = 'sprites/cloud.png'
    if $gtk.args.state.tick_count % 3 == 0
      sprite = 'sprites/cloud_2.png'
    elsif $gtk.args.state.tick_count % 4 == 0
      sprite = 'sprites/cloud_3.png'
    end
    {
      x: x_spot,
      y: rand($gtk.args.grid.h - size),
      w: size,
      h: size,
      path: sprite,
    }
  end

  def spawn_tree
    tree = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: :tree }
    until !in_village?(tree) do
      tree = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: :tree }
    end
    tree
  end
end


