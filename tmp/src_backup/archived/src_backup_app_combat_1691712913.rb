def combat(attacker, defender)
   defender.hp -= attacker.atk
   if defender.hp < 1
      defender.dead = true
   else
      attacker.hp -= defender.atk
   end

   "you swing at the #{defender.type} for #{attacker.atk} damage, leaving it with #{defender.hp} hps"
end