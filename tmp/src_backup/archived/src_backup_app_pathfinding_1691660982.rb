# Contributors outside of DragonRuby who also hold Copyright:
# - Sujay Vadlakonda: https://github.com/sujayvadlakonda

# This program is inspired by https://www.redblobgames.com/pathfinding/a-star/introduction.html

# The A* Search works by incorporating both the distance from the starting point
# and the distance from the target in its heurisitic.

# It tends to find the correct (shortest) path even when the Greedy Best-First Search does not,
# and it explores less of the grid, and is therefore faster, than Dijkstra's Search.


class A_Star_Algorithm
  attr_gtk

  def tick
    defaults
    render
    input

    if dijkstra.came_from.empty?
      calc_searches
    end
  end

  def defaults
    # Variables to edit the size and appearance of the grid
    # Freely customizable to user's liking
    grid.width     ||= 15
    grid.height    ||= 15
    grid.cell_size ||= 27
    grid.rect      ||= [0, 0, grid.width, grid.height]

    grid.star      ||= [0, 2]
    grid.target    ||= [11, 13]
    grid.walls     ||= {
      [2, 2] => true,
      [3, 2] => true,
      [4, 2] => true,
      [5, 2] => true,
      [6, 2] => true,
      [7, 2] => true,
      [8, 2] => true,
      [9, 2] => true,
      [10, 2] => true,
      [11, 2] => true,
      [12, 2] => true,
      [12, 3] => true,
      [12, 4] => true,
      [12, 5] => true,
      [12, 6] => true,
      [12, 7] => true,
      [12, 8] => true,
      [12, 9] => true,
      [12, 10] => true,
      [12, 11] => true,
      [12, 12] => true,
      [5, 12] => true,
      [6, 12] => true,
      [7, 12] => true,
      [8, 12] => true,
      [9, 12] => true,
      [10, 12] => true,
      [11, 12] => true,
      [12, 12] => true
    }

    # What the user is currently editing on the grid
    # We store this value, because we want to remember the value even when
    # the user's cursor is no longer over what they're interacting with, but
    # they are still clicking down on the mouse.
    state.user_input ||= :none

    # These variables allow the breadth first search to take place
    # Came_from is a hash with a key of a cell and a value of the cell that was expanded from to find the key.
    # Used to prevent searching cells that have already been found
    # and to trace a path from the target back to the starting point.
    # Frontier is an array of cells to expand the search from.
    # The search is over when there are no more cells to search from.
    # Path stores the path from the target to the star, once the target has been found
    # It prevents calculating the path every tick.

    a_star.frontier    ||= []
    a_star.came_from   ||= {}
    a_star.path        ||= []
    a_star.cost_so_far ||= {}
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
      path = [cell_two.x + 0.3, cell_two.y + 0.3, 0.4, 1.4]
    # If cell one is below cell two
    elsif cell_one.x == cell_two.x && cell_one.y < cell_two.y
      # Path starts from the center of cell one and moves upward to the center of cell two
      path = [cell_one.x + 0.3, cell_one.y + 0.3, 0.4, 1.4]
    # If cell one is to the left of cell two
    elsif cell_one.x > cell_two.x && cell_one.y == cell_two.y
      # Path starts from the center of cell two and moves rightward to the center of cell one
      path = [cell_two.x + 0.3, cell_two.y + 0.3, 1.4, 0.4]
    # If cell one is to the right of cell two
    elsif cell_one.x < cell_two.x && cell_one.y == cell_two.y
      # Path starts from the center of cell one and moves rightward to the center of cell two
      path = [cell_one.x + 0.3, cell_one.y + 0.3, 1.4, 0.4]
    end

    path
  end

  # Moves the star to the cell closest to the mouse in the third grid
  # Only resets the search if the star changes position
  # Called whenever the user is editing the star (puts mouse down on star)
  def process_input_a_star_star
    old_star = grid.star.clone
    unless a_star_cell_closest_to_mouse == grid.target
      grid.star = a_star_cell_closest_to_mouse
    end
    unless old_star == grid.star
      reset_searches
    end
  end

  # Moves the target to the cell closest to the mouse in the third grid
  # Only reset_searchess the search if the target changes position
  # Called whenever the user is editing the target (puts mouse down on target)
  def process_input_a_star_target
    old_target = grid.target.clone
    unless a_star_cell_closest_to_mouse == grid.star
      grid.target = a_star_cell_closest_to_mouse
    end
    unless old_target == grid.target
      reset_searches
    end
  end

  def reset_searches
    # Reset the searches
    a_star.came_from = {}
    a_star.frontier  = []
    a_star.path      = []
  end

  def calc_searches
    calc_a_star
    # Move the searches forward to the current step
    # state.current_step.times { move_searches_one_step_forward }
  end
  def calc_a_star
    # Setup the search to start from the star
    a_star.came_from[grid.star] = nil
    a_star.cost_so_far[grid.star] = 0
    a_star.frontier << grid.star

    # Until there are no more cells to explore from or the search has found the target
    until a_star.frontier.empty? or a_star.came_from.key?(grid.target)
      # Get the next cell to expand from
      current_frontier = a_star.frontier.shift

      # For each of that cells neighbors
      adjacent_neighbors(current_frontier).each do | neighbor |
        # That have not been visited and are not walls
        unless a_star.came_from.key?(neighbor) or grid.walls.key?(neighbor)
          # Add them to the frontier and mark them as visited
          a_star.frontier << neighbor
          a_star.came_from[neighbor] = current_frontier
          a_star.cost_so_far[neighbor] = a_star.cost_so_far[current_frontier] + 1
        end
      end

      # Sort the frontier so that cells that are in a zigzag pattern are prioritized over those in an line
      # Comment this line and let a path generate to see the difference
      a_star.frontier = a_star.frontier.sort_by {| cell | proximity_to_star(cell) }
      a_star.frontier = a_star.frontier.sort_by {| cell | a_star.cost_so_far[cell] + greedy_heuristic(cell) }
    end

    # If the search found the target
    if a_star.came_from.key?(grid.target)
      # Calculate the path between the target and star
      a_star_calc_path
    end
  end

  # Calculates the path between the target and star for the a_star search
  # Only called when the a_star search finds the target
  def a_star_calc_path
    # Start from the target
    endpoint = grid.target
    # And the cell it came from
    next_endpoint = a_star.came_from[endpoint]

    while endpoint && next_endpoint
      # Draw a path between these two cells and store it
      path = get_path_between(endpoint, next_endpoint)
      a_star.path << path
      # And get the next pair of cells
      endpoint = next_endpoint
      next_endpoint = a_star.came_from[endpoint]
      # Continue till there are no more cells
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
    neighbors << [cell.x    , cell.y + 1] unless cell.y == grid.height - 1
    neighbors << [cell.x + 1, cell.y    ] unless cell.x == grid.width - 1

    neighbors
  end

  # Finds the vertical and horizontal distance of a cell from the star
  # and returns the larger value
  # This method is used to have a zigzag pattern in the rendered path
  # A cell that is [5, 5] from the star,
  # is explored before over a cell that is [0, 7] away.
  # So, if possible, the search tries to go diagonal (zigzag) first
  def proximity_to_star(cell)
    distance_x = (grid.star.x - cell.x).abs
    distance_y = (grid.star.y - cell.y).abs

    if distance_x > distance_y
      return distance_x
    else
      return distance_y
    end
  end

  # Methods that allow code to be more concise. Subdivides args.state, which is where all variables are stored.
  def grid
    state.grid
  end

  def a_star
    state.a_star
  end
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
