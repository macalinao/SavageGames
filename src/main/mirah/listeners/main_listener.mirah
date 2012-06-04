package net.savagegames.savagegames

import org.bukkit.ChatColor
import org.bukkit.Material
import org.bukkit.Location
import org.bukkit.event.block.Action

import org.bukkit.entity.Player

import org.bukkit.event.EventHandler
import org.bukkit.event.Listener

import org.bukkit.event.block.BlockBreakEvent
import org.bukkit.event.block.BlockPlaceEvent

import org.bukkit.event.entity.EntityDamageEvent
import org.bukkit.event.entity.EntityDamageByEntityEvent
import org.bukkit.event.entity.EntityDeathEvent

import org.bukkit.event.player.PlayerChatEvent
import org.bukkit.event.player.PlayerInteractEvent
import org.bukkit.event.player.PlayerJoinEvent
import org.bukkit.event.player.PlayerKickEvent
import org.bukkit.event.player.PlayerLoginEvent
import org.bukkit.event.player.PlayerMoveEvent
import org.bukkit.event.player.PlayerQuitEvent

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
  def onBlockBreak(event:BlockBreakEvent):void
    game = main.games.get_game_of_player event.getPlayer
    if game == nil or not game.phase.is_at_least(GamePhases.Diaspora)
      event.getPlayer.sendMessage ChatColor.RED.toString + "Sorry, you can't build here."
      event.setCancelled true
    end
  end

  $EventHandler
  def onBlockPlace(event:BlockPlaceEvent):void
    game = main.games.get_game_of_player event.getPlayer
    if game == nil or not game.phase.is_at_least(GamePhases.Diaspora)
      event.getPlayer.sendMessage ChatColor.RED.toString + "Sorry, you can't build here."
      event.setCancelled true
    end
  end

  $EventHandler
  def onPlayerLogin(event:PlayerLoginEvent):void
    main.router.handle_login event
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
        event.setCancelled true
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

    game.remove_player player
    main.router.route_death player, game

    game.check_progression
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

    unless game.phase.is_at_least GamePhases.Diaspora
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
        player.getLocation.getWorld.strikeLightningEffect player.getLocation
        player.damage 1
        player.sendMessage ChatColor.RED.toString + 'YOU ARE BEING KILLED BY THE FORCE FIELD!'
      else
        player.sendMessage ChatColor.RED.toString + '[WARNING] You have crossed the forcefield! You will be killed if you keep going!'
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

    players = main.getServer.getOnlinePlayers
    amt = players.length
    i = 0
    while i < amt
      pl = Player(players[i])
      dist = pl.getLocation.distanceSquared player.getLocation
      if dist < shortest and not pl.equals(player)
        shortest = int(dist)
        shortestp = pl
      end
      i += 1
    end

    unless shortestp != nil
      return
    end

    player.setCompassTarget shortestp.getLocation
    player.sendMessage 'Your compass is now pointing to ' + shortestp.getName + '.'
  end

  $EventHandler
  def onPlayerChat(event:PlayerChatEvent):void
    player = event.getPlayer
    game = main.games.get_game_of_player player
    if game == nil
      # This shouldn't ever happen, but just in case...
      return
    end

    # We'll handle the chat our own way.
    event.setCancelled true

    clazz = main.classes.get_class_of_player player
    if clazz == nil
      classes = main.classes.list_classes_available player
      player.sendMessage ChatColor.RED.toString + "You aren't allowed to chat until you've chosen a class!"
      player.sendMessage ChatColor.YELLOW.toString + "Available classes: #{classes}"
      return
    end

    name = player.getName
    message = event.getMessage

    # TODO handle donators
    # TODO split chat of players and spectators
    game.broadcast_to_players "<#{name}> #{message}"
  end

  $EventHandler
  def onPlayerKick(event:PlayerKickEvent):void
    handle_leave event.getPlayer
  end

  $EventHandler
  def onPlayerQuit(event:PlayerQuitEvent):void
    handle_leave event.getPlayer
  end

  ##
  # Handles the leaving of a player.
  #
  def handle_leave(player:Player):void
    game = main.games.get_game_of_player player
    unless game == nil
      game.handle_leave player
    end
  end
end
