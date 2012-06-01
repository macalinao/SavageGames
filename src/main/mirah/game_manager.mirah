package net.savagegames.savagegames

import java.io.File
import java.io.IOException
import java.util.HashMap
import java.util.logging.Level

import org.bukkit.Bukkit
import org.bukkit.configuration.file.YamlConfiguration
import org.bukkit.World
import org.bukkit.entity.Player

##
# Manages Games.
#
class GameManager
  def games; @games; end

  ##
  # Initializes a new GameManager.
  #
  def initialize(main:SavageGames)
    @main = main
    @games = HashMap.new
  end

  ##
  # Gets any game. (In reality it's the first found, but whatever)
  #
  def get_any_game:Game
    game_array = games.values.toArray
    unless game_array.length > 0
      return nil
    end
    return Game(game_array[0])
  end

  ##
  # Gets the game corresponding with the given world.
  #
  def get_game(world:World):Game
    g = games.get world
    return nil if g == nil
    return Game(g)
  end

  ##
  # Creates a new game with the given GameType.
  #
  def create_game(type:GameType):Game
    game = Game.new type
    games.put type.spawnPoint.getWorld, game
    return game
  end

  ##
  # Gets the game that the given player is in.
  #
  def get_game_of_player(player:Player):Game
    return get_game player.getLocation.getWorld
  end
end
