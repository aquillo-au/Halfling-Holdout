def tick args
  args.state.player_x ||= 120
  args.state.player_y ||= 280

  if args.inputs.left
    args.state.player_x -= 10
  elsif args.inputs.right
    args.state.player_x += 10
  end

  if args.inputs.down
    args.state.player_y -= 10
  elsif args.inputs.up
    args.state.player_x += 10
  end

  args.outputs.sprites << [args.state.player_x, args.state.player_y, 100, 80, 'sprites/misc/dragon-0.png']
end
