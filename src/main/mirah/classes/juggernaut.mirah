package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Juggernaut class.
# Starts out with a gold pickaxe.
#
class Juggernaut < SClass
  def initialize
    super 'Miner'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.GOLD_PICKAXE, 1)
    player.getInventory.addItem items
  end
end
