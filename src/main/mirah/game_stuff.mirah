package net.savagerealms.savagegames

import java.util.ArrayList
import java.util.Date
import java.util.HashMap

import org.bukkit.entity.Player
import org.bukkit.Bukkit
import org.bukkit.World

# Represents an active game.
class Game
  # Accessors
  def phase; @phase; end
  def participants; @participants; end
  def players; @players; end
  def spectators; @spectators; end

  def type; @type; end

  # Initializes a game.
  def initialize(type:GameType)
    @type = type
    @participants = ArrayList.new
    @players = ArrayList.new
    @spectators = ArrayList.new

    @phase = GamePhase(nil)

    setPhase GamePhases.Lobby
  end

  ##
  # Adds a participant to the game.
  #
  def addParticipant(p:Player)
    @participants.add p unless isFull?
  end

  ##
  # Checks if the game is a full game.
  #
  def isFull?
    @type.capacity <= @participants.size
  end

  ##
  # Changes the phase of the game.
  #
  def setPhase(phase:GamePhase)
    event = EventFactory.callGamePhaseChange self, phase
    @phase = event.phase
  end

  ##
  # Moves on to the next phase of the game.
  #
  def nextPhase()
    phase.end self
    @phase = phase.next
    phase.begin self
  end

  ##
  # Broadcasts a message to all participants of the game.
  #
  def broadcast(message:String)
    @participants.each do |p|
      Player(p).sendMessage message
    end
  end
end
