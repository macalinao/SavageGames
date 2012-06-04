package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

import org.bukkit.event.block.Action

import org.bukkit.event.player.PlayerInteractEvent

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

  def self.player_interact(event:PlayerInteractEvent):void
    action = event.getAction
    unless event.getAction.equals(Action.RIGHT_CLICK_AIR) or event.getAction.equals(Action.RIGHT_CLICK_BLOCK)
      return
    end

    player = event.getPlayer

  end
end
