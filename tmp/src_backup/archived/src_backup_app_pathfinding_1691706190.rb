class FindPath
  attr_gtk

  def initialize(enemy, player, walls)

    @enemy = enemy
    @width = 61
    @height = 43
    @rect = [0, 0, @width, @height]
    array = walls.map {|wall| [wall.x, wall.y] }
    @walls = {}
    array.each{|key| @walls[key] = true}
    @target = [enemy.x, enemy.y]
    @star = [player.x, player.y]

    @came_from = {}
    @cost_so_far = {}
    @frontier = []
  end



 
  # Returns the rect for the path between two cells based on their relative positions
  def get_path_between(cell_one, cell_two)
    path = []

    # If cell one is above cell two
    if cell_one.x == cell_two.x && cell_one.y > cell_two.y
      # Path starts from cell two and moves upward to cell one
      path = [cell_two.x, cell_two.y]
    # If cell one is below cell two
    elsif cell_one.x == cell_two.x && cell_one.y < cell_two.y
      # Path starts from cell one and moves upward to cell two
      path = [cell_two.x, cell_two.y]
    # If cell one is to the left of cell two
    elsif cell_one.x > cell_two.x && cell_one.y == cell_two.y
      # Path starts from cell two and moves rightward to cell one
      path = [cell_two.x, cell_two.y]
    # If cell one is to the right of cell two
    elsif cell_one.x < cell_two.x && cell_one.y == cell_two.y
      # Path starts from cell one and moves rightward to cell two
      path = [cell_two.x, cell_two.y]
    end

    path
  end



  def calc_searches
    calc_a_star
    # Move the searches forward to the current step
    # state.current_step.times { move_searches_one_step_forward }
  end
  def calc_a_star
    # Setup the search to start from the star
    @came_from[@star] = nil
    @cost_so_far[@star] = 0
    @frontier << @star

    # Until there are no more cells to explore from or the search has found the target
    until @frontier.empty? or @came_from.key?(@target)
      # Get the next cell to expand from
      current_frontier = @frontier.shift

      # For each of that cells neighbors
      adjacent_neighbors(current_frontier).each do | neighbor |
        # That have not been visited and are not walls
         unless @came_from.key?(neighbor) || @walls.key?(neighbor) 
          # Add them to the frontier and mark them as visited
          @frontier << neighbor
          @came_from[neighbor] = current_frontier
          @cost_so_far[neighbor] = @cost_so_far[current_frontier] + 1
        end
      end

      # Sort the frontier so that cells that are in a zigzag pattern are prioritized over those in an line
      # Comment this line and let a path generate to see the difference
      @frontier = @frontier.sort_by {| cell | proximity_to_star(cell) }
    end

    # If the search found the target
    if @came_from.key?(@target)
      # Calculate the path between the target and star
      a_star_calc_path
    end
  end

  # Calculates the path between the target and star for the a_star search
  # Only called when the a_star search finds the target
  def a_star_calc_path
    # Start from the target
    endpoint = @target
    # And the cell it came from
    #next_endpoint = 
    @came_from[endpoint]
    
  end

  def check_closest
    # Start from the target
    endpoint = @target
    # And the cell it came from
    next_endpoint = @came_from[endpoint]
    path_length = []
    while endpoint && next_endpoint
      # Draw a path between these two cells and store it
      path = get_path_between(endpoint, next_endpoint)
      path_length << path
      # And get the next pair of cells
      endpoint = next_endpoint
      next_endpoint = @came_from[endpoint]
      # Continue till there are no more cells
    end
    path_length
  end

  # Returns a list of adjacent cells
  # Used to determine what the next cells to be added to the frontier are
  def adjacent_neighbors(cell)
    neighbors = []

    # Gets all the valid neighbors into the array
    # From southern neighbor, clockwise
    neighbors << [cell.x    , cell.y - 1] unless cell.y == 0
    neighbors << [cell.x - 1, cell.y    ] unless cell.x == 0
    neighbors << [cell.x    , cell.y + 1] unless cell.y == @height - 1
    neighbors << [cell.x + 1, cell.y    ] unless cell.x == @width - 1

    neighbors
  end

  # Finds the vertical and horizontal distance of a cell from the star
  # and returns the larger value
  # This method is used to have a zigzag pattern in the rendered path
  # A cell that is [5, 5] from the star,
  # is explored before over a cell that is [0, 7] away.
  # So, if possible, the search tries to go diagonal (zigzag) first
  def proximity_to_star(cell)
    distance_x = (@star.x - cell.x).abs
    distance_y = (@star.y - cell.y).abs

    if distance_x > distance_y
      return distance_x
    else
      return distance_y
    end
  end
end


