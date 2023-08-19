class SpriteGrid
  def initialize
    $gtk.args.state.reserved.sprite_lookup = sprite_lookup
  end
  
  def sprite_lookup
    {
      warrior: [0, 2],
      hero: [0,1],
      archer: [0,3],
      A: [ 4,  1],
      B: [ 4,  2],
      C: [ 4,  3],
      D: [ 4,  4],
      E: [ 4,  5],
      F: [ 4,  6],
      G: [ 4,  7],
      H: [ 4,  8],
      I: [ 4,  9],
      J: [ 4, 10],
      K: [ 4, 11],
      L: [ 4, 12],
      M: [ 4, 13],
      N: [ 4, 14],
      O: [ 4, 15],
      P: [ 5,  0],
      Q: [ 5,  1],
      R: [ 5,  2],
      S: [ 5,  3],
      T: [ 5,  4],
      U: [ 5,  5],
      V: [ 5,  6],
      W: [ 5,  7],
      X: [ 5,  8],
      Y: [ 5,  9],
      Z: [ 5, 10],
      a: [ 6,  1],
      b: [ 6,  2],
      c: [ 6,  3],
      d: [ 6,  4],
      e: [ 6,  5],
      f: [ 6,  6],
      g: [ 6,  7],
      h: [ 6,  8],
      i: [ 6,  9],
      j: [ 6, 10],
      k: [ 6, 11],
      l: [ 6, 12],
      m: [ 6, 13],
      n: [ 6, 14],
      o: [ 6, 15],
      p: [ 7,  0],
      q: [ 7,  1],
      r: [ 7,  2],
      s: [ 7,  3],
      t: [ 7,  4],
      u: [ 7,  5],
      v: [ 7,  6],
      w: [ 7,  7],
      x: [ 7,  8],
      y: [ 7,  9],
      z: [ 7, 10],
      '|' => [ 7, 12],
      wall: [11, 10],
      bush: [1,2],
      tree: [1,3],
      tree2: [1,4],
      tree3: [1,5],
      hpath: [3,0],
      pathendleft: [2,0],
      pathendright: [2,1],
      pathendbottom: [2,2],
      pathendtop: [2,3],
      hpath2: [3,1],
      vpath: [3,2],
      vpath2: [3,3],
      xpath: [3,4],
      grass: [3,5],
      grass2: [3,6],
      grass3: [3,7],
      grass4: [3,8],
      grass5: [2,8],
      grass6: [2,7],
      dirt: [3,9],
      dirt2: [2,9],
      dirt3: [2,10],
      dirt4: [2,11],
      dirttop: [3,10],
      dirtright: [3,11],
      dirtbottom: [3,12],
      dirtleft: [3,13],
      sedirt: [3,14],
      nedirt: [3,15],
      nwdirt: [2,15],
      swdirt: [2,14],
      necorn: [12,9],
      secorn: [12,8],
      nwcorn: [11,11],
      swcorn: [11,12],
      hwall: [12,13],
      sarrow: [1,9],
      warrow: [1,8],
      darrow: [1,10],
      aarrow: [1,11],
    }
  end

  def sprite key
    $gtk.args.state.reserved.sprite_lookup[key]
  end

  def member_name_as_code raw_member_name
    if raw_member_name.is_a? Symbol
      ":#{raw_member_name}"
    elsif raw_member_name.is_a? String
      "'#{raw_member_name}'"
    elsif raw_member_name.is_a? Fixnum
      "#{raw_member_name}"
    else
      "UNKNOWN: #{raw_member_name}"
    end
  end

  def tile x, y, tile_row_column_or_key
    tile_extended x, y, DESTINATION_TILE_SIZE, DESTINATION_TILE_SIZE, tile_row_column_or_key
  end

  def tile_extended x, y, w, h, tile_row_column_or_key
    row_or_key, column = tile_row_column_or_key
    if !column
      row, column = sprite row_or_key
    else
      row, column = row_or_key, column
    end

    if !row
      member_name = member_name_as_code tile_row_column_or_key
      raise "Unabled to find a sprite for #{member_name}. Make sure the value exists in app/sprite_lookup.rb."
    end

    # Sprite provided by Rogue Yun
    # http://www.bay12forums.com/smf/index.php?topic=144897.0
    # License: Public Domain

    {
      x: x,
      y: y,
      w: w,
      h: h,
      tile_x: column * 16,
      tile_y: (row * 16),
      tile_w: 16,
      tile_h: 16,
      path: 'sprites/simple-mood-16x16.png'
    }
  end
end
