def tick args
  args.state.player_x ||= 120
  args.state.player_y ||= 280
  speed = 12
  player_w = 100
  player_h = 80

  if args.inputs.left && !args.inputs.down
    args.state.player_x -= speed
  elsif args.inputs.right
    args.state.player_x += speed
  end

  args.state.player_x = args.state.player_x.clamp(0, args.grid.w - player_w)

  if args.inputs.down
    args.state.player_y -= speed
  elsif args.inputs.up
    args.state.player_y += speed
  end

  args.state.player_y = args.state.player_y.clamp(0, args.grid.h - player_h)

  args.outputs.sprites << [args.state.player_x, args.state.player_y, 100, 80, 'sprites/misc/dragon-0.png']
end
