package net.savagegames.savagegames

##
# The lobby phase of the game.
#
# This is where everyone is begging for the game to start
# and fighting to get onto the server.
#
class LobbyPhase < GamePhase

  def enter(game:Game):void
    LobbyPhase.schedule_new_countdown game
  end

  def exit(game:Game):void
  end

  def self.schedule_new_countdown(game:Game):void
    game.start_repeating_task 'lobby_countdown', LobbyCountdown.new, 0, 20
  end

  ##
  # Lobby countdown
  #
  # At the end of its time, checks to see if the game is ready.
  # If it is, it progresses to the next phase.
  #
  # Make it repeat every so often so it tells you how much time is left.
  #
  class LobbyCountdown < GameTask
    def eta; @eta; end

    def initialize
      @eta = (System.currentTimeMillis / 1000) + 300
    end

    def run:void
      now = System.currentTimeMillis / 1000
      secs = eta - now

      if secs < 10
        unless game.can_start
          game.broadcast 'The start of the game is being delayed as there are not enough players.'
          LobbyPhase.schedule_new_countdown game
        else
          game.next_phase
        end
      end

      h = secs / 3600
      r = secs % 3600
      m = r / 60
      s = r % 60

      if m > 1 and (s % 30 != 0)
        return
      end

      if s > 10 and s % 10 != 0
        return
      end

      hs = (h > 0) ? Long.toString(h) + 'hours ' : ''
      ms = (m > 0) ? Long.toString(m) + 'minutes ' : ''
      ss = (s > 0) ? Long.toString(s) + 'seconds ' : ''

      game.broadcast 'The game will be starting in ' + (hs + ms + ss).trim + '. Be prepared.'
    end
  end
end
