package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Ranger class.
# Starts out with a bow and 10 arrows.
#
class Ranger < SClass
  def initialize
    super 'Ranger'
  end

  def bind(player:Player)
    items = ItemStack[2]
    items[0] = ItemStack.new(Material.BOW, 1)
    items[1] = ItemStack.new Material.ARROW, 10
    player.getInventory.addItem items
  end
end
