package net.savagegames.savagegames

import org.bukkit.command.CommandSender
import org.bukkit.command.Command

import org.bukkit.entity.Player

##
# A command for players.
#
class SGPlayerCommand < SGCommand
  def run(sender:CommandSender, cmd:Command, label:String, args:String[]):void
    unless sender.kind_of? Player
      sender.sendMessage 'You must be a player to use this command.'
      return
    end

    player = Player(sender)

    run_player player, cmd, label, args
  end

  ##
  # Runs the command.
  #
  def run_player(player:Player, cmd:Command, label:String, args:String[]):void
  end

end
