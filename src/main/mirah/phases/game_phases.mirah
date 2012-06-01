package net.savagegames.savagegames

import java.util.LinkedList

##
# Holds all of the game phases.
#
class GamePhases
  def self.Lobby(); @@lobby; end
  def self.Diaspora(); @@diaspora; end
  def self.Main(); @@main; end
  def self.Feast(); @@feast; end

  def self.initialize():void
    @@lobby = GamePhase(LobbyPhase.new)
    @@diaspora = GamePhase(DiasporaPhase.new)
    @@main = GamePhase(MainPhase.new)
    @@feast = GamePhase(FeastPhase.new)

    @@phases = LinkedList.new
    @@phases.add @@lobby
    @@phases.add @@diaspora
    @@phases.add @@main
    @@phases.add @@feast
  end

  ##
  # Gets the game phase after the given one.
  # Returns nil if there is none.
  #
  def self.after(phase:GamePhase):GamePhase
    index = @@phases.indexOf phase
    after = index + 1

    if after > @@phases.size - 1
      return nil
    end

    return GamePhase(@@phases.get after)
  end

  ##
  # Gets the latter game phase.
  #
  def self.last(phase:GamePhase, other:GamePhase):GamePhase
    i = @@phases.indexOf phase
    j = @@phases.indexOf other

    if i > j
      return phase
    elsif i < j
      return other
    else
      return phase # The first is the last
    end 
  end
end
