package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Warrior class.
# Starts out with a stone sword.
#
class Warrior < SClass
  def initialize
    super 'Warrior'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.STONE_SWORD, 1)
    player.getInventory.addItem items
  end
end
