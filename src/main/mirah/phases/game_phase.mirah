package net.savagegames.savagegames

import java.util.HashMap

import org.bukkit.Bukkit
import org.bukkit.entity.Player


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
  def next:GamePhase
    GamePhases.after self
  end

  ##
  # Returns true if this phase is at or past the given phase.
  #
  def is_at_least(phase:GamePhase)
    return (GamePhases.last phase, self) == self
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
