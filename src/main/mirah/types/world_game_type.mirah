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
# Represents a GameType using a map generator.
# Utilizes the power of Multiverse.
#
class WorldGameType < GameType
  ##
  # Initializes the GameType.
  def initialize(settings:HashMap)
    super settings

    @spawn = Location(nil)
  end

  def spawn:Location; @spawn; end

  def setup
    wm = main.mv.getCore.getMVWorldManager

    # Generate a name
    worldName = String(nil)
    worldName = '__sgame__'
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

    @spawn = @world.getSpawnLocation
    main.getLogger.log Level.INFO, 'Spawn determined!'

    return true
  end

  def tearDown()
    @world.getPlayers.each do |p| # Should never happen
      Player(p).kickPlayer 'Please rejoin, why are you still here?'
    end

    worldName = @world.getName

    wm = main.mv.getCore.getMVWorldManager
    wm.deleteWorld worldName

    main.getLogger.log Level.INFO, 'World ' + worldName + ' deleted!'
  end
end
