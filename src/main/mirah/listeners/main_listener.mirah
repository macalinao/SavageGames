package net.savagegames.savagegames

import java.util.ArrayList

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

      unless game.phase.is_at_least GamePhases.Main
        event.setCancelled true
      end
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

    ranking = Ranking.new
    ranking.time = int(System.currentTimeMillis - game.report.date) / 1000
    ranking.player = player.getName

    clazz = main.classes.get_class_of_player player
    if clazz != nil
      ranking.clazz = clazz.name
    else
      ranking.clazz = 'None'
    end

    killsObj = main.sessions.get_session_of_player(player).get 'kills'
    unless killsObj == nil
      ranking.kills = ArrayList(killsObj)
    else
      ranking.kills = ArrayList.new
    end

    killer = player.getKiller
    unless killer == nil
      killerKillsObj = main.sessions.get_session_of_player(killer).get 'kills'
      if killerKillsObj == nil
        killerKillsObj = Object(ArrayList.new)
        main.sessions.get_session_of_player(killer).set 'kills', killerKillsObj
      end
      killerKills = ArrayList(killerKillsObj)
      killerKills.add player.getName
    end

    game.remove_player player.getName
    main.compasses.remove_target_of player
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

    hdimx = game.type.dimx / 2
    hdimz = game.type.dimz / 2

    minx = spawn.getBlockX - hdimx
    maxx = spawn.getBlockX + hdimx

    minz = spawn.getBlockZ - hdimz
    maxz = spawn.getBlockZ + hdimz

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
      loc = pl.getLocation

      unless loc.getWorld.equals player.getLocation.getWorld
        i += 1
        next
      end

      dist = loc.distanceSquared player.getLocation
      if dist < shortest and not pl.equals(player)
        shortest = int(dist)
        shortestp = pl
      end
      i += 1
    end

    unless shortestp != nil
      return
    end

    main.compasses.set_target player, shortestp
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
  def onPlayerQuit(event:PlayerQuitEvent):void
    player = event.getPlayer
    game = main.games.get_game_of_player player
    unless game == nil
      game.handle_leave player.getName
    end
  end

  $EventHandler
  def onPlayerKick(event:PlayerKickEvent):void
    player = event.getPlayer
    game = main.games.get_game_of_player player
    unless game == nil
      game.remove_player player
    end
  end
end
