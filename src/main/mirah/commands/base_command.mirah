package net.savagegames.savagegames

import org.bukkit.command.CommandSender
import org.bukkit.command.Command
import org.bukkit.command.CommandExecutor

class BaseCommand
  implements CommandExecutor

  def onCommand(sender:CommandSender, cmd:Command, label:String, args:String[]):boolean
    run sender, cmd, label, args
    return true
  end

  ##
  # Runs the command.
  #
  def run(sender:CommandSender, cmd:Command, label:String, args:String[]):void
  end

end
