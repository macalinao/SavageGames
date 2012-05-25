package net.savagerealms.savagegames

import java.util.logging.Level
import java.util.ArrayList

import org.bukkit.plugin.java.JavaPlugin
import org.bukkit.Location
import org.bukkit.Bukkit
import org.bukkit.entity.Player

import com.sk89q.worldedit.bukkit.WorldEditPlugin

# Main plugin class.
class SavageGames < JavaPlugin
  # Accessors
  def self.i; @@i; end
  def worldEdit; @worldEdit; end

  def onEnable
    @@i = self

    # Load WorldEdit
    worldEdit = getServer.getPluginManager.getPlugin "WorldEdit"
    if worldEdit.kind_of?(WorldEditPlugin)
      @worldEdit = WorldEditPlugin(worldEdit)
    else
      getLogger.log Level.SEVERE, "WorldEdit not found! This plugin is being disabled."
      Bukkit.getPluginManager.disablePlugin(self)
    end

    # We're loaded!
    getLogger.log Level.INFO, "Let the SavageGames begin!"
  end

  def onDisable
    getLogger.log Level.INFO, "SavageGames disabled."
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

# Represents an active game.
class Game
  # Accessors
  def arena; @arena; end
  def mode; @mode; end
  def participants; @participants; end

  # Initializes a game.
  def initialize(arena:Arena)
    @arena = arena
    @mode = "waiting"

    @participants = ArrayList.new
  end

  # Starts a game.
  def start
    @mode = "starting"
    @task = Bukkit.getScheduler.scheduleAsyncRepeatingTask SavageGames.i, \
      GameCountdown.new(self, 10), 0, 20
  end

  # Broadcasts a message to all participants of the game.
  def broadcast(message:String)
    @participants.each do |p|
      Player(p).sendMessage message # Mirah doesn't have generics yet.
    end
  end

  # Ends an in-progress countdown.
  def endCountdown
    Bukkit.getScheduler.cancelTask @task if @task != 0
  end

end

class GameCountdown
  implements Runnable
  
  def initialize(game:Game, time:int)
    @game = game
    @time = time
  end

  def run
    if @time > 0
      @game.broadcast Integer.toString(@time) + " seconds left!"
    else
      @game.broadcast "May the games be in your favor!"
      @game.endCountdown
    end
    @time -= 1
  end
end
