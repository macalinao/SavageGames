package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Excavator class.
# Starts out with a gold shovel.
#
class Excavator < SClass
  def initialize
    super 'Excavator'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.GOLD_SPADE, 1)
    player.getInventory.addItem items
  end
end
