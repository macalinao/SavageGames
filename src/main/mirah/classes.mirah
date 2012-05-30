package net.savagerealms.savagegames

import org.bukkit.entity.Player
import org.bukkit.inventory.ItemStack
import org.bukkit.Material

class SClass
  def name():String; @name; end

  def initialize(name:String)
    @name = name
  end

  ##
  # Called when the game starts.
  #
  def bind(player:Player):void; end
end

##
# The Warrior class.
# Starts out with a stone sword.
#
class Warrior < SClass
  def initialize(name:String)
    super 'Warrior'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.STONE_SWORD, 1)
    player.getInventory.addItem items
  end
end
