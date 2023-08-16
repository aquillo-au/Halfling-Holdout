class BasicPath

  def initialize(mover, target, walls)
    @walls = walls.to_h {|wall| [[wall.x, wall.y], true] }
    @me = [mover.x, mover.y]
    @target = [target.x, target.y]
  end

  def move_step
    axis = x_or_y
    new_postion = check_direction(axis)
    if @walls.key?(new_postion) 
      axis == 'x'? new_postion = check_direction('y') : new_postion = check_direction('x')
    end
    new_postion
  end

  def x_or_y
    # move the axis we are furthest from
    if (@me.x - @target.x).abs < (@me.y - @target.y).abs
      return 'y'
    else
      'x'
    end
  end

  def check_direction(axis)
    if axis == 'x'
       #postive is right, negative is left
      if (@me.x - @target.x).positive?
        move_to = [mover.x + 1, mover.y ]
      else
        move_to = [mover.x - 1, mover.y ]
      end
    else
      #postive is down, negative is up
      if (@me.y - @target.y).positive?
        move_to = [mover.x, mover.y + 1]
      else
        move_to = [mover.x, mover.y - 1]
      end
    end
    move_to
  end

  # Returns a list of adjacent cells
  # Used to determine what the next cells to be added to the frontier are
  def adjacent_neighbors(cell)
    neighbors = []

    # Gets all the valid neighbors into the array
    # From southern neighbor, clockwise
    neighbors << [cell.x    , cell.y - 1]
    neighbors << [cell.x - 1, cell.y    ]
    neighbors << [cell.x    , cell.y + 1]
    neighbors << [cell.x + 1, cell.y    ]

    neighbors
  end
end


