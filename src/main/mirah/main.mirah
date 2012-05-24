package net.savagerealms.savagegames.savagegames

import java.util.logging.Level

import org.bukkit.plugin.java.JavaPlugin
import org.bukkit.Location

class SavageGames < JavaPlugin

  def onEnable
    getLogger().log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    getLogger().log Level.INFO, "SavageGames disabled."
  end

end

# An arena, with a location min and max.
class Arena
  # Accessors
  def min; @min; end
  def max; @max; end

  # Handy
  def world; @min.getWorld; end

  def initialize(min:Location, max:Location)
    if not min.getWorld.equals max.getWorld
      raise IllegalArgumentException.new "Worlds of the arena are not the same!"
    end

    @min = min
    @max = max
  end

  def contains?(loc:Location)
    if not loc.getWorld.equals world
      return false
    end

    x = loc.getX
    y = loc.getY
    z = loc.getZ

    x >= min.getBlockX and x <= max.getBlockX \
      and y >= min.getBlockY and y <= max.getBlockY \
      and z >= min.getBlockZ and z <= max.getBlockZ
  end

end
