def combat(player, baddie)
   baddie.hp -= player.atk
   player.hp -= baddie.atk
   "you swing at the #{baddie.type} for #{player.atk} damage, leaving it with #{baddie.hp} hps"
end