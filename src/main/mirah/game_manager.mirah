package net.savagerealms.savagegames

import java.io.File
import java.io.IOException
import java.util.HashMap
import java.util.logging.Level

import org.bukkit.Bukkit
import org.bukkit.configuration.file.YamlConfiguration

class GameManager
  def initialize(main:SavageGames)
    @main = main
    @arenas = HashMap.new
  end

  # Loads the arenas.
  def loadArenas
    af = arenasFile

  end

  def saveArenas
    af = arenasFile

    @arenas.values.each do |au|
      arena = Arena(au)

      # Location
      af.set "arenas." + arena.id + ".loc.world", arena.min.getWorld.getName
      
      af.set "arenas." + arena.id + ".loc.x1", Integer.valueOf(arena.min.getBlockX)
      af.set "arenas." + arena.id + ".loc.y1", Integer.valueOf(arena.min.getBlockY)
      af.set "arenas." + arena.id + ".loc.z1", Integer.valueOf(arena.min.getBlockZ)
      
      af.set "arenas." + arena.id + ".loc.x2", Integer.valueOf(arena.min.getBlockX)
      af.set "arenas." + arena.id + ".loc.y2", Integer.valueOf(arena.min.getBlockY)
      af.set "arenas." + arena.id + ".loc.z2", Integer.valueOf(arena.min.getBlockZ)
    end
  end

  private
  def arenasFile
    folder = @main.getDataFolder
    file = File.new folder, "arenas.yml"

    if not file.exists
      begin
        file.createNewFile
      rescue IOException => ex
        @main.getLogger.log Level.SEVERE, "Could not create the arenas file! Terminating...", ex
        Bukkit.getPluginManager.disablePlugin @main
        return null
      end
    end

    return YamlConfiguration.loadConfiguration file
  end
end