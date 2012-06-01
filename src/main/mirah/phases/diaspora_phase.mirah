package net.savagegames.savagegames

import org.bukkit.entity.Player

##
# The diaspora phase of the game.
#
# This is where everyone leaves from the center.
# You are not vulnerable to other players.
#
class DiasporaPhase < GamePhase

  def enter(game:Game)
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
    end

    game.broadcast 'May the odds be ever in your favor!'
    game.start_delayed_task 'diaspora', DiasporaTimer.new, 2400 # 20 * 60 * 2
  end

  def exit(game:Game)
    game.cancel_task 'diaspora'
  end

  class DiasporaTimer < GameTask
    def run
      game.next_phase
    end
  end
end
