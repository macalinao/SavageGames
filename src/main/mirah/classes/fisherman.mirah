package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Fisherman class.
# Starts out with a fishing rod.
#
class Fisherman < SClass
  def initialize
    super 'Fisherman'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.FISHING_ROD, 1)
    player.getInventory.addItem items
  end
end
