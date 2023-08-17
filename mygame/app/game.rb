class Game
  attr_gtk
  def initialize(args)
    args.state.arrows = []
    args.state.enemies = []
    args.state.combat_log = []
    args.state.budget = 5
    Baddies.new.spawn_baddie
    args.state.level = 1
    args.state.info_message = "Welcome to Level #{args.state.level}."
    args.state.score = 0
    args.state.player = Players.new().player_data($player_choice)
    args.state.dragon = {
      alive: false
    }
    args.state.hotpot = {
      y: 20,
      x: 29,
      hp: 20,
      armor: 2,
      atk: [0,0],
      type: "Hot Pot"
    }

    @enviroment = [
      { x:29 , y: 20, tile_key: :xpath },
      
      { x:28 , y: 20, tile_key: :hpath },
      { x:27 , y: 20, tile_key: :hpath2 },
      { x:26 , y: 20, tile_key: :hpath },
      { x:25 , y: 20, tile_key: :hpath2 },
      { x:24 , y: 20, tile_key: :hpath },
      { x:23 , y: 20, tile_key: :hpath2 },
      { x:22 , y: 20, tile_key: :hpath },
      { x:21 , y: 20, tile_key: :hpath },
      { x:20 , y: 20, tile_key: :hpath },
      { x:19 , y: 20, tile_key: :hpath2 },
      { x:18 , y: 20, tile_key: :hpath },

      { x:30 , y: 20, tile_key: :hpath },
      { x:31 , y: 20, tile_key: :hpath2 },
      { x:32 , y: 20, tile_key: :hpath },
      { x:33 , y: 20, tile_key: :hpath2 },
      { x:34 , y: 20, tile_key: :hpath },
      { x:35 , y: 20, tile_key: :hpath2 },
      { x:36 , y: 20, tile_key: :hpath },
      { x:37 , y: 20, tile_key: :hpath },
      { x:38 , y: 20, tile_key: :hpath },
      { x:39 , y: 20, tile_key: :hpath2 },

      { x:29 , y: 21, tile_key: :vpath },
      { x:29 , y: 22, tile_key: :vpath2 },
      { x:29 , y: 23, tile_key: :vpath },
      { x:29 , y: 24, tile_key: :vpath2 },
      { x:29 , y: 25, tile_key: :vpath },
      { x:29 , y: 26, tile_key: :vpath2 },
      { x:29 , y: 27, tile_key: :vpath },
      { x:29 , y: 28, tile_key: :vpath },
      { x:29 , y: 29, tile_key: :vpath },
      { x:29 , y: 30, tile_key: :vpath },

      { x:29 , y: 19, tile_key: :vpath },
      { x:29 , y: 18, tile_key: :vpath2 },
      { x:29 , y: 17, tile_key: :vpath },
      { x:29 , y: 16, tile_key: :vpath2 },
      { x:29 , y: 15, tile_key: :vpath },
      { x:29 , y: 14, tile_key: :vpath2 },
      { x:29 , y: 13, tile_key: :vpath },
      { x:29 , y: 12, tile_key: :vpath },
      { x:29 , y: 11, tile_key: :vpath },
      { x:29 , y: 10, tile_key: :vpath },
    ]
    15.times{ |x| @enviroment << spawn_bush }

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
      { x: 26, y: 13, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 31, y: 13, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 37, y: 18, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 37, y: 23, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 31, y: 28, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 26, y: 28, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 20, y: 18, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 20, y: 23, type: GOODIES[:guard].name, tile_key: GOODIES[:guard].tile_key, hp: GOODIES[:guard].hp, atk: GOODIES[:guard].atk, armor: GOODIES[:guard].armor},
      { x: 30, y: 20, type: GOODIES[:cook].name, tile_key: GOODIES[:cook].tile_key, hp: GOODIES[:cook].hp, atk: GOODIES[:cook].atk, armor: GOODIES[:cook].armor},
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
  
    if args.state.dragon.alive
      dragon_sprite_index = 0.frame_index(count: 6, hold_for: 14, repeat: true)
      args.state.dragon.path = "sprites/dragon-#{dragon_sprite_index}.png"
      args.state.dragon.x += 0.45
      args.state.dragon.y += 0.25
      if args.state.dragon.x > args.grid.w
        args.state.dragon.alive = false
      end
    end

    if args.state.player.dead || args.state.hotpot.dead
        #args.audio[:music].paused = true
        args.outputs.sounds << "sounds/game-over.wav"
        args.state.scene = "game_over"
      end
  
    args.state.clouds.each do |cloud|
      cloud.x -= rand(5)/10
      cloud.y += (rand(10) - 4) / 20
      if cloud.x < 0
        cloud.dead = true
        next
      end
    end   
    args.state.clouds.reject! { |c| c.dead }
    if args.state.clouds.size < 9
      args.state.clouds << spawn_cloud(false)
    end
    # render game
    # render enemies at locations
    args.outputs.sprites << args.state.enemies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key])
    end
    # render the enviroment comes after enemies to let them hide in bushes
    args.outputs.sprites << @enviroment.map do |object|
      tile_in_game(object[:x], object[:y], object[:tile_key])
    end
    args.outputs.sprites << tile_in_game(args.state.player.x, args.state.player.y, '@')
    args.outputs.sprites << tile_in_game(args.state.hotpot.x, args.state.hotpot.y, :H)
  
    # render the arrows
    args.outputs.sprites << args.state.arrows.map do |a|
      tile_in_game(a[:x], a[:y], a[:tile_key])
    end    
    #render the village
    args.outputs.sprites << args.state.goodies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key])
    end
    # render walls at locations
    args.outputs.sprites << args.state.walls.map do |w|
      tile_in_game(w[:x], w[:y], w[:tile_key])
    end
    args.outputs.sprites << [ args.state.clouds, args.state.dragon ]
    
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
    args.outputs.labels << [border_x + 10, border_y - 10, "[#{args.state.player.x},#{args.state.player.y}]You have #{args.state.player.hp}/#{args.state.player.maxhp}HP left | #{args.state.player.arrows}/#{args.state.player.quiver} arrows | an attack of #{args.state.player.atk[0]}d#{args.state.player.atk[1]} | #{args.state.player.armor} Armor"]
    args.outputs.labels << [border_x + 10, border_y + 36 + border_size, args.state.info_message]
    args.outputs.labels << [border_x + 1000, border_y - 10, "LEVEL: #{args.state.level}     SCORE: #{args.state.score}"]
    args.state.combat_log = args.state.combat_log.flatten.last(20)
    args.state.combat_log.each_with_index do |log, index|
      args.outputs.labels << [885, (670 - (index*20)) , "#{log}", -4,]
    end
    args.outputs.labels << [border_x + 600, border_y + 36 + border_size, "The hotpot has #{args.state.hotpot.hp} hps left"]
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
  
  private

  def handle_input(args)
    @new_player_x = args.state.player.x
    @new_player_y = args.state.player.y
    @player_moved = false
    if args.inputs.keyboard.key_down.up
      @new_player_y += 1
      @player_direction = "north"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.down
      @new_player_y -= 1
      @player_direction = "south"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.right
      @new_player_x += 1
      @player_direction = "east"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.left
      @new_player_x -= 1
      @player_direction = "west"
      @player_moved = true
    elsif args.inputs.keyboard.key_down.s
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 's')
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.a
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 'a')
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.w
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 'w')
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.d
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 'd')
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.space
      @player_moved = true
    end
  end

  def game_turn(args)
    args.state.arrows = arrow_flight(args.state.arrows) if args.state.arrows
    check_arrows(args)
    found_enemy = find_same_square_group(@new_player_x, @new_player_y, args.state.enemies)

    found_wall = find_same_square_group(@new_player_x, @new_player_y, args.state.walls)

    found_wall = true if check_if_same_square?(@new_player_x, @new_player_y, args.state.hotpot)
    blocking_friend = find_same_square_group(@new_player_x, @new_player_y, args.state.goodies)

    if still_in_map?(@new_player_x, @new_player_y)
      if !found_enemy && !found_wall && !blocking_friend
        args.state.player.x = @new_player_x
        args.state.player.y = @new_player_y
        message = "You moved #{@player_direction}."
      elsif found_enemy
        message = your_combat(args.state.player, found_enemy)
        args.state.score += found_enemy.value if found_enemy.dead
        args.state.enemies.reject! { |e| e.dead }
      elsif blocking_friend && !found_wall
        blocking_friend.x = args.state.player.x
        blocking_friend.y = args.state.player.y
        args.state.player.x = @new_player_x
        args.state.player.y = @new_player_y
        message = "You swapped places with #{blocking_friend.type}."
      else
        message = "You can't move through walls or the hotpot!"
      end
      args.state.info_message = message
    end
    args.state.goodies.each do |goody|
      if goody.type == 'Cook' && args.state.tick_count.even?
        target_distances = args.state.goodies.map { |good| [good, proximity_to_target(goody, good)] }
      else
        target_distances = args.state.enemies.map { |enemy| [enemy, proximity_to_target(goody, enemy)] }
      end
      nearest_target, min_distance = target_distances.min_by { |_, distance| distance }
      if goody.type == "Pie Wagon"
         if goody.moved
           goody.moved = false
           new_spot = [goody.x, goody.y]
         else
          new_spot = BasicPath.new(goody, args.state.hotpot, args.state.walls).move_step
          goody.moved = true
         end
      elsif min_distance && min_distance < 5
        new_spot = BasicPath.new(goody, nearest_target, args.state.walls, @allies).move_step
      elsif goody.type == "Ranger"
        if goody.arrows.even?
          shot = rand(4)
          case shot
            when 1
              shoot_arrow(goody, 'd')
            when 2
              shoot_arrow(goody, 's')
            when 3
              shoot_arrow(goody, 'a')
            when 4
              shoot_arrow(goody, 'w')
          end
        else 
          goody.arrows = 0
        end
        new_spot = BasicPath.new(goody, goody, args.state.walls).random_direction
      else
        new_spot = BasicPath.new(goody, goody, args.state.walls).random_direction
      end
      blocking_friend = find_same_square_group(new_spot.x, new_spot.y, @allies)
      blocking_opponent = find_same_square_group(new_spot.x, new_spot.y, args.state.enemies)
      found_wall = find_same_square_group(new_spot.x, new_spot.y, args.state.walls)
      hit_arrow = find_same_square_group(new_spot.x, new_spot.y, args.state.arrows)
      if blocking_friend
        #don't move unless healer
        if goody.type == 'Cook'
          args.state.combat_log << heal(goody, blocking_friend)
          args.state.player.hp = args.state.player.maxhp if args.state.player.hp > args.state.player.maxhp
        elsif goody.type == "Pie Wagon"
          if blocking_friend == args.state.hotpot
            args.state.combat_log << "Yay the Pie Wagon made it to the hotpot" 
            args.state.combat_log << "The hotpot gains 10HP"
            args.state.combat_log << "A new Cook has spawned"
            args.state.combat_log << "You gain 2HP"
            spawn_villager('Cook')
            args.state.player.hp += 2
            args.state.hotpot.hp += 10
            args.state.player.hp = args.state.player.maxhp if args.state.player.hp > args.state.player.maxhp
            goody.dead = true
          end
        end
      elsif found_wall
        #don't move
      elsif blocking_opponent
        args.state.combat_log << other_combat(goody, blocking_opponent)
        args.state.enemies.reject! { |e| e.dead } 
      elsif goody.type == "Pie Wagon"
        goody.x = new_spot.x
        goody.y = new_spot.y
        if hit_arrow
          hit_arrow.dead = true
          args.state.arrows.reject! { |arrow| arrow.dead }  
        end          
      elsif goody.type == "Ranger"
        goody.x = new_spot.x unless !still_in_map?(new_spot.x, new_spot.y)
        goody.y = new_spot.y unless !still_in_map?(new_spot.x, new_spot.y)
      else
        if hit_arrow
          hit_arrow.dead = true
          args.state.arrows.reject! { |arrow| arrow.dead }  
        end
        goody.x = new_spot.x unless !(in_village?(new_spot))
        goody.y = new_spot.y unless !(in_village?(new_spot))
      end
    end 

    args.state.enemies.each do |enemy|
      ally_distances = @allies.map { |ally| [ally, proximity_to_target(enemy, ally)] }
      nearest_target, min_distance = ally_distances.min_by { |_, distance| distance } 
      new_spot = BasicPath.new(enemy, nearest_target, args.state.walls, args.state.enemies).move_step
      blocking_friend = find_same_square_group(new_spot.x, new_spot.y, args.state.enemies)
      blocking_opponent = find_same_square_group(new_spot.x, new_spot.y, args.state.goodies)
      hit_arrow = find_same_square_group(new_spot.x, new_spot.y, args.state.arrows)
      if enemy.type == "Goblin Shaman" && args.state.tick_count % 3 == 0
        close_friends = args.state.enemies.select { |ally| proximity_to_target(enemy, ally) < 6}
        close_friends.each do |friend|
          args.state.combat_log << heal(enemy, friend)
        end
      end
      if check_if_same_square?(new_spot.x, new_spot.y, args.state.player)
        args.state.combat_log << other_combat(enemy, args.state.player)
      elsif blocking_friend
        #don't move
      elsif check_if_same_square?(new_spot.x, new_spot.y, args.state.hotpot)
        args.state.combat_log << other_combat(enemy, args.state.hotpot)
      elsif blocking_opponent
        args.state.combat_log << other_combat(enemy, blocking_opponent)
      else
        if hit_arrow
          args.state.combat_log << your_arrow(enemy)
          hit_arrow.dead = true
          args.state.arrows.reject! { |arrow| arrow.dead } 
        end
        enemy.x = new_spot.x
        enemy.y = new_spot.y
      end
    end
    check_arrows(args)
    args.state.enemies.reject! { |e| e.dead }
    args.state.goodies.reject! { |g| g.dead }
    Baddies.new.spawn_baddie
  end

  def tile_in_game(x, y, tile_key)
    $sprite_tiles.tile(PADDING_X + x * DESTINATION_TILE_SIZE,
         PADDING_Y + y * DESTINATION_TILE_SIZE,
         tile_key)
  end
  
  def proximity_to_target(me, target)
    if (me.x - target.x).abs + (me.y - target.y).abs == 0
      return 100
    end
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

  def check_if_same_square?(x,y, object)
    object[:x] == x && object[:y] == y
  end

  def find_same_square_group(x,y, set)
    found = false
    found = set.find do |object|
      check_if_same_square?(x,y, object)
    end
    found
  end

  def check_arrows(args)
    args.state.arrows.each do |arrow|
      #check if they run into a friend
      blocking_opponent = find_same_square_group(arrow.x, arrow.y, args.state.enemies)
      blocking_friend = find_same_square_group(arrow.x, arrow.y, args.state.goodies)
      found_wall = find_same_square_group(arrow.x, arrow.y, args.state.walls)
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

  def shoot_arrow(source, d)
    args.state.arrows << {
      x: source.x,
      y: source.y,
      tile_key: "#{d}arrow".to_sym,
      direction: d #down
    }
    source.arrows -= 1
  end

  def spawn_tree
    tree = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: :tree, tree_type: true, }
    until !in_village?(tree) do
      tree = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: :tree, tree_type: true, }
    end
    tree
  end

  def spawn_bush
    bush = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: :bush }
    until !in_village?(bush) do
      bush = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: :bush }
    end
    bush
  end

  def add_bush
    @enviroment << spawn_bush
  end

end