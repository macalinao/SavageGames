package net.savagegames.savagegames

##
# The diaspora phase of the game.
#
# This is where everyone leaves from the center.
# You are not vulnerable to other players.
#
class DiasporaPhase < GamePhase

  def enter(game:Game)
    game.broadcast 'May the games forever be in your favor!'
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
