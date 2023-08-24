def tick_legend args

  legend_padding = 16
  legend_x = PADDING_X
  legend_y = PADDING_Y

  if args.inputs.mouse.point.inside_rect? args.outputs.borders[0]
    mouse_row = args.inputs.mouse.point.y.idiv(SOURCE_TILE_SIZE)
    tile_y = (mouse_row - legend_y.idiv(SOURCE_TILE_SIZE) - 1)

    mouse_col = args.inputs.mouse.point.x.idiv(SOURCE_TILE_SIZE)
    tile_x = (mouse_col - legend_x.idiv(SOURCE_TILE_SIZE) - 1)

    sprite_key = find_sprite(tile_x, tile_y)
   

    if sprite_key
      sprite_key.each_with_index do |log, index|
        args.outputs.labels << [885, (175 - (index*20)) , "#{log}", -4,] unless index == 0
        args.outputs.labels << [args.grid.w - 45, 155, "(#{log})", -5, 2] if index == 0 && log != ''
      end
    end

  end




  def find_sprite(x, y)
    wall = $my_game.find_same_square_group(x, y, $gtk.args.state.walls)
    return wall.tree_type ? ['','A Tree'] : ['','A Wall'] if wall

    friend = $my_game.find_same_square_group(x, y, $gtk.args.state.goodies)
    return ['Friendly',friend.type, "#{friend.hp} hps", "#{friend.atk[0]}d#{friend.atk[1]} Attack", "#{friend.armor} Armor"] if friend

    hut = $my_game.find_same_square_group(x, y, $gtk.args.state.huts)
    return ['Friendly', 'hut', "#{hut.hp} hps", "#{hut.armor} Armor"] if hut

    enemy = $my_game.find_same_square_group(x, y, $gtk.args.state.enemies)
    return ['Enemy',enemy.type, "#{enemy.hp} hps", "#{enemy.atk[0]}d#{enemy.atk[1]} Attack", "#{enemy.armor} Armor"] if enemy

    other = $my_game.find_same_square_group(x, y, $gtk.args.state.others)
    return ['Neutral',other.type, "#{other.hp} hps", "#{other.atk[0]}d#{other.atk[1]} Attack", "#{other.armor} Armor"] if other

    arrow = $my_game.find_same_square_group(x, y, $gtk.args.state.arrows)
    return ['Friendly', "An Arrow", "1d6 Attack"] if arrow

    bolt = $my_game.find_same_square_group(x, y, $gtk.args.state.bolts)
    return ['Enemy', "A Bolt", "1d5 Attack"] if bolt    

    fireball = $my_game.find_same_square_group(x, y, $gtk.args.state.fireballs)
    return ['Friendly', "A Fireball", "3d3 Attack"] if fireball

    hotpot = $my_game.check_if_same_square?(x,y, $gtk.args.state.hotpot)
    return ['',"The fabled HOTPOT", "Protect it at all costs!", "It has #{$gtk.args.state.hotpot.armor} Armor"] if hotpot

    you = $my_game.check_if_same_square?(x,y, $gtk.args.state.player)
    return ['',"Its You", "don't you look cute?"] if you

    false
  end
end
