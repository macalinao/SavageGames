package net.savagegames.savagegames

import org.bukkit.event.EventHandler
import org.bukkit.event.Listener

import org.bukkit.event.player.PlayerLoginEvent

##
# The general SavageGames listener.
#
class SGListener
  implements Listener

  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  $EventHandler
  def onPlayerLogin(event:PlayerLoginEvent)
    main.router.route event.getPlayer
  end
end
