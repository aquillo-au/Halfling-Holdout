class FindPath

  def initialize(enemy, target, walls)

    @enemy = enemy
    @width = 61
    @height = 43
    @rect = [0, 0, @width, @height]
    array = walls.map {|wall| [wall.x, wall.y] }
    @walls = {}
    array.each{|key| @walls[key] = true}
    @me = [enemy.x, enemy.y]
    @target = [target.x, target.y]

    @came_from = {}
    @cost_so_far = {}
    @frontier = []
  end

  def find_me
    # Setup the search to start from the target
    @came_from[@target] = nil
    @cost_so_far[@target] = 0
    @frontier << @target

    # Until there are no more cells to explore from or the search has found the target
    until @frontier.empty? or @came_from.key?(@me)
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
    if @came_from.key?(@me)
      # Calculate the path between the target and start
      find_path
    end
  end

  # Calculates the path between the target and me
  # Only called when the search finds the target
  def find_path
    # Start from me
    endpoint = @me
    # And the cell it came from
    #next_endpoint = 
    @came_from[endpoint]
    
  end

  def check_distance
    # Setup the search to start from the target
    @came_from[@target] = nil
    @cost_so_far[@target] = 0
    @frontier << @target

    # Until there are no more cells to explore from or the search has found me
    until @frontier.empty? or @came_from.key?(@me)
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
      # makes it much slower
      # @frontier = @frontier.sort_by {| cell | proximity_to_star(cell) }
    end

    # If the search found me
    if @came_from.key?(@me)
      # tell my how far it was
      @cost_so_far[current_frontier]
    end
   
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
    distance_x = (@target.x - cell.x).abs
    distance_y = (@target.y - cell.y).abs

    if distance_x > distance_y
      return distance_x
    else
      return distance_y
    end
  end
end


