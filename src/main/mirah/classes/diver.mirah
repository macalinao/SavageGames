package net.savagegames.savagegames

import org.bukkit.entity.Player

import org.bukkit.potion.PotionEffect
import org.bukkit.potion.PotionEffectType

##
# The Diver class.
#
class Diver < SClass
  def initialize
    super 'Diver'
  end

  def bind(player:Player)
    # Apply water breathing
    effect = PotionEffect.new PotionEffectType.WATER_BREATHING, 100000000, 1 # Basically forever
    player.addPotionEffect effect
  end
end
