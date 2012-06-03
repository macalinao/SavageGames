package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack
import org.bukkit.ChatColor

import org.bukkit.event.block.Action

import org.bukkit.event.player.PlayerInteractEvent

##
# The Chef class.
# Order up!
#
class Chef < SClass
  def initialize
    super 'Chef'
  end

  def bind(player:Player)
    player.sendMessage ChatColor.GOLD.toString + 'Cook by right-clicking with raw food in your hand.'
  end

  ##
  # Handles the player interact of people that are Chefs.
  #
  def self.player_interact(event:PlayerInteractEvent):void
    unless event.getAction.equals(Action.RIGHT_CLICK_AIR) or event.getAction.equals(Action.RIGHT_CLICK_BLOCK)
      return
    end

    player = event.getPlayer
    item = player.getItemInHand
    type = item.getType
    mat = Material(nil)

    if type.equals Material.RAW_BEEF
      mat = Material.COOKED_BEEF
    elsif type.equals Material.RAW_CHICKEN
      mat = Material.COOKED_CHICKEN
    elsif type.equals Material.RAW_FISH
      mat = Material.COOKED_FISH
    elsif type.equals Material.PORK
      mat = Material.GRILLED_PORK
    end

    unless mat == nil
      item.setType mat
      player.setItemInHand item
    end

    player.sendMessage ChatColor.GOLD.toString + 'Bon appetite!'
  end
end
