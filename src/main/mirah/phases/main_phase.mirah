package net.savagegames.savagegames

##
# The main phase of the game.
#
# This is where a lot of people die.
#
class MainPhase < GamePhase

  def enter(game:Game)
    game.broadcast 'You are now vulnerable to other players. Let the bloodshed begin!'
    if game.players.size <= 2
      game.next_phase
    end
  end

  def exit(game:Game)
  end

end
