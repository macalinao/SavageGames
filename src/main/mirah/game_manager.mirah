package net.savagerealms.savagegames

import java.io.File
import java.io.IOException
import java.util.HashMap
import java.util.logging.Level

import org.bukkit.Bukkit
import org.bukkit.configuration.file.YamlConfiguration
import org.bukkit.World

class GameManager
  """
  Manages Games.
  """
  def games; @games; end

  def initialize(main:SavageGames)
    @main = main
    @games = HashMap.new
  end

  def getGame(world:World)
    """Gets the game corresponding with the given world."""
    games.get world
  end

  def createGame(type:GameType)
    """Creates a new game with the given GameType."""
    return
  end
end
