package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Pyro class.
# Starts out with a flint and steel.
#
class Pyro < SClass
  def initialize
    super 'Pyro'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.FLINT_AND_STEEL, 1)
    player.getInventory.addItem items
  end
end
