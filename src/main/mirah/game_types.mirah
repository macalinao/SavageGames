package net.savagerealms.savagegames

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
  def settings():HashMap; @settings; end
  def main():SavageGames; @main; end

  ##
  # Gets the capacity of the GameType.
  #
  def capacity():int
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
  def initialize(settings:HashMap, main:SavageGames)
    @settings = settings
    @main = main
  end

  ##
  # Gets the spawn point of the GameType. Tributes will spawn
  # within 50 blocks of this point.
  #
  def spawnPoint():Location; end

  ##
  # Sets up the GameType.
  def setup(); false; end

  ##
  # Tears down the GameType.
  def tearDown():void; end
end

##
# Represents a GameType using a map generator.
# Utilizes the power of Multiverse.
#
class WorldGameType < GameType
  def spawnPoint():Location; @spawnPoint; end

  ##
  # Initializes the GameType.
  def initialize(settings:HashMap, main:SavageGames)
    super settings, main

    @spawnPoint = Location(nil)
  end


  def setup()
    wm = main.mv.getCore.getMVWorldManager

    # Generate a name
    worldName = String(nil)
    worldName = '_sgame'
    while Bukkit.getWorld(worldName) != nil
      worldName += '1'
    end

    main.getLogger.log Level.INFO, "Generating new SavageGames world `#{worldName}'..."
    added = wm.addWorld worldName, World.Environment.NORMAL, \
      Long.toString(Double.doubleToRawLongBits Math.random()), WorldType.NORMAL, Boolean.TRUE, ''
    
    unless added
      main.getLogger.log Level.SEVERE, "Unable to generate world for some odd reason!"
      return false
    end

    main.getLogger.log Level.INFO, 'World generated! Determining spawn...'

    @world = main.getServer.getWorld worldName
    if @world == nil
      main.getLogger.log Level.SEVERE, 'World did not get generated safely!'
      return false
    end

    # Usability check

    bx = 0
    bz = 0
    block = @world.getHighestBlockAt bx, bz
    while block.getType.equals(Material.WATER) or \
      block.getType.equals(Material.LAVA)

      bx += 1
      bz += 1
      block = @world.getHighestBlockAt bx, bz
    end

    @spawnPoint = block.getLocation.add 0, 1, 0

    main.getLogger.log Level.INFO, 'Spawn determined!'

    return true
  end

  def tearDown()
    @world.getPlayers.each do |p| # Should never happen
      Player(p).kickPlayer 'Please rejoin, why are you still here?'
    end

    worldName = @world.getName

    Bukkit.getServer.unloadWorld worldName, false
    folder = File.new Bukkit.getServer.getWorldContainer, worldName
    FileUtils.delete folder

    main.getLogger.log Level.INFO, 'World ' + worldName + ' deleted!'
  end
end

"""
class TCGameType < GameType
  def initialize(config:WorldConfig)
    
  end

  def setup()

  end
end
"""
