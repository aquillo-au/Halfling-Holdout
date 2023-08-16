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

def tick args
  # tick_game args 
  args.state.scene ||= "title"
  send("#{args.state.scene}_tick", args)
  # tick_legend args
end



$gtk.reset