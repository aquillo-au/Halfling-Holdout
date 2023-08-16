def your_combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
      "you swing at the #{defender.type} for #{attacker.atk} killing it"
   else
      "you swing at the #{defender.type} for #{attacker.atk} leaving it with #{defender.hp}hps"
   end
end

def your_arrow(defender)
   defender.hp -= $gtk.args.state.player.atk
   if defender.hp < 1
      defender.dead = true
      ["your arrow hit the #{defender.type} for #{$gtk.args.state.player.atk}", "killing it"]
   else
      ["your arrow hit the #{defender.type} for #{$gtk.args.state.player.atk}", "leaving it with #{defender.hp}hps"]
   end
end

def other_combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
      ["#{attacker.type} swings at the #{defender.type} for #{attacker.atk}", "killing it"]
   else
      ["#{attacker.type} swings at the #{defender.type} for #{attacker.atk}", "leaving it with #{defender.hp}hps"] 
   end
end

def heal(healer, defender) 
   defender.hp += healer.atk
   defender.hp.clamp( 1, defender.maxhp) if defender.maxhp
   ["#{healer.type} heals the #{defender.type} for #{healer.atk}"]
end