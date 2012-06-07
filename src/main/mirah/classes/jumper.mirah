package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Jumper class.
# Starts out with 5 ender pearls.
#
class Jumper < SClass
  def initialize
    super 'Jumper'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.ENDER_PEARL, 5)
    player.getInventory.addItem items
  end
end
