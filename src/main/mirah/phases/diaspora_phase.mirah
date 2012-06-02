package net.savagegames.savagegames

import org.bukkit.ChatColor
import org.bukkit.entity.Player
import org.bukkit.Material
import org.bukkit.inventory.ItemStack

##
# The diaspora phase of the game.
#
# This is where everyone leaves from the center.
# You are not vulnerable to other players.
#
class DiasporaPhase < GamePhase

  def enter(game:Game)
    # Setup the players
    game.players.each do |p|
      player = Player(p)
      player.teleport game.type.spawn

      # Remove main inv
      inv = player.getInventory.getContents
      inv.length.times {|i|
        inv[i] = null
      }
      player.getInventory.setContents inv

      # Remove armor inv
      ainv = player.getInventory.getArmorContents
      ainv.length.times {|i|
        ainv[i] = null
      }
      player.getInventory.setArmorContents ainv

      player.updateInventory

      # Give compass
      items = ItemStack[1]
      items[0] = ItemStack.new(Material.COMPASS, 1)
      player.getInventory.addItem items

      # Setup class
      clazz = SavageGames.i.classes.get_class_of_player player
      if clazz == null
        player.sendMessage ChatColor.RED.toString + 'Because you have not chosen a class, you have been assigned a random class.'
        clazz = SavageGames.i.classes.get_class 'warrior'
      end
      clazz.bind player
    end

    game.broadcast 'May the odds be ever in your favor!'
    game.start_repeating_task 'diaspora', DiasporaTimer.new, (60 * 20), (15 * 20)
  end

  def exit(game:Game)
    game.cancel_task 'diaspora'
  end

  class DiasporaTimer < GameTask
    def initialize
      @time_left = 4
    end

    def run:void
      time = @time_left * 15
      if time <= 0
        game.next_phase
        return
      end

      game.broadcast Integer.toString(time) + ' seconds left until vulnerability!'
      @time_left -= 1
    end
  end
end
