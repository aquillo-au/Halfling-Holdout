class Game
  attr_gtk
  def initialize(args)
    args.state.arrows = []
    args.state.bolts = []
    args.state.fireballs = []
    args.state.enemies = []
    args.state.combat_log = []
    @village = Goodies.new
    @combat = Combat.new

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

    args.state.others = [
      spawn_piggy(true),
      spawn_piggy(true),
      spawn_piggy(true)
    ]

    @decorations = []
    paint_village
    paint_grass
    @enviroment = []
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
      @village.place_villager(26, 13, 'guard'),
      @village.place_villager(31, 13, 'guard'),
      @village.place_villager(37, 18, 'guard'),
      @village.place_villager(37, 23, 'guard'),
      @village.place_villager(31, 28, 'guard'),
      @village.place_villager(26, 28, 'guard'),
      @village.place_villager(20, 18, 'guard'),
      @village.place_villager(20, 23, 'guard'),
      @village.place_villager(30, 20, 'cook'),
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
    if args.inputs.keyboard.key_down.m
      if args.audio[:music].paused
        args.audio[:music].paused = false
      else
        args.audio[:music].paused = true
      end
    end
    args.outputs.sprites << {
      x: 0,
      y: 0,
      w: args.grid.w,
      h: args.grid.h,
      a: 25,
      path: 'sprites/background.png'
    }
    args.outputs.sprites << {
      x: args.grid.w - 135,
      y: args.grid.h - 40,
      w: 125,
      h: 35,
      path: 'sprites/title.png'
    }
    @allies = [args.state.player, args.state.hotpot]
    args.state.goodies.each { |villager| @allies << villager }
  
    # handle keyboard input
    handle_input
  

    #handle game logic
    # determine if there is an enemy on that square,
    # if so, don't let the player move there
    if @player_moved
      game_turn(args)
    end
  
    frame = 1.frame_index(count: 5, hold_for: 15, repeat: true)

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
      args.audio[:music] = { input: "sounds/coldjourney.ogg", looping: true }
      $game_over = GameOver.new(args)
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
    args.outputs.sprites << @decorations.map do |d|
      tile_in_game(d[:x], d[:y], d[:tile_key], frame)
    end
    # render enemies at locations
    args.outputs.sprites << args.state.enemies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key], frame)
    end
    # render the others
    args.outputs.sprites << args.state.others.map do |o|
      tile_in_game(o[:x], o[:y], o[:tile_key], frame)
    end
    
    # render the enviroment comes after enemies to let them hide in bushes
    args.outputs.sprites << @enviroment.map do |object|
      tile_in_game(object[:x], object[:y], object[:tile_key], frame)
    end
    args.outputs.sprites << tile_in_game(args.state.player.x, args.state.player.y, args.state.player.sprite_key, frame)
    args.outputs.sprites << tile_in_game(args.state.hotpot.x, args.state.hotpot.y, :H, frame)
  
    # render the projectiles
    args.outputs.sprites << args.state.arrows.map do |a|
      tile_in_game(a[:x], a[:y], a[:tile_key], frame)
    end    
    args.outputs.sprites << args.state.bolts.map do |b|
      tile_in_game(b[:x], b[:y], b[:tile_key], frame)
    end
    args.outputs.sprites << args.state.fireballs.map do |f|
      tile_in_game(f[:x], f[:y], :fireball, frame)
    end
    #render the village
    args.outputs.sprites << args.state.goodies.map do |e|
      tile_in_game(e[:x], e[:y], e[:tile_key], frame)
    end
    # render walls at locations
    args.outputs.sprites << args.state.walls.map do |w|
      tile_in_game(w[:x], w[:y], w[:tile_key], frame)
    end
    args.outputs.sprites << [ args.state.clouds, args.state.dragon,  ]
    

    # render the border
    border_x = PADDING_X - DESTINATION_TILE_SIZE
    border_y = PADDING_Y - DESTINATION_TILE_SIZE
    border_size = SIZE + DESTINATION_TILE_SIZE + 1
  
    args.outputs.borders << [border_x + DESTINATION_TILE_SIZE,
                             border_y + DESTINATION_TILE_SIZE,
                             border_size + 245,
                             border_size - 10]
  
    if args.state.enemies.empty?
      args.outputs.sounds << "sounds/click.wav"
      args.state.scene = "level"
    end

    if args.state.start_lightning_at
      sprite_index = args.state
                         .start_lightning_at
                         .frame_index 12, 3, false
    end

    sprite_index ||= 12
    if sprite_index != 12
      args.outputs.sprites << { x: @lightning_x, y: @lightning_y, w: 25, h: 25, path: "sprites/lightning/lightning#{sprite_index}.png" }
    end
      # render label stuff
    args.outputs.labels << [border_x + 10, border_y + 10, "[#{args.state.player.x},#{args.state.player.y}]You have #{args.state.player.hp}/#{args.state.player.maxhp}HP left with #{args.state.player.armor} Armor", -5]
    args.outputs.labels << [border_x + 10, border_y - 8, "#{args.state.player.arrows}/#{args.state.player.quiver} arrows and an attack of #{args.state.player.atk[0]}d#{args.state.player.atk[1]}", -5]
    if args.state.player.spells
      args.outputs.labels << [885, 255,"#{args.state.player.mana}/#{args.state.player.maxmana} Mana", -6]
      args.state.player.spells.keys.each_with_index do |spell, index|
        args.outputs.labels << [885, 235 - (index*20),"#{spell} - #{args.state.player.spells[spell]} mana", -6]
        args.outputs.labels << [args.grid.w - 75, 235 - (index*20),"(#{spell.to_s[0]})", -6] unless spell == :Lightning
      end
    end
    args.outputs.labels << [border_x + 10, border_y + 36 + border_size, args.state.info_message, -6]
    args.outputs.labels << [border_x + 1000, border_y - 10, "LEVEL: #{args.state.level}     SCORE: #{args.state.score}", -6]
    args.state.combat_log = args.state.combat_log.flatten.last(20)
    args.state.combat_log.each_with_index do |log, index|
      args.outputs.labels << [885, (666 - (index*20)) , "#{log}", -8,]
    end
    args.outputs.labels << [border_x + 600, border_y + 36 + border_size, "The hotpot has #{args.state.hotpot.hp} hps left", -6]
    args.outputs.solids << {
       x: args.grid.w - 400,
       y: args.grid.h - 450,
       w: SOURCE_TILE_SIZE * 22,
       h: SOURCE_TILE_SIZE * 25,
       r: 68,
       g: 150,
       b: 230,
       a: 50,
     }
    args.outputs.solids << {
      x: args.grid.w - 400,
      y: PADDING_Y,
      w: SOURCE_TILE_SIZE * 22,
      h: SOURCE_TILE_SIZE * 6,
      r: 68,
      g: 150,
      b: 230,
      a: 50,
    }
    # args.outputs.solids << {
    #   x: 0,
    #   y: 0,
    #   w: args.grid.w,
    #   h: args.grid.h,
    #   r: 32,
    #   g: 120,
    #   b: 60,
    #   a: 25,
    # }
  end
  
  private

  def handle_input
    @player_direction = nil
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
        shoot_arrow(args.state.player, 's', true)
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.a
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 'a', true)
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.w
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 'w', true)
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.d
      if args.state.player.arrows > 0
        shoot_arrow(args.state.player, 'd', true)
        @player_moved = true
      end
    elsif args.inputs.keyboard.key_down.space
      @player_moved = true
    end
    if args.state.player.spells #check if a spell caster
      if args.inputs.mouse.click && args.state.player.spells[:Lightning]
        if args.state.player.mana >= args.state.player.spells[:Lightning]
          mouse_row = args.inputs.mouse.point.y.idiv(SOURCE_TILE_SIZE)
          tile_y = (mouse_row - PADDING_Y.idiv(SOURCE_TILE_SIZE) - 1)
      
          mouse_col = args.inputs.mouse.point.x.idiv(SOURCE_TILE_SIZE)
          tile_x = (mouse_col - PADDING_X.idiv(SOURCE_TILE_SIZE) - 1)
      
          target = find_same_square_group(tile_x, tile_y, args.state.enemies + args.state.others)
          if target
            args.state.combat_log << @combat.lightning_bolt(target) 
            args.state.start_lightning_at = args.state.tick_count
            @lightning_x = PADDING_X + target.x * DESTINATION_TILE_SIZE
            @lightning_y = PADDING_Y + target.y * DESTINATION_TILE_SIZE
            args.state.player.mana -= args.state.player.spells[:Lightning]
            @player_moved = true
          end
        else
          args.state.info_message = "You don't have enough Mana"
        end
      elsif args.inputs.keyboard.key_down.t && args.state.player.spells[:Teleport]
        if args.state.player.mana >= args.state.player.spells[:Teleport]
          @new_player_x = 28
          @new_player_y = 20       
          args.state.player.mana -= args.state.player.spells[:Teleport]
          @player_moved = true
        else
          args.state.info_message = "You don't have enough Mana"
        end
      elsif args.inputs.keyboard.key_down.f && args.state.player.spells[:Fireball] 
        if args.state.player.mana >= args.state.player.spells[:Fireball]
          args.state.fireballs << { x: args.state.player.x, y: args.state.player.y }      
          args.state.player.mana -= args.state.player.spells[:Fireball]
          @player_moved = true
        else
          args.state.info_message = "You don't have enough Mana"
        end
      elsif args.inputs.keyboard.key_down.h && args.state.player.spells[:Heal]
        if args.state.player.mana >= args.state.player.spells[:Heal]
          close_friends = @allies.select { |ally| proximity_to_target(args.state.player, ally) < 6}
          close_friends.each do |friend|
            args.state.combat_log << @combat.heal(args.state.player, friend)
          end
          heal = rand(5) + 1
          args.state.player.hp = (args.state.player.hp + heal).clamp(1, args.state.player.maxhp)
          args.state.info_message = "You heal yourself for #{heal}"
          args.state.player.mana -= args.state.player.spells[:Heal]
          @player_moved = true
        else
          args.state.info_message = "You don't have enough Mana"
        end
      end
    end
    if @player_moved && $player_choice == 'archer'
      if args.state.tick_count % 10 == 0
        @player_moved = false
        player_movement
        args.state.combat_log << "You move so fast it seems the world is standing still"
      end
    end
  end

  def game_turn(args)
    events
    if args.state.player.mana < args.state.player.maxmana && gain_mana?
      args.state.player.mana += 1
    end
    # check if slow characters get a move
    if $player_choice == 'dwarf' && args.state.tick_count % 15 == 0
      args.state.combat_log << "Before you react the world moves around you"
    else
      player_movement
    end
    
    #handle the projectiles
    args.state.arrows = projectile_flight(args.state.arrows) if args.state.arrows
    args.state.bolts = projectile_flight(args.state.bolts) if args.state.bolts
    fireball_flight if args.state.fireballs

    check_arrows(args)
    check_bolts(args)

    # move the other things
    goodie_movement
    baddie_movement
    other_movement
    
    
    check_arrows(args)
    check_bolts(args)
    args.state.enemies.reject! { |e| e.dead }
    args.state.goodies.reject! { |g| g.dead }
    args.state.others.reject! { |o| o.dead }
    Baddies.new.spawn_baddie
  end

  def player_movement
    message = ''
    found_enemy = find_same_square_group(@new_player_x, @new_player_y, args.state.enemies + args.state.others )
    found_wall = find_same_square_group(@new_player_x, @new_player_y, args.state.walls )
    found_wall = true if check_if_same_square?(@new_player_x, @new_player_y, args.state.hotpot)
    hit_bolt = find_same_square_group(@new_player_x, @new_player_y, args.state.bolts)
    blocking_friend = find_same_square_group(@new_player_x, @new_player_y, args.state.goodies)

    if still_in_map?(@new_player_x, @new_player_y) && @player_direction
      if !found_enemy && !found_wall && !blocking_friend
        args.state.player.x = @new_player_x
        args.state.player.y = @new_player_y
        message = "You moved #{@player_direction}."
      elsif found_enemy
        message = @combat.your_combat(args.state.player, found_enemy)
        args.state.score += found_enemy.value if found_enemy.dead
        args.state.enemies.reject! { |e| e.dead }
        if args.state.enemies.empty?
          args.outputs.sounds << "sounds/game-over.wav"
          args.state.scene = "level"
        end
      elsif blocking_friend && !found_wall
        blocking_friend.x = args.state.player.x
        blocking_friend.y = args.state.player.y
        args.state.player.x = @new_player_x
        args.state.player.y = @new_player_y
        message = "You swapped places with #{blocking_friend.type}."
      elsif hit_bolt
        hit_bolt.dead = true 
        args.state.combat_log << @combat.bolt_hit(args.state.player)
        args.state.bolts.reject! { |bolt| bolt.dead } 
        args.state.player.x = @new_player_x
        args.state.player.y = @new_player_y
      else
        message = "You can't move through walls or the hotpot!"
      end
      args.state.info_message = message if message != ''
    end
  end

  def goodie_movement
    return if args.state.enemies.empty?
    args.state.goodies.each do |goody|
      if goody.type == 'Cook' && args.state.tick_count.even?
        target_distances = args.state.goodies.map { |good| [good, proximity_to_target(goody, good)] }
      else
        target_distances = args.state.enemies.map { |enemy| [enemy, proximity_to_target(goody, enemy)] }
      end
      nearest_target, min_distance = target_distances.min_by { |_, distance| distance }
      path = BasicPath.new(goody, nearest_target, args.state.walls, @allies)
       
      if goody.type == "Pie Wagon"
        path = BasicPath.new(goody, args.state.hotpot, args.state.walls)
         if goody.moved
           goody.moved = false
           new_spot = [goody.x, goody.y]
         else
          new_spot = path.move_step
          goody.moved = true
         end
      elsif min_distance && min_distance < 5
        new_spot = path.move_step
      elsif goody.type == "Ranger"
        if goody.arrows.even?
          aim = path.take_aim
          shoot_arrow(goody, aim)
          new_spot = goody
        else 
          goody.arrows = 0
          new_spot = path.random_direction
        end
      else
        new_spot = path.random_direction
      end
      blocking_friend = find_same_square_group(new_spot.x, new_spot.y, @allies)
      blocking_opponent = find_same_square_group(new_spot.x, new_spot.y, args.state.enemies + args.state.others )
      found_wall = find_same_square_group(new_spot.x, new_spot.y, args.state.walls)
      hit_arrow = find_same_square_group(new_spot.x, new_spot.y, args.state.arrows)
      hit_bolt = find_same_square_group(new_spot.x, new_spot.y, args.state.bolts)
      if blocking_friend
        #don't move unless healer
        if goody.type == 'Cook'
          args.state.combat_log << @combat.heal(goody, blocking_friend)
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
        args.state.combat_log << @combat.other_combat(goody, blocking_opponent)
        args.state.enemies.reject! { |e| e.dead } 
        return if args.state.enemies.empty?

      elsif goody.type == "Pie Wagon"
        goody.x = new_spot.x
        goody.y = new_spot.y
        if hit_arrow
          hit_arrow.dead = true
          args.state.arrows.reject! { |arrow| arrow.dead }  
        end        
      elsif goody.type == "Ranger" || !(in_village?(goody))
        goody.x = new_spot.x unless !still_in_map?(new_spot.x, new_spot.y)
        goody.y = new_spot.y unless !still_in_map?(new_spot.x, new_spot.y)
      else
        if hit_arrow
          hit_arrow.dead = true
          args.state.arrows.reject! { |arrow| arrow.dead } 
        elsif hit_bolt
          hit_bolt.dead = true 
          args.state.combat_log << @combat.bolt_hit(goody)
          args.state.bolts.reject! { |bolt| bolt.dead } 
        end
        goody.x = new_spot.x unless !(in_village?(new_spot))
        goody.y = new_spot.y unless !(in_village?(new_spot))
      end
    end
  end 

  def baddie_movement
    args.state.enemies.each do |enemy|
      ally_distances = @allies.map { |ally| [ally, proximity_to_target(enemy, ally)] }
      nearest_target, min_distance = ally_distances.min_by { |_, distance| distance } 
      path = BasicPath.new(enemy, nearest_target, args.state.walls, args.state.enemies)
      new_spot = path.move_step
      blocking_friend = find_same_square_group(new_spot.x, new_spot.y, args.state.enemies)
      blocking_opponent = find_same_square_group(new_spot.x, new_spot.y, args.state.goodies + args.state.others)
      hit_arrow = find_same_square_group(new_spot.x, new_spot.y, args.state.arrows)
      if enemy.type == "Orc Shaman" && args.state.tick_count % 3 == 0
        close_friends = args.state.enemies.select { |ally| proximity_to_target(enemy, ally) < 6}
        close_friends.each do |friend|
          args.state.combat_log << @combat.heal(enemy, friend)
        end
      elsif enemy.type == "Goblin Bowman" && args.state.tick_count % 4 == 0
        aim = path.take_aim
        fire_bolt(enemy, aim)
        next

      end
      if check_if_same_square?(new_spot.x, new_spot.y, args.state.player)
        args.state.combat_log << @combat.other_combat(enemy, args.state.player)
      elsif blocking_friend
        #don't move
      elsif check_if_same_square?(new_spot.x, new_spot.y, args.state.hotpot)
        args.state.combat_log << @combat.other_combat(enemy, args.state.hotpot)
      elsif blocking_opponent
        args.state.combat_log << @combat.other_combat(enemy, blocking_opponent)
      else
        if hit_arrow
          args.state.combat_log << @combat.your_arrow(enemy, hit_arrow)
          hit_arrow.dead = true
          args.state.arrows.reject! { |arrow| arrow.dead } 
        end
        enemy.x = new_spot.x unless !still_in_map?(new_spot.x, new_spot.y)
        enemy.y = new_spot.y unless !still_in_map?(new_spot.x, new_spot.y)
      end
    end
  end

  def other_movement
    args.state.others.each do |other|
      new_spot = BasicPath.new(other, other, args.state.walls).random_direction
      blocking_friend = find_same_square_group(new_spot.x, new_spot.y, args.state.others)
      blocking_opponent = find_same_square_group(new_spot.x, new_spot.y, args.state.enemies + @allies)
      found_wall = find_same_square_group(new_spot.x, new_spot.y, args.state.walls)
      hit_arrow = find_same_square_group(new_spot.x, new_spot.y, args.state.arrows)
      hit_bolt = find_same_square_group(new_spot.x, new_spot.y, args.state.bolts)
      if blocking_friend || found_wall
        #don't move
      elsif blocking_opponent
        args.state.combat_log << @combat.other_combat(other, blocking_opponent)
        args.state.enemies.reject! { |e| e.dead }
        args.state.goodies.reject! { |e| e.dead }  
      elsif still_in_map?(new_spot.x, new_spot.y)
        if hit_arrow
          hit_arrow.dead = true
          args.state.combat_log << @combat.your_arrow(other, hit_arrow)
          args.state.arrows.reject! { |arrow| arrow.dead } 
        elsif hit_bolt
          hit_bolt.dead = true 
          args.state.combat_log << @combat.bolt_hit(other)
          args.state.bolts.reject! { |bolt| bolt.dead } 
        end
        other.x = new_spot.x unless !still_in_map?(new_spot.x, new_spot.y)
        other.y = new_spot.y unless !still_in_map?(new_spot.x, new_spot.y)
      end
    end
  end

  def fireball_flight
    return if args.state.enemies.empty?
    args.state.fireballs.each do |ball|
      target_distances = args.state.enemies.map { |enemy| [enemy, proximity_to_target(ball, enemy)] }
      nearest_target, min_distance = target_distances.min_by { |_, distance| distance }
      path = BasicPath.new(ball, nearest_target, args.state.walls, @allies)
      new_spot = path.move_step

      blocking_opponent = find_same_square_group(new_spot.x, new_spot.y, args.state.enemies + args.state.others)

      if blocking_opponent
        args.state.combat_log << @combat.fire_ball_attack(blocking_opponent)
        args.state.enemies.reject! { |e| e.dead } 
        args.state.fireballs.delete(ball)
        return if args.state.enemies.empty?
      else
        ball.x = new_spot.x unless !still_in_map?(new_spot.x, new_spot.y)
        ball.y = new_spot.y unless !still_in_map?(new_spot.x, new_spot.y)
      end
    end
  end 

  def tile_in_game(x, y, tile_key, frame = 1)
    $sprite_tiles.tile(PADDING_X + x * DESTINATION_TILE_SIZE, PADDING_Y + y * DESTINATION_TILE_SIZE, tile_key, frame)
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

  def projectile_flight(projectiles)
    projectiles.each do |projectile|
      case projectile.direction
      when "s"
        projectile.y -= 1
      when "w"
        projectile.y += 1
      when "d"
        projectile.x += 1
      when "a"
        projectile.x -= 1
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

  def events
    if args.state.tick_count % 45 == 0
      args.state.others << spawn_piggy
      args.state.combat_log << "A wild boar has wandered in"
    end
    if args.state.tick_count % 75 == 0
      args.state.walls << spawn_tree
      args.state.combat_log << "A new tree has grown at [#{args.state.walls[-1].x}, #{args.state.walls[-1].y}]"
    end
    if args.state.tick_count % 60 == 0
      target = args.state.walls.sample
      args.state.combat_log << "The Enemies have fired a catapult destroying a #{target.tree_type ? "tree": "wall"}"
      args.state.walls.delete(target)
    end
    if args.state.tick_count % 95 == 0
      args.state.combat_log << "A pie wagon has arrived, protect it until it reaches the Hot Pot!"
      args.state.goodies << @village.spawn_pie_wagon
    end
    if args.state.tick_count % 85 == 0
      args.state.combat_log << "A wandering ranger aids your cause"
      args.state.goodies << @village.spawn_ranger
    end
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
        args.state.combat_log << @combat.your_arrow(blocking_opponent, arrow)
        arrow.dead = true
      end
    end
    args.state.arrows.reject! { |arrow| arrow.dead }
  end

  def check_bolts(args)
    args.state.bolts.each do |bolt|
      #check if they run into a friend
      blocking_target = find_same_square_group(bolt.x, bolt.y, @allies)
      found_wall = find_same_square_group(bolt.x, bolt.y, args.state.walls)
      if found_wall || !still_in_map?(bolt.x, bolt.y)
        bolt.dead = true
      elsif blocking_target
        args.state.combat_log << @combat.bolt_hit(blocking_target)
        bolt.dead = true
      end
    end
    args.state.bolts.reject! { |bolt| bolt.dead }
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

  def shoot_arrow(source, d, hero = false)
    x_start = source.x
    y_start = source.y
    if !hero 
      case d
        when 'a'
          x_start -= 1
        when 'd'
          x_start += 1
        when 's'
          y_start -= 1
        else
          y_start += 1
      end
    end
    args.state.arrows << {
      x: x_start,
      y: y_start,
      tile_key: "#{d}arrow".to_sym,
      direction: d, #down
      player: hero
    }
    source.arrows -= 1
  end

  def fire_bolt(source, d)
    x_start = source.x
    y_start = source.y
    case d
      when 'a'
        x_start -= 1
      when 'd'
        x_start += 1
      when 's'
        y_start -= 1
      else
        y_start += 1
    end
    args.state.bolts << {
      x: x_start,
      y: y_start,
      tile_key: "#{d}bolt".to_sym,
      direction: d
    }
  end

  def spawn_tree
    random = rand(3)
    case random
    when 0
      tree_tile = :tree
    when 1
      tree_tile = :tree2
    else
      tree_tile = :tree3
    end
    tree = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: tree_tile, tree_type: true, }
    until !in_village?(tree) do
      tree = { x: rand(WIDTH), y: rand(HEIGHT), tile_key: tree_tile, tree_type: true, }
    end
    tree
  end

  def spawn_piggy(start = false)
    start ? cords = [rand(WIDTH),rand(HEIGHT)] : cords = spawn_location
    piggy = { x: cords[0], y: cords[1], hp: 6, tile_key: :boar, atk: [1,2], value: 1, type: "Wild Boar", armor: 0 }
    until !in_village?(piggy) do
      piggy = { x: rand(WIDTH), y: rand(HEIGHT), hp: 6, tile_key: :boar, atk: [1,2], value: 1, type: "Wild Boar", armor: 0 }
    end
    piggy
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

  def paint_grass
    x_spot = 0
    y_spot = 0
    until x_spot == WIDTH + 1 do 
        until y_spot == HEIGHT do
          random = rand(20)
          case random
          when 0, 1, 2, 3, 16
            grass_tile = :grass
          when 4, 5, 6, 7, 8, 9, 10, 17
            grass_tile = :grass2
          when 11
            grass_tile = :grass3
          when 12
            grass_tile = :grass4
          when 13, 14, 15
            grass_tile = :grass5
          else
            grass_tile = :grass6
          end
          grass = { x: x_spot, y: y_spot, tile_key: grass_tile }
          @decorations << grass if !in_village?(grass)
          y_spot += 1
        end
      x_spot += 1
      y_spot = 0
    end
  end

  def paint_village
    x_spot = 19
    y_spot = 11
    until x_spot == 39 do 
      until y_spot == 30 do
        random = rand(8)
        case random
        when 0, 1
          dirt_tile = :dirt
        when 2, 3
          dirt_tile = :dirt2
        when 4, 5
          dirt_tile = :dirt3
        else
          dirt_tile = :dirt4
        end
        dirt = { x: x_spot, y: y_spot, tile_key: dirt_tile }
        @decorations << dirt
        y_spot += 1
      end
      y_spot = 11
      x_spot += 1
    end
    x_spot = 19
    y_spot = 30
    until x_spot == 39 do 
      dirt = { x: x_spot, y: y_spot, tile_key: :dirttop }
      @decorations << dirt
      x_spot += 1
    end
    x_spot = 19
    y_spot = 10
    until x_spot == 39 do 
      dirt = { x: x_spot, y: y_spot, tile_key: :dirtbottom }
      @decorations << dirt
      x_spot += 1
    end
    x_spot = 39
    y_spot = 11
    until y_spot == 30 do 
      dirt = { x: x_spot, y: y_spot, tile_key: :dirtright }
      @decorations << dirt
      y_spot += 1
    end
    x_spot = 18
    y_spot = 11
    until y_spot == 30 do 
      dirt = { x: x_spot, y: y_spot, tile_key: :dirtleft }
      @decorations << dirt
      y_spot += 1
    end
 
    @decorations <<  { x:29 , y: 20, tile_key: :xpath } 
    @decorations <<  { x:28 , y: 20, tile_key: :hpath } 
    @decorations <<  { x:27 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:26 , y: 20, tile_key: :hpath }
    @decorations <<  { x:25 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:24 , y: 20, tile_key: :hpath }
    @decorations <<  { x:23 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:22 , y: 20, tile_key: :hpath }
    @decorations <<  { x:21 , y: 20, tile_key: :hpath }
    @decorations <<  { x:20 , y: 20, tile_key: :hpath }
    @decorations <<  { x:19 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:18 , y: 20, tile_key: :pathendleft } #end of path

    @decorations <<  { x:30 , y: 20, tile_key: :hpath }
    @decorations <<  { x:31 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:32 , y: 20, tile_key: :hpath }
    @decorations <<  { x:33 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:34 , y: 20, tile_key: :hpath }
    @decorations <<  { x:35 , y: 20, tile_key: :hpath2 }
    @decorations <<  { x:36 , y: 20, tile_key: :hpath }
    @decorations <<  { x:37 , y: 20, tile_key: :hpath }
    @decorations <<  { x:38 , y: 20, tile_key: :hpath }
    @decorations <<  { x:39 , y: 20, tile_key: :pathendright } #end of path

    @decorations <<  { x:29 , y: 21, tile_key: :vpath }
    @decorations <<  { x:29 , y: 22, tile_key: :vpath2 }
    @decorations <<  { x:29 , y: 23, tile_key: :vpath }
    @decorations <<  { x:29 , y: 24, tile_key: :vpath2 }
    @decorations <<  { x:29 , y: 25, tile_key: :vpath }
    @decorations <<  { x:29 , y: 26, tile_key: :vpath2 }
    @decorations <<  { x:29 , y: 27, tile_key: :vpath }
    @decorations <<  { x:29 , y: 28, tile_key: :vpath }
    @decorations <<  { x:29 , y: 29, tile_key: :vpath }
    @decorations <<  { x:29 , y: 30, tile_key: :pathendtop } #end of path

    @decorations <<  { x:29 , y: 19, tile_key: :vpath }
    @decorations <<  { x:29 , y: 18, tile_key: :vpath2 }
    @decorations <<  { x:29 , y: 17, tile_key: :vpath }
    @decorations <<  { x:29 , y: 16, tile_key: :vpath2 }
    @decorations <<  { x:29 , y: 15, tile_key: :vpath }
    @decorations <<  { x:29 , y: 14, tile_key: :vpath2 }
    @decorations <<  { x:29 , y: 13, tile_key: :vpath }
    @decorations <<  { x:29 , y: 12, tile_key: :vpath }
    @decorations <<  { x:29 , y: 11, tile_key: :vpath }
    @decorations <<  { x:29 , y: 10, tile_key: :pathendbottom } #end of path

    @decorations <<  { x:18 , y: 30, tile_key: :nedirt }
    @decorations <<  { x:39 , y: 30, tile_key: :nwdirt }
    @decorations <<  { x:18 , y: 10, tile_key: :sedirt }
    @decorations <<  { x:39 , y: 10, tile_key: :swdirt }
  end

  def gain_mana?
    if $player_choice == 'hero'
      args.state.tick_count % 5 == 0
    elsif $player_choice == 'archer'
      args.state.tick_count % 4 == 0
    elsif $player_choice == 'wizard'
      args.state.tick_count % 3 == 0
    end
  end
end