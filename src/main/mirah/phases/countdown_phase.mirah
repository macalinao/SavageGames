package net.savagegames.savagegames

##
# The countdown phase of the game.
#
# This is where the game is about to start.
#
class CountdownPhase < GamePhase

  def enter(game:Game)
    game.start_repeating_task 'countdown', \
      GameCountdown.new, 0, 20
  end

  def exit(game:Game)
    game.cancel_task 'countdown'
  end

  ##
  # Game Countdown helper class.
  #
  # Used by the countdown phase.
  #
  class GameCountdown < GameTask
    
    def initialize
      @time = 10
    end

    def run
      if @time > 0
        game.broadcast Integer.toString(@time) + " seconds left!"
      else
        game.next_phase
      end
      @time -= 1
    end

  end
end
