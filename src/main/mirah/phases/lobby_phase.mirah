package net.savagegames.savagegames

##
# The lobby phase of the game.
#
# This is where everyone is begging for the game to start
# and fighting to get onto the server.
#
class LobbyPhase < GamePhase

  def enter(game:Game)
    LobbyPhase.schedule_new_countdown game
  end

  def exit(game:Game)
  end

  def self.schedule_new_countdown(game:Game)
    game.start_repeating_task 'lobby_countdown', \
      LobbyCountdown.new((System.currentTimeMillis / 1000) + 300), \
      0, 1
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

    def initialize(eta:long)
      @eta = eta
    end

    def run
      now = System.currentTimeMillis / 1000
      diff = eta - now

      secs = diff / 1000

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

      hs = (h > 0) ? Long.toString(h) + 'h' : ''
      ms = (m > 0) ? Long.toString(m) + 'm' : ''
      ss = (s > 0) ? Long.toString(s) + 's' : ''

      game.broadcast 'The game will be starting in #{h}#{m}#{s}. Be prepared.'
    end
  end
end