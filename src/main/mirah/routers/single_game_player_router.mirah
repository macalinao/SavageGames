package net.savagegames.savagegames

import java.util.concurrent.ArrayBlockingQueue
import org.bukkit.entity.Player
import java.util.HashMap
import org.bukkit.ChatColor

import org.bukkit.potion.PotionEffect
import org.bukkit.potion.PotionEffectType

##
# Router for a single game server.
#
class SingleGamePlayerRouter < PlayerRouter

  def current_game; @current_game; end

  def initialize(main:SavageGames)
    super main

    @current_game = Game(nil)
    @queue = ArrayBlockingQueue.new 10
  end

  def setup
    ensure_game_exists
  end

  def route(player:Player)
    ensure_game_exists

    if current_game.phase.is_at_least GamePhases.Diaspora
      current_game.add_spectator player
    else
      route_to_lobby player
    end
  end

  def route_death(player:Player, game:Game)
    reset_player player
    game.add_spectator player
  end

  ##
  # Routes a player to the lobby.
  #
  def route_to_lobby(player:Player)
    player.sendMessage ChatColor.GREEN.toString + 'Welcome to the SavageGames!'
    player.sendMessage ChatColor.GREEN.toString + 'Please choose a class with the command /class <class name>'
    player.sendMessage ChatColor.YELLOW.toString + 'Available classes: ' + main.classes.list_classes_available(player)

    reset_player player

    # Add to the game
    current_game.add_participant player

    # NOTE: lobby should be spawn of the server
  end

  ##
  # Resets a player to normal state.
  #
  def reset_player(player:Player)
    # Remove all potion effects
    player.getActivePotionEffects.each do |e|
      effect = PotionEffect(e)
      begin
        player.removePotionEffect effect.getType
      rescue Exception
        # Slacka!
      end
    end

    # Remove main inv
    inv = player.getInventory.getContents
    inv.length.times {|i|
      inv[i] = null
    }
    player.getInventory.setContents inv

    # Remove armor inv
    ainv = player.getInventory.getArmorContents
    ainv.length.times {|i|
      ainv[i] = null
    }
    player.getInventory.setArmorContents ainv

    player.updateInventory

    # Heal
    player.setHealth 20
    player.setFoodLevel 20
  end

  ##
  # Ensures that a game exists.
  #
  def ensure_game_exists
    @current_game = main.games.get_any_game
    if @current_game == nil
      @current_game = main.games.create_game next_game_type
      @current_game.start
    end
  end

  ##
  # Hack for populating the 'random' queue.
  # Let's hope nobody finds out what map is going
  # to be next via the source code that's on Github.
  #
  def populate_queue()
    settings = HashMap.new
    settings.put 'capacity', Integer.valueOf(24)
    settings.put 'min_players', Integer.valueOf(2)

    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
    @queue.add WorldGameType.new settings
  end

  ##
  # Gets the next game type.
  #
  def next_game_type():GameType
    if @queue.size <= 0
      populate_queue
    end

    return GameType(@queue.poll)
  end
end
