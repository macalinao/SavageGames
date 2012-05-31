package net.savagegames.savagegames

import org.bukkit.event.EventHandler
import org.bukkit.event.Listener

import org.bukkit.event.player.PlayerMoveEvent

class SGListener
  implements Listener

  def initialize(main:SavageGames)
    @main = main
  end

  $EventHandler
  def onPlayerMove(event:PlayerMoveEvent)
    return
  end

end
