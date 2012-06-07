package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

import org.bukkit.potion.PotionEffect
import org.bukkit.potion.PotionEffectType

##
# The Rabbit class.
#
class Rabbit < SClass
  def initialize
    super 'Rabbit'
  end

  def bind(player:Player)
    effect = PotionEffect.new PotionEffectType.JUMP, 100000000, 1 # Basically forever
    player.addPotionEffect effect
  end
end
