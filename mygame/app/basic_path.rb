class BasicPath

  def initialize(mover, target, walls, friends = nil)
    @walls = walls.to_h {|wall| [[wall.x, wall.y], true] }
    @me = [mover.x, mover.y]
    @target = [target.x, target.y]
    @friends = friends.to_h {|friend| [[friend.x, friend.y], true] }
  end
  
  def random_direction
    direction = rand(4)
    case direction
    when 1
      return [@me.x + 1, @me.y]
    when 2
      return [@me.x - 1, @me.y]
    when 3
      return [@me.x, @me.y + 1]
    else
      return [@me.x, @me.y - 1]
    end
  end

  def move_step
    axis = x_or_y
    new_postion = check_direction(axis)
    if @walls.key?(new_postion)  || @friends.key?(new_postion)
      axis == 'x'? new_postion = check_direction('y') : new_postion = check_direction('x')
    end
    new_postion
  end

  def take_aim
    axis = x_or_y
    check_aim(axis)
  end

  private

  def x_or_y
    random = rand(100)
    # move the axis we are furthest from
    if (@me.x - @target.x).abs < (@me.y - @target.y).abs
      if (@me.x - @target.x) == 0 || random > 25
        return 'y'
      else
        return 'x' 
      end
    elsif (@me.y - @target.y) == 0 || random > 25
      return 'x'
    else
      return 'y'
    end
  end

  def check_aim(axis)
    if axis == 'x'
       #postive is right, negative is left
      if (@me.x - @target.x).positive?
        aim_towards = 'a'
      else
        aim_towards = 'd'
      end
    else
      #postive is down, negative is up
      if (@me.y - @target.y).positive?
        aim_towards = 's'
      else
        aim_towards = 'w'
      end
    end
    aim_towards
  end

  def check_direction(axis)
    if axis == 'x'
       #postive is right, negative is left
      if (@me.x - @target.x).positive?
        move_to = [@me.x - 1, @me.y ]
      else
        move_to = [@me.x + 1, @me.y ]
      end
    else
      #postive is down, negative is up
      if (@me.y - @target.y).positive?
        move_to = [@me.x, @me.y - 1]
      else
        move_to = [@me.x, @me.y + 1]
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


