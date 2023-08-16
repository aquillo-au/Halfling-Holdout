def gameplay_tick(args)
    # setup the grid
    args.state.grid.padding_x = 40
    args.state.grid.padding_y = 60
    args.state.grid.size = 602
    args.state.grid.width = 61
    args.state.grid.height = 43
  
    # set up your game
    # initialize the game/game defaults. ||= means that you only initialize it if
    # the value isn't alread initialized
  
    args.state.enemies ||= [
    ]

    args.state.budget ||= 5

    args.state.level ||= 1

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
  
    allies = [args.state.player, args.state.hotpot]
  
    args.state.info_message ||= "Yay a game"
  
    # handle keyboard input
    # keyboard input (arrow keys to move player)
    new_player_x = args.state.player.x
    new_player_y = args.state.player.y
    player_direction = ""
    player_moved = false
    if args.inputs.keyboard.key_down.up
      new_player_y += 1
      player_direction = "north"
      player_moved = true
    elsif args.inputs.keyboard.key_down.down
      new_player_y -= 1
      player_direction = "south"
      player_moved = true
    elsif args.inputs.keyboard.key_down.right
      new_player_x += 1
      player_direction = "east"
      player_moved = true
    elsif args.inputs.keyboard.key_down.left
      new_player_x -= 1
      player_direction = "west"
      player_moved = true
    end
  
    #handle game logic
    # determine if there is an enemy on that square,
    # if so, don't let the player move there
    if player_moved
      found_enemy = args.state.enemies.find do |e|
        e[:x] == new_player_x && e[:y] == new_player_y
      end
      found_wall = args.state.walls.find do |w|
        w[:x] == new_player_x && w[:y] == new_player_y
      end
      if still_in_map?(new_player_x, new_player_y)
        if !found_enemy && !found_wall
          args.state.player.x = new_player_x
          args.state.player.y = new_player_y
          message = "You moved #{player_direction}."
        elsif found_enemy
          message = combat(args.state.player, found_enemy)
          args.state.enemies.reject! { |e| e.dead }
        else
          message = "You can't move through walls!"
        end
        args.state.info_message = message
      end
      args.state.enemies.each do |enemy|
        ally_distances = allies.map { |ally| [ally, proximity_to_target(enemy, ally)] }
        nearest_target, min_distance = ally_distances.min_by { |_, distance| distance } 
        new_spot = BasicPath.new(enemy, nearest_target, args.state.walls).move_step
        blocking_friend = args.state.enemies.find do |e|
          e[:x] == new_spot.x && e[:y] == new_spot.y
        end
        if args.state.player.x == new_spot.x && args.state.player.y == new_spot.y
          #do some combat?
        elsif blocking_friend
          #don't move
        elsif args.state.hotpot.x == new_spot.x && args.state.hotpot.y == new_spot.y
          combat(enemy, args.state.hotpot)
        else
          enemy.x = new_spot.x
          enemy.y = new_spot.y
        end
      end
      spawn_baddie(args)
    end
  
    args.state.enemies.reject! { |e| e.dead }
    if args.state.player.dead || args.state.hotpot.dead
        #args.audio[:music].paused = true
        args.outputs.sounds << "sounds/game-over.wav"
        args.state.scene = "game_over"
      end
  
    args.outputs.sprites << tile_in_game(args.state.player.x, args.state.player.y, '@')
    args.outputs.sprites << tile_in_game(args.state.hotpot.x, args.state.hotpot.y, :H)
  
    # render game
    # render enemies at locations
    args.outputs.sprites << args.state.enemies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key])
    end
    # render walls at locations
    args.outputs.sprites << args.state.walls.map do |w|
      tile_in_game(w[:x], w[:y], w[:tile_key])
    end
  
    # render the border
    border_x = args.state.grid.padding_x - DESTINATION_TILE_SIZE
    border_y = args.state.grid.padding_y - DESTINATION_TILE_SIZE
    border_size = args.state.grid.size + DESTINATION_TILE_SIZE + 1
  
    args.outputs.borders << [border_x + DESTINATION_TILE_SIZE,
                             border_y + DESTINATION_TILE_SIZE,
                             border_size + 250,
                             border_size]
  
    # render label stuff
    if args.state.enemies.empty?
      args.outputs.labels << [border_x + 600, border_y + 1, "Congrats you beat level #{args.state.level}\n press h for next level"]
    end
    args.outputs.labels << [border_x, border_y - 10, "Current player location is: #{args.state.player.x}, #{args.state.player.y} you have #{args.state.player.hp} HP left"]
    args.outputs.labels << [border_x, border_y + 35 + border_size, args.state.info_message]
    args.outputs.labels << [border_x + 600, border_y + 35 + border_size, "The hotpot has #{args.state.hotpot.hp} hps left"]
  end
  
  def tile_in_game x, y, tile_key
    tile($gtk.args.state.grid.padding_x + x * DESTINATION_TILE_SIZE,
         $gtk.args.state.grid.padding_y + y * DESTINATION_TILE_SIZE,
         tile_key)
  end
  
  def proximity_to_target(me, target)
    (me.x - target.x).abs + (me.y - target.y).abs
  end

  def still_in_map?(x, y)
    x > -1 && x < 62 && y > -1 && y < 43
  end
