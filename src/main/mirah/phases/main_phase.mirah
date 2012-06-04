package net.savagegames.savagegames

##
# The main phase of the game.
#
# This is where a lot of people die.
#
class MainPhase < GamePhase

  def enter(game:Game)
    game.broadcast 'You are now vulnerable to other players. Let the bloodshed begin!'
  end

  def exit(game:Game)
  end

  def should_progress?(game:Game):boolean
    if game.players.size <= game.type.feast_players
      return true
    end
  end
end
