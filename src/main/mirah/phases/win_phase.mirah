package net.savagegames.savagegames

import org.bukkit.entity.Player

##
# The main phase of the game.
#
# This is where a lot of people die.
#
class WinPhase < GamePhase

  def enter(game:Game)
    if game.players.size <= 0
      game.next_phase
    end

    player = game.players.get(0)
    Player(player).kickPlayer "Congrats! You've won! Please rejoin in 5 seconds."
  end

  def exit(game:Game)
  end

  def should_progress?(game:Game):boolean
    return true
  end
end
