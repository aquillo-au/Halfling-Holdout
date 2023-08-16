def your_combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
   else
      attacker.hp -= defender.atk
   end
   "you swing at the #{defender.type} for #{attacker.atk} damage, leaving it with #{defender.hp} hps"
end

def your_arrow(defender)
   defender.hp -= $gtk.args.state.player.atk
   if defender.hp < 1
      defender.dead = true
   end
   "your arrow hit the #{defender.type} for #{$gtk.args.state.player.atk} damage"
end

def other_combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
   else
      attacker.hp -= defender.atk
      if attacker.hp < 1
         attacker.dead = true
      end
   end
   "#{attacker.type} swings at the #{defender.type} for #{attacker.atk} damage, leaving it with #{defender.hp} hps"
end