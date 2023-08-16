def tick args
  args.state.player_x ||= 120
  args.state.player_y ||= 280
  args.state.fireballs ||= []
  speed = 12
  player_w = 100
  player_h = 80

  if args.inputs.left
    speed -= 6 if args.inputs.down || args.inputs.up
    args.state.player_x -= speed
  elsif args.inputs.right
    speed -= 6 if args.inputs.down || args.inputs.up
    args.state.player_x += speed
  end

  args.state.player_x = args.state.player_x.clamp(0, args.grid.w - player_w)

  if args.inputs.down
    args.state.player_y -= speed
  elsif args.inputs.up
    args.state.player_y += speed
  end

  args.state.player_y = args.state.player_y.clamp(0, args.grid.h - player_h)

  if args.inputs.keyboard.key_down.z || args.inputs.keyboard.key_down.j || args.inputs.controller_one.key_down.a
    args.state.fireballs << [args.state.player_x, args.state.player_y, 'fireball']
  end

  args.outputs.labels << args.state.fireballs

  args.state.fireballs.each do |fireball|
    fireball[0] += speed + 2
  end

  args.outputs.sprites << [args.state.player_x, args.state.player_y, 100, 80, 'sprites/misc/dragon-0.png']
end
