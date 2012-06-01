package net.savagegames.savagegames

import org.bukkit.entity.Player

import org.bukkit.event.EventHandler
import org.bukkit.event.Listener

import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent
import org.bukkit.event.entity.EntityDeathEvent

import org.bukkit.event.player.PlayerDeathEvent
import org.bukkit.event.player.PlayerJoinEvent
import org.bukkit.event.player.PlayerMoveEvent

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

  $EventHandler
  def onPlayerMove(event:PlayerMoveEvent):void
    player = event.getPlayer
    game = main.games.get_game_of_player player

    if game == nil
      return
    end

    spawn = game.type.spawn

    minx = spawn.getBlockX - 256
    maxx = spawn.getBlockX + 256

    minz = spawn.getBlockZ - 256
    maxz = spawn.getBlockZ + 256

    px = player.getLocation.getBlockX
    pz = player.getLocation.getBlockZ

    unless px > minx and px < maxx and pz > minz and pz < maxz
      player.sendMessage 'You have crossed the border. NOT.'
      event.setCancelled true
    end
  end
end
