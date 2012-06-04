package net.savagegames.savagegames

##
# The main phase of the game.
#
# This is where a lot of people die.
#
class WinPhase < GamePhase

  def enter(game:Game)
    game.broadcast 'You have won the game! Unfortunately the code to start the next game does not exist!'
  end

  def exit(game:Game)
  end

  def should_progress?(game:Game):boolean
    return true
  end
end
