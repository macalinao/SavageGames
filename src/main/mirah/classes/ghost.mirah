package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The Ghost class.
#
class Ghost < SClass
  def initialize
    super 'Warrior'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.GHAST_TEAR, 1)
    player.getInventory.addItem items
  end

  def player_interact(event:PlayerInteractEvent):void
  end
end
