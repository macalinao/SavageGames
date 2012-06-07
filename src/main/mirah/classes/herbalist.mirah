package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

import org.bukkit.event.block.Action

import org.bukkit.event.player.PlayerInteractEvent

##
# The Herbalist class.
# Heals four hearts by right clicking a red or yellow flower
#
class Herbalist < SClass
  def self.i; @@i; end

  def initialize
    super 'Herbalist'
    @@i = self
  end

  def bind(player:Player)
  end

  ##
  # Handles the player interact of people that are Chefs.
  #
  def player_interact(event:PlayerInteractEvent):void
    unless event.getAction.equals(Action.RIGHT_CLICK_AIR) or event.getAction.equals(Action.RIGHT_CLICK_BLOCK)
      return
    end

    player = event.getPlayer
    item = player.getItemInHand
    type = item.getType

    unless type.equals(Material.RED_ROSE) or type.equals(Material.YELLOW_FLOWER)
      return
    end

    amt = item.getAmount
    if amt > 1
      item.setAmount(amt - 1)
    else
      player.setItemInHand ItemStack(nil)
    end

    player.updateInventory
    player.setHealth(player.getHealth + 8)
  end
end
