package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

import org.bukkit.potion.PotionEffect
import org.bukkit.potion.PotionEffectType

##
# The Firefighter class.
#
class Firefighter < SClass
  def initialize
    super 'Firefighter'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.WATER_BUCKET, 1)
    player.getInventory.addItem items

    # Apply fire resistance
    effect = PotionEffect.new PotionEffectType.FIRE_RESISTANCE, 1000000, 1 # Basically forever
    player.addPotionEffect effect
  end
end
