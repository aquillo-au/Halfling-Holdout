FPS = 60
HIGH_SCORE_FILE = "high-score.txt"

def pause_tick args
  args.audio[:music].paused = true
  label = {
    x: 40,
    y: args.grid.h - 88,
    text: "Press P to resume the game",
  }
  if args.inputs.keyboard.key_down.p
    args.state.scene = "gameplay"
    args.audio[:music].paused = false
  end

  args.outputs.labels << label
end

def title_tick args
  args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i
  if fire_input?(args)
    args.outputs.sounds << "sounds/game-over.wav"
    args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
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
    text: "Target Practice",
    size_enum: 6,
  }
  labels << {
    x: 40,
    y: args.grid.h - 88,
    text: "Hit the targets!",
  }
  labels << {
    x: 40,
    y: args.grid.h - 120,
    text: "by Aquillo",
  }
  labels << {
    x: 40,
    y: 120,
    text: "Arrows or WASD to move | Z or J to fire | P to pause | gamepad works too",
  }
  labels << {
    x: 40,
    y: 80,
    text: "Fire to start",
    size_enum: 2,
  }
  labels << {
    x: args.grid.w - 260,
    y: args.grid.h - 90,
    text: "Score to beat: #{args.state.high_score}",
    size_enum: 3,
  }
  args.outputs.labels << labels
end

def spawn_target(args)
  size = 64
  {
    x: rand(args.grid.w * 0.4) + args.grid.w * 0.6 - size,
    y: rand(args.grid.h - size * 2) + size,
    w: size,
    h: size,
    path: 'sprites/target.png',
  }
end

def spawn_cloud(args)
  size = rand(60).clamp(25, 60)
  x_spot = args.grid.w
  sprite = 'sprites/cloud.png'
  if args.state.tick_count < 3
    x_spot = rand(args.grid.w - size * 2) + size
  end
  if args.state.tick_count % 3 == 0
    sprite = 'sprites/cloud_2.png'
  elsif args.state.tick_count % 4 == 0
    sprite = 'sprites/cloud_3.png'
  end
  {
    x: x_spot,
    y: rand(args.grid.h * 0.75) + args.grid.h * 0.25 - size,
    w: size,
    h: size,
    path: sprite,
  }
end

def fire_input?(args)
  args.inputs.keyboard.key_down.z ||
    args.inputs.keyboard.key_down.j ||
    args.inputs.controller_one.key_down.a
end  

def handle_player_movement(args)
  current_speed = args.state.player.speed
  if args.inputs.left
    if args.inputs.up || args.inputs.down
      current_speed = current_speed / 2
    end
    args.state.player.x -= current_speed
  elsif args.inputs.right
    if args.inputs.up || args.inputs.down
      current_speed = current_speed / 2
    end
    args.state.player.x += current_speed
  end

  if args.inputs.up
    args.state.player.y += current_speed
  elsif args.inputs.down
    args.state.player.y -= current_speed
  end

  args.state.player.x = args.state.player.x.clamp(0, args.grid.w - args.state.player.w)
  args.state.player.y = args.state.player.y.clamp(0, args.grid.h - args.state.player.h)
end

def game_over_tick(args)
  args.state.high_score ||= args.gtk.read_file(HIGH_SCORE_FILE).to_i

  args.state.timer -= 1

  if !args.state.saved_high_score && args.state.score > args.state.high_score
    args.gtk.write_file(HIGH_SCORE_FILE, args.state.score.to_s)
    args.state.saved_high_score = true
  end
  labels = []
  if args.state.score > args.state.high_score
    labels << {
      x: 260,
      y: args.grid.h - 90,
      text: "New high-score!",
      size_enum: 3,
    }
  else
    labels << {
      x: 260,
      y: args.grid.h - 90,
      text: "Score to beat: #{args.state.high_score}",
      size_enum: 3,
    }
  end
  labels << {
    x: 40,
    y: args.grid.h - 40,
    text: "Game Over!",
    size_enum: 10,
  }
  labels << {
    x: 40,
    y: args.grid.h - 90,
    text: "Score: #{args.state.score}",
    size_enum: 4,
  }
  labels << {
    x: 40,
    y: args.grid.h - 132,
    text: "Fire to restart",
    size_enum: 2,
  }
  args.outputs.labels << labels

  if args.state.timer < -30 && fire_input?(args)
    args.audio[:music] = { input: "sounds/flight.ogg", looping: true }
    args.state.timer = 30 * FPS
    args.state.scene = "gameplay"
    return
  end
