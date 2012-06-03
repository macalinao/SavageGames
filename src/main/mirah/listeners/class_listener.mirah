package net.savagegames.savagegames

import org.bukkit.event.Listener
import org.bukkit.event.EventHandler

import org.bukkit.event.player.PlayerInteractEvent

##
# Listens to class-related events.
#
class ClassListener
  implements Listener
  
  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  $EventHandler
  def onPlayerInteract(event:PlayerInteractEvent)
    player = event.getPlayer
    clazz = main.classes.get_class_of_player player

    if clazz.is 'chef'
      Chef.player_interact event
    end
  end
end
