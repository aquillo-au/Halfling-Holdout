class FindPath
  attr_gtk

  def initialize(enemy, player, walls)
    # Variables to edit the size and appearance of the grid
    @enemy = enemy
    # Freely customizable to user's liking
    @width = 61
    @height = 43
    @rect = [0, 0, @width, @height]
    @walls = walls

    @target = [enemy.x, enemy.y]
    @star = [player.x, player.y]

    # What the user is currently editing on the grid
    # We store this value, because we want to remember the value even when
    # the user's cursor is no longer over what they're interacting with, but
    # they are still clicking down on the mouse.

    # These variables allow the breadth first search to take place
    # Came_from is a hash with a key of a cell and a value of the cell that was expanded from to find the key.
    # Used to prevent searching cells that have already been found
    # and to trace a path from the target back to the starting point.
    # Frontier is an array of cells to expand the search from.
    # The search is over when there are no more cells to search from.
    # Path stores the path from the target to the star, once the target has been found
    # It prevents calculating the path every tick.
    @came_from = {}
    @cost_so_far = {}
    @frontier = []
  end

  # All methods with render draw stuff on the screen
  # UI has buttons, the slider, and labels
  # The search specific rendering occurs in the respective methods

  # Determines what the user is editing
  # This method is called when the mouse is clicked down


 
  # Returns the rect for the path between two cells based on their relative positions
  def get_path_between(cell_one, cell_two)
    path = []

    # If cell one is above cell two
    if cell_one.x == cell_two.x && cell_one.y > cell_two.y
      # Path starts from the center of cell two and moves upward to the center of cell one
      path = [cell_two.x, cell_two.y]
    # If cell one is below cell two
    elsif cell_one.x == cell_two.x && cell_one.y < cell_two.y
      # Path starts from the center of cell one and moves upward to the center of cell two
      path = [cell_one.x, cell_one.y]
    # If cell one is to the left of cell two
    elsif cell_one.x > cell_two.x && cell_one.y == cell_two.y
      # Path starts from the center of cell two and moves rightward to the center of cell one
      path = [cell_two.x, cell_two.y]
    # If cell one is to the right of cell two
    elsif cell_one.x < cell_two.x && cell_one.y == cell_two.y
      # Path starts from the center of cell one and moves rightward to the center of cell two
      path = [cell_one.x, cell_one.y]
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
         unless @came_from.key?(neighbor) # or args.state.walls.key?(neighbor)
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
    next_endpoint = @came_from[endpoint]

    # Draw a path between these two cells and store it
    get_path_between(endpoint, next_endpoint)
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

  # Methods that allow code to be more concise. Subdivides args.state, which is where all variables are stored.
end


# Method that is called by DragonRuby periodically
# Used for updating animations and calculations
# def tick args

#   # Pressing r will reset the application
#   if args.inputs.keyboard.key_down.r
#     args.gtk.reset
#     reset
#     return
#   end

#   # Every tick, new args are passed, and the Breadth First Search tick is called
#   $a_star_algorithm ||= A_Star_Algorithm.new
#   $a_star_algorithm.args = args
#   $a_star_algorithm.tick
# end


def reset
  $a_star_algorithm = nil
end
