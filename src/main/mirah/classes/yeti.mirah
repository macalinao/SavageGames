package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Yeti class.
# Starts out with 10 snowballs and a wooden shovel.
#
class Yeti < SClass
  def initialize
    super 'Yeti'
  end

  def bind(player:Player)
    items = ItemStack[2]
    items[0] = ItemStack.new(Material.WOOD_SPADE, 1)
    items[1] = ItemStack.new Material.SNOW_BALL, 10
    player.getInventory.addItem items
  end
end
