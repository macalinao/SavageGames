package net.savagegames.savagegames

import java.util.Random

import org.bukkit.Location
import org.bukkit.ChatColor
import org.bukkit.Material

##
# The feast phase of the game.
#
# Feasts are placed randomly everywhere.
#
class FeastPhase < GamePhase
  def enter(game:Game):void
    game.start_repeating_task 'feast_countdown', FeastCountdown.new, 0, 20
  end

  def exit(game:Game):void
  end

  ##
  # Countdown to create the feast
  #
  class FeastCountdown < GameTask
    def time; @time; end
    def center; @center; end

    def initialize
      @center = Location(nil)
      @time = 300
    end

    def run:void
      if time == 300
        startup
        return
      end

      m =  time / 60
      s = time % 60

      if m > 0
        if s == 0
          game.broadcast ChatColor.RED.toString + "The feast begins in #{m} minutes."
        end
        return
      end

      if s % 15 == 0
        game.broadcast ChatColor.RED.toString + "The feast begins in #{s} seconds."
        return
      end

      if s <= 10
        game.broadcast ChatColor.RED.toString + "#{s} seconds left!"
        return
      end

      if s == 0
        start_feast
      end

      @time -= 1
    end

    def startup
      spawn = game.type.spawn

      # Find a random point in map
      world = spawn.getWorld

      x = spawn.getBlockX
      z = spawn.getBlockZ

      minx = x - 200
      maxx = x + 200
      minz = z - 200
      maxz = z + 200

      rand = Random.new System.currentTimeMillis

      pox = rand.nextInt 400
      poz = rand.nextInt 400

      pminx = minx + pox
      pmaxx = pminx + 20

      pminz = minz + poz
      pmaxz = pminz + 20

      highest_y = 0

      i = pminx
      while i < pmaxx
        j = pminz
        while j < pmaxz
          height = world.getHighestBlockAt(i, j).getLocation.getBlockY
          if height > highest_y
            highest_y = height
          end
          j += 1
        end
        i += 1
      end

      thex = pminx + 10
      they = highest_y
      thez = pminz + 10

      @center = Location.new spawn.getWorld, thex, they, thex
      generate_feast_platform
      
      game.broadcast ChatColor.RED.toString + "A feast will happen at (#{thex}, #{they}, #{thez}) in 5 minutes!"
    end

    ##
    # Generates the feast platform.
    #
    def generate_feast_platform
      world = center.getWorld
      x = center.getBlockX
      y = center.getBlockY
      z = center.getBlockZ

      maxx = x + 20
      maxz = z + 20

      i = x - 20
      while i < maxx
        j = z - 20
        while j < maxz
          world.getBlockAt(i, y, j).setType Material.GRASS
          j += 1
        end
        i += 1
      end
    end

    ##
    # Starts the feast.
    #
    def start_feast
      generate_feast
      game.broadcast ChatColor.RED.toString + 'The feast has begun!'

      game.cancel_task 'feast_countdown'
      game.start_delayed_task 'feast_intermission', FeastIntermission.new, 20 * 600 # 10 minutes
    end

    ##
    # Generates a feast.
    #
    def generate_feast
      upcent = center.add 0, 1, 0

      upcent.getWorld.getBlockAt(upcent).setType Material.ENCHANTMENT_TABLE
    end
  end

  ##
  # Feast intermission.
  #
  class FeastIntermission < GameTask
    def run:void
      game.start_repeating_task 'feast_countdown', FeastCountdown.new, 0, 20
    end
  end
end
