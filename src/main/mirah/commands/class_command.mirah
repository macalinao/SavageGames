package net.savagegames.savagegames

import org.bukkit.command.CommandSender
import org.bukkit.command.Command

import org.bukkit.ChatColor
import org.bukkit.entity.Player

##
# Command to allow you to choose a class.
#
class ClassCommand < BasePlayerCommand
  def run_player(player:Player, cmd:Command, label:String, args:String[]):void
    game = SavageGames.i.games.get_game_of_player player
    if game == nil
      player.sendMessage ChatColor.RED.toString + 'You are not in a game.'
      return
    end

    if game.phase.is_at_least GamePhases.Diaspora()
      player.sendMessage ChatColor.RED.toString + "You can't use this command ingame."
      return
    end

    if args.length < 1
      player.sendMessage ChatColor.RED.toString + "You didn't specify a class! The command is: " + ChatColor.YELLOW.toString + "/class <classname>"
      return
    end

    class_name = args[0]
    clazz = SavageGames.i.classes.get_class class_name
    if clazz == nil
      player.sendMessage ChatColor.RED.toString + "Invalid class."
      return
    end

    SavageGames.i.classes.set_class_of_player player, clazz
    player.sendMessage ChatColor.GREEN.toString + "Your class has been set to '" + clazz.name + "'."
  end
end
