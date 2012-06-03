package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Miner class.
# Starts out with a gold pickaxe.
#
class Miner < SClass
  def initialize
    super 'Miner'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.GOLD_PICKAXE, 1)
    player.getInventory.addItem items
  end
end
