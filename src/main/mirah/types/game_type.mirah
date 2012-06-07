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
  def min_players:int
    begin
      return Integer(settings.get 'min_players').intValue
    rescue Exception
      return 6
    end
  end

  ##
  # Gets the amount of players needed for feasts to start occuring.
  #
  def feast_players:int
    begin
      return Integer(settings.get 'feast_players').intValue
    rescue Exception
      return 6
    end
  end

  ##
  # Gets the X dimension.
  #
  def dimx:int
    begin
      return Integer(settings.get 'dimx').intValue
    rescue Exception
      return 512
    end
  end

  ##
  # Gets the Z dimension.
  #
  def dimz:int
    begin
      return Integer(settings.get 'dimz').intValue
    rescue Exception
      return 512
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
