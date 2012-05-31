package net.savagerealms.savagegames

##
# Game Countdown helper class.
#
# Used by the countdown phase.
#
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
      @game.next_phase
    end
    @time -= 1
  end
end
