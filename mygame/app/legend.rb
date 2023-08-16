def tick_legend args

  legend_padding = 16
  legend_x = PADDING_X
  legend_y = PADDING_Y

  if args.inputs.mouse.point.inside_rect? args.outputs.borders[0]
    mouse_row = args.inputs.mouse.point.y.idiv(SOURCE_TILE_SIZE)
    tile_y = (mouse_row - legend_y.idiv(SOURCE_TILE_SIZE) - 1)

    mouse_col = args.inputs.mouse.point.x.idiv(SOURCE_TILE_SIZE)
    tile_x = (mouse_col - legend_x.idiv(SOURCE_TILE_SIZE) - 1)


    sprite_key = find_sprite(tile_x, tile_y)  # $sprite_tiles.sprite_lookup.find { |k, v| v == [tile_x, tile_y] }
    if sprite_key
      sprite_key.each_with_index do |log, index|
        args.outputs.labels << [885, (150 - (index*20)) , "#{log}", -4,]
      end      
    # else
    #   args.outputs.labels << [660, 50, "Tile [#{tile_x}, #{tile_y}] not found.", -1, 0]
    end

  end

  def find_sprite(x, y)
    wall = $my_game.find_same_square_group(x, y, $gtk.args.state.walls)
    return wall.tree_type ? ['A Tree'] : ['A Wall'] if wall

    friend = $my_game.find_same_square_group(x, y, $gtk.args.state.goodies)
    return [friend.type, "#{friend.hp} hps", "#{friend.atk} Attack"] if friend

    enemy = $my_game.find_same_square_group(x, y, $gtk.args.state.enemies)
    return [enemy.type, "#{enemy.hp} hps", "#{enemy.atk} Attack"] if enemy

    hotpot = $my_game.check_if_same_square?(x,y, $gtk.args.state.hotpot)
    return ["The fabled HOTPOT protect it at all costs!"] if hotpot

    you = $my_game.check_if_same_square?(x,y, $gtk.args.state.player)
    return ["Its You, don't you look cute?"] if you

  end
end
