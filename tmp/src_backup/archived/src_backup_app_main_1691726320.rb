require 'app/constants.rb'
require 'app/sprite_lookup.rb'
require 'app/legend.rb'
require 'app/baddies.rb'
require 'app/combat.rb'
require 'app/pathfinding.rb'
require 'app/title.rb'
require 'app/game.rb'

def tick args
  # tick_game args
  if args.state.tick_count == 1
    
  end 

  args.state.scene ||= "title"

  send("#{args.state.scene}_tick", args)
#  tick_legend args
end



$gtk.reset