package net.savagerealms.savagegames

import org.bukkit.entity.Player
import org.bukkit.inventory.ItemStack
import org.bukkit.Material

class SClass
  def name():String; @name; end

  def initialize(name:String)
    @name = name
  end

  def bind(player:Player):void
    """Called when the game starts."""
  end
end

class Warrior < SClass
  """
  The Warrior class.
  Starts out with a stone sword.
  """
  def initialize(name:String)
    super 'Warrior'
  end

  def bind(player:Player)
    items = ItemStack[1]
    items[0] = ItemStack.new(Material.STONE_SWORD, 1)
    player.getInventory.addItem items
  end
end
