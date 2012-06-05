package net.savagegames.savagegames

import org.bukkit.ChatColor

import org.bukkit.entity.Player

##
# The lobby phase of the game.
#
# This is where everyone is begging for the game to start
# and fighting to get onto the server.
#
class LobbyPhase < GamePhase

  def enter(game:Game):void
    LobbyPhase.schedule_new_countdown game

    game.start_repeating_task 'hunger_satiator', HungerSatiator.new, 0, 40 # Every 2 seconds
  end

  def exit(game:Game):void
    game.cancel_task 'lobby_countdown'
    game.cancel_task 'hunger_satiator'
  end

  def self.schedule_new_countdown(game:Game):void
    game.cancel_task 'lobby_countdown'
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
    def time; @time; end

    def initialize
      @time = 300
      @time = 60 # TEMP!
    end

    def run:void
      secs = @time
      @time -= 1

      if secs <= 0
        unless game.participants.size >= game.type.min_players
          game.broadcast 'The start of the game is being delayed as there are not enough players.'
          LobbyPhase.schedule_new_countdown game
          return
        else
          game.next_phase
          return
        end
      end

      h = secs / 3600
      r = secs % 3600
      m = r / 60
      s = r % 60

      if m > 0 and (s % 30 != 0)
        return
      end

      if s > 10 and s % 15 != 0
        return
      end

      hs = (h > 0) ? Long.toString(h) + ' hours ' : ''
      ms = (m > 0) ? Long.toString(m) + ' minutes ' : ''
      ss = (s > 0) ? Long.toString(s) + ' seconds ' : ''

      unless h == 0 and m == 0 and s <= 10
        game.broadcast ChatColor.YELLOW.toString + 'The game will be starting in ' + (hs + ms + ss).trim + '. Be prepared.'
      else
        game.broadcast ChatColor.YELLOW.toString + ss + 'left!'
      end
    end
  end

  ##
  # Satiates hunger.
  #
  class HungerSatiator < GameTask
    def run:void
      game.participants.each do |p|
        player = Player(p)

        player.setFoodLevel 20
      end
    end
  end
end
