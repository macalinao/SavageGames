package net.savagegames.savagegames

import java.util.Random
import java.util.ArrayList
import java.util.Arrays

import org.bukkit.Location
import org.bukkit.ChatColor
import org.bukkit.Material

import org.bukkit.block.BlockState
import org.bukkit.block.Chest

import org.bukkit.enchantments.Enchantment

import org.bukkit.inventory.Inventory
import org.bukkit.inventory.ItemStack

import org.bukkit.potion.Potion
import org.bukkit.potion.PotionType

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

  def should_progress?(game:Game):boolean
    return game.players.size <= 1
  end

  ##
  # Countdown to create the feast
  #
  class FeastCountdown < GameTask
    def time; @time; end
    def center; @center; end

    def initialize
      @center = Location(nil)
      @time = 301 # Add 1 because i'm lazy
    end

    def run:void
      @time -= 1
      if time == 300
        startup
        return
      end

      m =  time / 60
      s = time % 60

      if m > 0 
        if s == 0
          thex = center.getBlockX
          they = center.getBlockY
          thez = center.getBlockZ
          game.broadcast ChatColor.RED.toString + "The feast begins in #{m} minutes at (#{thex}, #{they}, #{thez})."
        end
        return
      end

      if s <= 10
        if s == 0
          start_feast
        else
          game.broadcast ChatColor.RED.toString + "#{s} seconds left!"
        end
        return
      end

      if s % 15 == 0
        thex = center.getBlockX
        they = center.getBlockY
        thez = center.getBlockZ
        game.broadcast ChatColor.RED.toString + "The feast begins in #{s} seconds at (#{thex}, #{they}, #{thez})."
        return
      end
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

      @center = Location.new spawn.getWorld, thex, they, thez
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

      maxx = x + 10
      maxz = z + 10

      i = x - 10
      while i < maxx
        j = z - 10
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
      first = upcent.add(-2, 0, -2)
      
      i = 0
      j = 0

      while i < 2
        while j < 2
          block = first.getWorld.getBlockAt(first.add(i, 0, j))
          block.setType Material.CHEST
          
          state = block.getState
          chest = Chest(state)

          chest_inv = chest.getBlockInventory
          populate_chest chest_inv

          i += 2
        end
        i += 2
      end

      upcent.getWorld.getBlockAt(upcent).setType Material.ENCHANTMENT_TABLE
    end

    ##
    # Populates the chest.
    #
    def populate_chest(inv:Inventory):void
      rand = Random.new System.currentTimeMillis
      inv.addItem gen_chest_items rand
    end

    ##
    # Generates chest items.
    # Thanks Svinnik.
    #
    #
    # [21:54:40] (Channel) Svinnik: Diamond boots: 2%
    # Diamond Chesplate: 2%
    # Diamond leggings: 2%
    # Diamond headpiece: 2%
    # Diamond sword: 5%
    # Power V bow: 1%
    # Diamond: 5%
    # Strength II pot: 3%
    # Poison II pot: 3%
    # Swiftness II pot: 3%
    # -- BELOW IS UNIMPLEMENTED --
    # Ender pearl: 10%
    # Food: 30%
    # Lava bucket: 10%
    # Water Bucket: 10%
    # Bottle o' enchanting: 15%
    # Fire resist pot: 6%
    # Iron: 21%
    #
    def gen_chest_items(rand:Random):ItemStack[]
      items = ArrayList.new

      roll = 0

      roll = rand.nextInt 100
      if roll <= 2
        items.add ItemStack.new(Material.DIAMOND_BOOTS, 1)
      end

      roll = rand.nextInt 100
      if roll <= 2
        items.add ItemStack.new(Material.DIAMOND_LEGGINGS, 1)
      end

      roll = rand.nextInt 100
      if roll <= 2
        items.add ItemStack.new(Material.DIAMOND_HELMET, 1)
      end

      roll = rand.nextInt 100
      if roll <= 5
        items.add ItemStack.new(Material.DIAMOND_SWORD, 1)
      end

      roll = rand.nextInt 100
      if roll <= 1
        bow = ItemStack.new(Material.BOW, 1)
        bow.addEnchantment Enchantment.ARROW_DAMAGE, 5
        items.add bow
      end

      roll = rand.nextInt 100
      if roll <= 5
        items.add ItemStack.new(Material.DIAMOND, 5)
      end

      # Strength II
      roll = rand.nextInt 100
      if roll <= 3
        potion = Potion.new PotionType.STRENGTH, 2
        items.add potion.toItemStack 1
      end

      # Poison II
      roll = rand.nextInt 100
      if roll <= 3
        potion = Potion.new PotionType.POISON, 2
        items.add potion.toItemStack 1
      end

      # Swiftness II
      roll = rand.nextInt 100
      if roll <= 3
        potion = Potion.new PotionType.SPEED, 2
        items.add potion.toItemStack 1
      end

      # Strength II
      roll = rand.nextInt 100
      if roll <= 10
        items.add ItemStack.new Material.ENDER_PEARL, 1
      end

      ret = ItemStack[items.size]

      q = 0
      it = items.iterator

      while it.hasNext
        o = it.next
        i = ItemStack(o)

        ret[q] = i
        q += 1
      end

      return ret
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
