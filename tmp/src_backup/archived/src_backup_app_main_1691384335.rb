def tick args
  args.state.player ||= {
    x: 120,
    y: 280,
    w: 100,
    h: 80,
    speed: 12,
    path: 'sprites/misc/dragon-0.png',
  }
  args.state.fireballs ||= []

  if args.inputs.left
    args.state.player.x -= args.state.player.speed
  elsif args.inputs.right
    args.state.player.x += args.state.player.speed
  end

  if args.inputs.up
    args.state.player.y += args.state.player.speed
  elsif args.inputs.down
    args.state.player.y -= args.state.player.speed
  end

  args.state.player.x = args.state.player.x.clamp(0, args.grid.w - args.state.player.w)
  args.state.player.y = args.state.player.y.clamp(0, args.grid.h - args.state.player.h)

  if args.inputs.keyboard.key_down.z ||
      args.inputs.keyboard.key_down.j ||
      args.inputs.controller_one.key_down.a
    args.state.fireballs << {
      x: args.state.player.x,
      y: args.state.player.y,
      text: 'fireball',
    }
  end

  args.state.fireballs.each do |fireball|
    fireball.x += args.state.player.speed + 2
  end

  args.outputs.labels << args.state.fireballs
  args.outputs.sprites << args.state.player
end
