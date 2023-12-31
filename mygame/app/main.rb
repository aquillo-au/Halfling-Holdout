require 'app/constants.rb'
require 'app/sprite_lookup.rb'
require 'app/legend.rb'
require 'app/baddies.rb'
require 'app/combat.rb'
require 'app/basic_path.rb'
require 'app/title.rb'
require 'app/game.rb'
require 'app/game_over.rb'
require 'app/village.rb'
require 'app/level.rb'
require 'app/players.rb'
require 'app/startup.rb'

def tick args
  # tick_game args 
  $sprite_tiles ||= SpriteGrid.new
  args.state.scene ||= "startup"
  case args.state.scene
  when"gameplay"
    $my_game ||= Game.new(args)
    $my_game.args = args
    $my_game.tick
  when "level"
    $level ||= Level.new(args)
    $level.args = args
    $level.tick
  when "title"
    $title ||= Title.new(args)
    $title.args = args
    $title.tick
  when "game_over"
    $game_over ||= GameOver.new(args)
    $game_over.args = args
    $game_over.tick
  else
    send("#{args.state.scene}_tick", args)
  end
   tick_legend args
end



$gtk.reset