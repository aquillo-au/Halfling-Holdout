class Combat
   def your_combat(attacker, defender)
      damage = check_damage(defender, attack_roll(attacker))
      defender.hp -= damage
      if defender.hp < 1
         defender.dead = true
         "you swing at the #{defender.type} for #{damage} killing it"
      elsif damage > 0
         "you swing at the #{defender.type} for #{damage} leaving it with #{defender.hp}hps"
      else
         "you swing at the #{defender.type} damaging its armor"
      end
   end

   def your_arrow(defender, arrow)
      damage = attack_roll({atk: [1,6], no_crit: true })
      defender.hp -= damage
      if defender.hp < 1
         defender.dead = true
         ["an arrow hit the #{defender.type} for #{damage}", "killing it"]
         if arrow.player
            $gtk.args.state.score += defender.value
         end
      else
         ["an arrow hit the #{defender.type} for #{damage}", "leaving it with #{defender.hp}hps"]
      end
   end

   def bolt_hit(defender)
      damage = attack_roll({atk: [1,5], no_crit: true })
      defender.hp -= damage
      if defender.hp < 1
         defender.dead = true
         ["a bolt hit the #{defender.type} for #{damage}", "killing it"]
      else
         ["a bolt hit the #{defender.type} for #{damage}", "leaving it with #{defender.hp}hps"]
      end
   end

   def other_combat(attacker, defender)
      damage = check_damage(defender, attack_roll(attacker))
      defender.hp -= damage
      if defender.hp < 1
         defender.dead = true
         ["#{attacker.type} swings at the #{defender.type} for #{damage}", "killing it"]
      elsif damage > 0
         ["#{attacker.type} swings at the #{defender.type} for #{damage}", "leaving it with #{defender.hp}hps"] 
      else
         ["#{attacker.type} swings at the #{defender.type} damaging its armor"]
      end
   end

   def lightning_bolt(target)
      damage = check_damage(target, attack_roll({atk: [1,10]}))
      target.hp -= damage
      if target.hp < 1
         target.dead = true
         ["The lightning hits the #{target.type} for #{damage}", "killing it"]
         $gtk.args.state.score += target.value
      elsif damage > 0
         ["The lightning hits the #{target.type} for #{damage}", "leaving it with #{target.hp}hps"] 
      else
         ["The lightning hits the #{target.type} damaging its armor"]
      end
   end

   def fire_ball_attack(target)
      damage = check_damage(target, attack_roll({atk: [3,3]}))
      target.hp -= damage
      if target.hp < 1
         target.dead = true
         ["The Fireball hits the #{target.type} for #{damage}", "killing it"]
         $gtk.args.state.score += target.value
      elsif damage > 0
         ["The Fireball hits the #{target.type} for #{damage}", "leaving it with #{target.hp}hps"] 
      else
         ["The Fireball hits the #{target.type} damaging its armor"]
      end
   end

   def heal(healer, defender) 
      healing = heal_roll(healer)
      defender.hp += healing
      ["#{healer.type} heals the #{defender.type} for #{healing}"]
   end

   def attack_roll(attacker)
      damage = 0
      attacker.atk[0].times do 
         roll = rand(attacker.atk[1]) + 1
         damage += roll
         if can_crit?(attacker)
            until roll != attacker.atk[1]
               roll = rand(attacker.atk[1]) + 1
               damage += roll
            end
         end          
      end
      damage
   end

   def heal_roll(healer)
      healing = 0
      healer.atk[0].times do 
         roll = (rand(healer.atk[1])+ 1).to_i 
         healing += roll
      end
      healing
   end

   def can_crit?(attacker)
      attacker.atk[1] > 4 && !attacker.no_crit
   end

   def check_damage(defender, damage)
      if damage > defender.armor
         return damage - defender.armor
      elsif damage > 0
         defender.armor -= 1
         return 0
      else
         0
      end
   end
end