end

def gameplay_tick(args)
  args.outputs.solids << {
    x: 0,
    y: 0,
    w: args.grid.w,
    h: args.grid.h,
    r: 92,
    g: 120,
    b: 230,
  }
  args.state.player ||= {
    x: 120,
    y: 280,
    w: 100,
    h: 80,
    speed: 12,
  }
  player_sprite_index = 0.frame_index(count: 6, hold_for: 14, repeat: true)
  args.state.player.path = "sprites/misc/dragon-#{player_sprite_index}.png"

  args.state.fireballs ||= []
  args.state.targets ||= [
    spawn_target(args),
    spawn_target(args),
    spawn_target(args),
  ]
  args.state.score ||= 0
  args.state.timer ||= 30 * FPS
  args.state.timer -= 1

  if args.state.timer == 0
    args.audio[:music].paused = true
    args.outputs.sounds << "sounds/game-over.wav"
    args.state.scene = "game_over"
  end

  if args.inputs.keyboard.key_down.p
    args.state.scene = "pause"
  end

  handle_player_movement(args)

  if fire_input?(args)
    args.state.fireballs << {
      x: args.state.player.x + args.state.player.w - 12,
      y: args.state.player.y + 10,
      w: 32,
      h: 32,
      path: 'sprites/fireball.png',
    }
    args.outputs.sounds << "sounds/fireball.wav"
  end

  args.state.clouds.each do |cloud|
    cloud.x -= args.state.player.speed / 12
    if cloud.x < 0
      cloud.dead = true
      next
    end
  end    
  args.state.fireballs.each do |fireball|
    fireball.x += args.state.player.speed + 2
    if fireball.x > args.grid.w
      fireball.dead = true
      args.state.score -= 1
      next
    end
    args.state.targets.each do |target|
      if args.geometry.intersect_rect?(target, fireball)
        args.outputs.sounds << "sounds/target.wav"
        target.dead = true
        fireball.dead = true
        args.state.score += 2
        new_target = spawn_target(args)
        args.state.targets.each do |target|
          if args.geometry.intersect_rect?(target, new_target)
            new_target = spawn_target(args)
          end
        end
        args.state.targets << new_target
      end
    end  
  end
  
  args.state.targets.reject! { |t| t.dead }
  args.state.fireballs.reject! { |f| f.dead }
  args.state.clouds.reject! { |c| c.dead }
  if args.state.clouds.size < 8
    args.state.clouds << spawn_cloud(args)
  end

  args.outputs.sprites << [args.state.clouds, args.state.player, args.state.fireballs, args.state.targets ]
  args.outputs.solids << {
    x: args.grid.w - 200,
    y: args.grid.h - 65,
    w: 165,
    h: 25,
    r: 100,
    g: 150,
    b: 0,
  }
  args.outputs.solids << {
    x: 40,
    y: args.grid.h - 65,
    w: 118,
    h: 25,
    r: 100,
    g: 150,
    b: 0,
  }
  labels = []
  labels << {
    x: 40,
    y: args.grid.h - 40,
    text: "Score: #{args.state.score}",
    size_enum: 4,
  }
  labels << {
    x: args.grid.w - 40,
    y: args.grid.h - 40,
    text: "Time Left: #{(args.state.timer / FPS).round}",
    size_enum: 2,
    alignment_enum: 2,
  }
  args.outputs.labels << labels
end
  
def tick args
  if args.state.tick_count == 1
    
  end 

  args.state.scene ||= "title"

  send("#{args.state.scene}_tick", args)

end

$gtk.reset