package net.savagerealms.savagegames

import java.util.HashMap

import org.bukkit.Location

# An arena, with a location min and max.
class Arena
  # Accessors
  def id; @id; end
  def min; @min; end
  def max; @max; end

  def spawns; @spawns; end
  
  def minPlayers; @minPlayers; end
  def minPlayers=(a:int); @minPlayers = a; end

  # Handy
  def world; @min.getWorld; end

  # Initializes the arena.
  def initialize(id:String, min:Location, max:Location)
    if not min.getWorld.equals max.getWorld
      raise IllegalArgumentException.new "Worlds of the arena are not the same!"
    end

    @id = id
    @min = min
    @max = max

    @spawns = HashMap.new
  end

  # Checks if the arena contains the given location.
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

  # Gets the capacity of the arena.
  def capacity
    @spawns.size
  end

end
