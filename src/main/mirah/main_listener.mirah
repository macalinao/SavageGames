package net.savagegames.savagegames

import org.bukkit.ChatColor
import org.bukkit.Material
import org.bukkit.Location
import org.bukkit.event.block.Action

import org.bukkit.entity.Player

import org.bukkit.event.EventHandler
import org.bukkit.event.Listener

import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent
import org.bukkit.event.entity.EntityDeathEvent

import org.bukkit.event.player.PlayerInteractEvent
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
    player = Player(nil)

    if event.getEntity.kind_of? Player
      player = Player(event.getEntity)

      game = main.games.get_game_of_player player
      if game == nil
        return
      end

      unless game.phase.is_at_least GamePhases.Diaspora
        event.setCancelled true
      end
    end

    unless event.kind_of? EntityDamageByEntityEvent
      return
    end

    ede = EntityDamageByEntityEvent(event)

    if ede.getEntity.kind_of?(Player) or ede.getDamager.kind_of?(Player)
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
    unless event.getEntity.kind_of? Player
      return
    end

    player = Player(event.getEntity)

    world = player.getLocation.getWorld
    world.strikeLightningEffect player.getLocation

    game = main.games.get_game_of_player player
    if game == nil
      return
    end

    main.router.route_death player, game
  end

  $EventHandler
  def onPlayerMove(event:PlayerMoveEvent):void
    player = event.getPlayer
    game = main.games.get_game_of_player player

    if game == nil
      return
    end

    unless game.type.spawn.getWorld.equals player.getLocation.getWorld
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
      rminx = minx - 16
      rmaxx = maxx + 16

      rminz = minz - 16
      rmaxz = maxz + 16

      unless px > rminx and px < rmaxx and pz > rminz and pz < rmaxz
        player.getLocation.getWorld.strikeLightning player.getLocation
        player.sendMessage ChatColor.RED.toString + 'YOU ARE BEING KILLED BY THE FORCE FIELD!'
      else
        player.sendMessage ChatColor.RED.toString + '[WARNING] YOU HAVE CROSSED THE FORCEFIELD! IF YOU WANDER ANY FURTHER, YOU WILL BE KILLED!'
      end
    end
  end

  $EventHandler
  def onPlayerInteract(event:PlayerInteractEvent):void
    item = event.getItem

    if item == nil
      return
    end

    unless item.getType.equals Material.COMPASS
      return
    end

    unless event.getAction.equals Action.RIGHT_CLICK_AIR or event.getAction.equals Action.RIGHT_CLICK_BLOCK
      return
    end

    # Get the closest player
    player = event.getPlayer
    shortest = 1000000
    shortestp = Player(nil)
    """
    main.getServer.getOnlinePlayers.each do |p|
      pl = Player(p)
      dist = pl.getLocation.distanceSquared player.getLocation
      if dist < shortest
        shortest = dist
        shortestp = pl
      end
    end
    """
    unless shortestp != nil
      return
    end

    player.setCompassTarget shortestp.getLocation
    player.sendMessage 'Your compass is now pointing to ' + shortestp.getName + '.'
  end
end
