def your_combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
      ["you swing at the #{defender.type} for #{attacker.atk} damage", "killing it"]
   else
      ["you swing at the #{defender.type} for #{attacker.atk} damage", "leaving it with #{defender.hp} hps"]
   end
end

def your_arrow(defender)
   defender.hp -= $gtk.args.state.player.atk
   if defender.hp < 1
      defender.dead = true
      ["your arrow hit the #{defender.type} for #{attacker.atk} damage", "killing it"]
   else
      ["your arrow hit the #{defender.type} for #{attacker.atk} damage", "leaving it with #{defender.hp} hps"]
   end
end

def other_combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
      ["#{attacker.type} swings at the #{defender.type} for #{attacker.atk} damage", "killing it"]
   else
      ["#{attacker.type} swings at the #{defender.type} for #{attacker.atk} damage", "leaving it with #{defender.hp} hps"] 
   end
end