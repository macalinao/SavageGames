package net.savagegames.savagegames

import org.bukkit.entity.Player

import org.bukkit.event.EventHandler
import org.bukkit.event.Listener

import org.bukkit.event.player.PlayerJoinEvent
import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent
import org.bukkit.event.entity.EntityDeathEvent
import org.bukkit.event.player.PlayerDeathEvent

##
# The general SavageGames listener.
#
# This is for listening to stuff happening in games. Not to players.
#
class SGListener
  implements Listener

  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  $EventHandler
  def onPlayerJoin(event:PlayerJoinEvent):void
    main.router.route event.getPlayer
  end

  $EventHandler
  def onEntityDamage(event:EntityDamageEvent):void
    unless event.kind_of? EntityDamageByEntityEvent
      return
    end
    ede = EntityDamageByEntityEvent(event)

    if ede.getEntity.kind_of?(Player) and ede.getDamager.kind_of?(Player)

      # Check if in game
      game = main.games.get_game ede.getEntity.getLocation.getWorld
      if game == nil
        return
      end

      unless game.phase.is_at_least GamePhases.Main
        ede.setCancelled true
      end
      #

    end
  end

  $EventHandler
  def onEntityDeath(event:EntityDeathEvent):void
    unless event.kind_of? PlayerDeathEvent
      return
    end

    player = PlayerDeathEvent(event).getEntity
    cause = player.getLastDamageCause

    # TODO messages

    player.getLocation.getWorld.strikeLightningEffect player.getLocation
  end
end
