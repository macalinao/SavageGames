package net.savagegames.savagegames

import java.util.concurrent.ArrayBlockingQueue
import java.util.HashMap

import org.bukkit.entity.Player

##
# Routes players who join to the correct lobby.
#
class PlayerRouter
  def main; @main; end

  def initialize(main:SavageGames)
    @main = main
  end

  ##
  # Sets up the router.
  #
  def setup:void; end

  ##
  # Routes the player to where they should be.
  #
  # This is for login or after a game ends.
  #
  def route(player:Player):void; end

  ##
  # Routes a player after they die in a game.
  #
  def route_death(player:Player, game:Game):void; end
end

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
    game.add_spectator player
  end

  def route_to_lobby(player:Player)
    # TODO
  end

  ##
  # Ensures that a game exists.
  #
  def ensure_game_exists
    @current_game = main.games.get_any_game
    if @current_game == nil
      @current_game = main.games.create_game next_game_type
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
    settings.put 'minPlayers', Integer.valueOf(1)

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
