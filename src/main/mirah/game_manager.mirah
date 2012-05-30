package net.savagerealms.savagegames

import java.io.File
import java.io.IOException
import java.util.HashMap
import java.util.logging.Level

import org.bukkit.Bukkit
import org.bukkit.configuration.file.YamlConfiguration
import org.bukkit.World

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
  # Gets the game corresponding with the given world.
  #
  def getGame(world:World)
    games.get world
  end

  ##
  # Creates a new game with the given GameType.
  #
  def createGame(type:GameType)
    Game.new
  end
end
