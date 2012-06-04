package net.savagegames.savagegames

import org.bukkit.Bukkit
import org.bukkit.entity.Player
import org.bukkit.ChatColor

##
# Delays logouts.
#
class GameLogoutDelay < GameTask
  def player; @player; end

  def initialize(player:Player)
    @player = player
  end

  def run:void
    Bukkit.getPlayerExact player.getName

    game.broadcast ChatColor.BLUE.toString + "#{player.getName} has left the game!"
    game.remove_player player
    game.check_progression
  end
end
