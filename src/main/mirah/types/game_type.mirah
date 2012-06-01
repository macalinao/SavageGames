package net.savagegames.savagegames

import java.io.File
import java.util.logging.Level
import java.util.HashMap

import org.bukkit.Bukkit
import org.bukkit.entity.Player
import org.bukkit.World
import org.bukkit.WorldType
import org.bukkit.Location
import org.bukkit.Material

##
# Represents a type of game characterized by a map and its behaviors.
#
class GameType
  def settings:HashMap; @settings; end
  def main:SavageGames; SavageGames.i; end

  ##
  # Gets the capacity of the GameType.
  #
  def capacity:int
    begin
      return Integer(settings.get 'capacity').intValue
    rescue Exception
      return 24
    end
  end

  ##
  # Gets the minimum players the game can have.
  #
  def minPlayers():int
    begin
      return Integer(settings.get 'minPlayers').intValue
    rescue Exception
      return 6
    end
  end

  ##
  # Creates a new GameType with the given settings.
  #
  def initialize(settings:HashMap)
    @settings = settings
  end

  ##
  # Gets the spawn point of the GameType. Tributes will spawn
  # within 50 blocks of this point.
  #
  def spawn:Location; end

  ##
  # Sets up the GameType.
  def setup; false; end

  ##
  # Tears down the GameType.
  def tearDown:void; end
end
