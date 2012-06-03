package net.savagegames.savagegames

import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

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
    # It's all about the events!
  end

  ##
  # Handles the player interact of people that are Chefs.
  #
  def self.player_interact(event:PlayerInteractEvent)
    unless event.getAction.equals Action.RIGHT_CLICK_AIR
      return
    end

    player = event.getPlayer
    item = player.getItemInHand
    type = item.getType
    mat = nil

    if type.equals Material.RAW_BEEF
      mat = Material.COOKED_BEEF
    elsif type.equals Material.RAW_CHICKEN
      mat = Material.COOKED_CHICKEN
    elsif type.equals Material.RAW_FISH
      mat = Material.COOKED_FISH
    elsif type.equals Material.PORK
      mat = Material.GRILLED_PORK
    end

    if mat != nil
      item.setType mat
      player.setItemInHand item
    end

    player.sendMessage ChatColor.GREEN.toString + 'Order up!'
end
