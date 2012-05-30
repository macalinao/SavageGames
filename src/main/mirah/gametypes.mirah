package net.savagerealms.savagegames

import java.io.File
import java.util.logging.Level

import org.bukkit.Bukkit
import org.bukkit.entity.Player
import org.bukkit.World
import org.bukkit.WorldType

##
# Represents a type of game characterized by a map and its behaviors.
#
class GameType
  ##
  # Sets up the GameType.
  def setup():void; end

  ##
  # Tears down the GameType.
  def tearDown():void; end
end

##
# Represents a GameType using a map generator.
# Utilizes the power of Multiverse.
#
class WorldGameType < GameType

  ##
  # Initializes the GameType.
  def initialize(main:SavageGames)
    @main = main
  end

  def setup()
    wm = @main.mv.getCore.getMVWorldManager

    @worldName = '_sgame'
    while Bukkit.getWorld(@worldName) != nil
      @worldName += '1'
    end

    @main.getLogger.log Level.INFO, "Generating new SavageGames world `#{@worldName}'..."
    added = wm.addWorld @worldName, World.Environment.NORMAL, \
      Long.toString(Double.doubleToRawLongBits Math.random()), WorldType.NORMAL, Boolean.TRUE, ''
    
    unless added
      @main.getLogger.log Level.SEVERE, "Unable to generate world for some odd reason!"
      return
    end

    @main.getLogger.log Level.INFO, 'World generated! Now the Savage Games can begin!'
  end

  def tearDown()
    world = Bukkit.getWorld @worldName
    if world == nil
      return
    end

    world.getPlayers.each do |p| # Should never happen
      Player(p).kickPlayer 'Please rejoin, why are you still here?'
    end

    Bukkit.getServer.unloadWorld @worldName, false
    folder = File.new Bukkit.getServer.getWorldContainer, @worldName
    FileUtils.delete folder

    @main.getLogger.log Level.INFO, 'World ' + @worldName + ' deleted!'
  end

  def delete(file:File)
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
