package net.savagerealms.savagegames

import java.util.LinkedList
import java.util.HashMap

import org.bukkit.Bukkit
import org.bukkit.entity.Player

##
# Holds all of the game phases.
#
class GamePhases
  def self.Lobby(); @@lobby; end
  def self.Countdown(); @@countdown; end
  def self.Diaspora(); @@diaspora; end
  def self.Main(); @@main; end
  def self.Feast(); @@feast; end

  def self.initialize()
    @@lobby = GamePhase(LobbyPhase.new)
    @@countdown = GamePhase(CountdownPhase.new)
    @@diaspora = GamePhase(DiasporaPhase.new)
    @@main = GamePhase(MainPhase.new)
    @@feast = GamePhase(FeastPhase.new)

    @@phases = LinkedList.new
    @@phases.add @@lobby
    @@phases.add @@countdown
    @@phases.add @@diaspora
    @@phases.add @@main
    @@phases.add @@feast
  end

  def self.after(phase:GamePhase)
    index = @@phases.indexOf phase
    after = index + 1

    if after > @@phases.size - 1
      return nil
    end

    return @@phases.get after
  end
end

##
# A game phase.
#
# Has tasks built in.
#
class GamePhase

  def initialize()
    @tasks = HashMap.new
  end

  ##
  # Sets the task of the given game.
  #
  def setTaskOf(game:Game, task:int)
    @tasks.put game, Integer.valueOf(task)
  end

  ##
  # Finishes the task of the given game.
  #
  def finishTaskOf(game:Game)
    task = @tasks.remove game
    if task == nil
      return
    end

    intTask = Integer(task).intValue
    Bukkit.getScheduler.cancelTask intTask if intTask > 0
  end

  ##
  # Begins the game phase.
  def begin(game:Game):void
    enter game
  end

  ##
  # Ends the game phase
  #
  def end(game:Game):void
    exit game
  end

  ##
  # Gets the next game phase.
  #
  def next()
    GamePhases.after self
  end

  ##
  # Called when the game phase is endered.
  #
  protected
  def enter(game:Game):void; end

  ##
  # Called when the game phase is completed.
  #
  protected
  def exit(game:Game):void; end
end

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
      LobbyCountdown.new ((System.currentTimeMillis / 1000) + 300), \
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

      hs = (h > 0) ? '#{h}h' : ''
      ms = (m > 0) ? '#{m}m' : ''
      ss = (s > 0) ? '#{s}s' : ''

      game.broadcast 'The game will be starting in #{h}#{m}#{s}. Be prepared.'
    end
  end
end

##
# The countdown phase of the game.
#
# This is where the game is about to start.
#
class CountdownPhase < GamePhase

  def enter(game:Game)
    setTaskOf game, (Bukkit.getScheduler.scheduleAsyncRepeatingTask SavageGames.i, \
      GameCountdown.new(game, 10), 0, 20)
  end

  def exit(game:Game)
    finishTaskOf game
  end

end

##
# The diaspora phase of the game.
#
# This is where everyone leaves from the center.
#
class DiasporaPhase < GamePhase

  def enter(game:Game)
    game.broadcast 'May the games forever be in your favor!'
  end

  def exit(game:Game)

  end

end

##
# The main phase of the game.
#
# This is where a lot of people die.
#
class MainPhase < GamePhase

  def enter(game:Game)
    game.broadcast 'You are no longer invincible. Let the bloodshed begin!'
  end

end

##
# The feast phase of the game.
#
# Feasts are placed randomly everywhere.
#
class FeastPhase < GamePhase
end
