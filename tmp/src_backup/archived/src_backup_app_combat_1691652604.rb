def combat(player, baddie)
   baddie.hp -= player.atk
   player.hp -= BADDIES[baddie.type].atk
   if baddie.hp < 1
    baddie.dead = true
   end
   "you swing at the #{baddie.type} for #{player.atk} damage, leaving it with #{baddie.hp} hps"
end