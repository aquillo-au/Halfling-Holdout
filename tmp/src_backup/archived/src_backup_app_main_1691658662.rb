require 'app/constants.rb'
require 'app/sprite_lookup.rb'
require 'app/legend.rb'
require 'app/baddies.rb'
require 'app/combat.rb'

def tick args
  tick_game args
  tick_legend args
end

def tick_game args
  # setup the grid
  args.state.grid.padding = 80
  args.state.grid.size = 600

  # set up your game
  # initialize the game/game defaults. ||= means that you only initialize it if
  # the value isn't alread initialized

  args.state.player ||= {
    y: 0,
    x: 0,
    hp: 20,
    atk: 2,
  }

  args.state.enemies ||= [
    { x: 10, y: 10, type: :goblin, tile_key: :B, hp: BADDIES[:goblin].hp},
    { x: 15, y: 20, type: :rat, tile_key: :R, hp: BADDIES[:rat].hp }
  ]


  args.state.info_message ||= "Yay a game"

  # handle keyboard input
  # keyboard input (arrow keys to move player)
  new_player_x = args.state.player.x
  new_player_y = args.state.player.y
  player_direction = ""
  player_moved = false
  if args.inputs.keyboard.key_down.up
    new_player_y += 1
    player_direction = "north"
    player_moved = true
  elsif args.inputs.keyboard.key_down.down
    new_player_y -= 1
    player_direction = "south"
    player_moved = true
  elsif args.inputs.keyboard.key_down.right
    new_player_x += 1
    player_direction = "east"
    player_moved = true
  elsif args.inputs.keyboard.key_down.left
    new_player_x -= 1
    player_direction = "west"
    player_moved = true
  end

  #handle game logic
  # determine if there is an enemy on that square,
  # if so, don't let the player move there
  if player_moved
    found_enemy = args.state.enemies.find do |e|
      e[:x] == new_player_x && e[:y] == new_player_y
    end

    if !found_enemys
      args.state.player.x = new_player_x
      args.state.player.y = new_player_y
      args.state.info_message = "You moved #{player_direction}."
    else
      args.state.info_message = combat(args.state.player, found_enemy)
    end
  end

  args.state.enemies.reject! { |e| e.dead }

  args.outputs.sprites << tile_in_game(args.state.player.x,
                                       args.state.player.y, '@')

  # render game
  # render enemies at locations
  args.outputs.sprites << args.state.enemies.map do |e|
    tile_in_game(e[:x], e[:y], e[:tile_key])
  end

  # render the border
  border_x = args.state.grid.padding - DESTINATION_TILE_SIZE
  border_y = args.state.grid.padding - DESTINATION_TILE_SIZE
  border_size = args.state.grid.size + DESTINATION_TILE_SIZE * 2

  args.outputs.borders << [border_x,
                           border_y,
                           border_size,
                           border_size]

  # render label stuff
  args.outputs.labels << [border_x, border_y - 10, "Current player location is: #{args.state.player.x}, #{args.state.player.y} you have #{args.state.player.hp} HP left"]
  args.outputs.labels << [border_x, border_y + 25 + border_size, args.state.info_message]
end

def tile_in_game x, y, tile_key
  tile($gtk.args.state.grid.padding + x * DESTINATION_TILE_SIZE,
       $gtk.args.state.grid.padding + y * DESTINATION_TILE_SIZE,
       tile_key)
end

$gtk.reset