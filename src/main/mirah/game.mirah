package net.savagerealms.savagegames

import org.bukkit.entity.Player
import org.bukkit.Bukkit

# Represents an active game.
class Game
  # Accessors
  def arena; @arena; end
  def mode; @mode; end
  def participants; @participants; end

  # Initializes a game.
  def initialize(arena:Arena)
    @arena = arena
    @mode = "waiting"

    @participants = ArrayList.new
  end

  # Starts the game.
  def start
    @mode = "starting"
    @task = Bukkit.getScheduler.scheduleAsyncRepeatingTask SavageGames.i, \
      GameCountdown.new(self, 10), 0, 20
  end

  # Adds a participant to the game.
  def addParticipant(p:Player)
    participants.add p unless isFull?
  end

  # Checks if the game is a full game.
  def isFull?
    @arena.capacity <= @participants.size
  end

  # Broadcasts a message to all participants of the game.
  def broadcast(message:String)
    @participants.each do |p|
      Player(p).sendMessage message # Mirah doesn't have generics yet.
    end
  end

  # Ends an in-progress countdown.
  def endCountdown
    Bukkit.getScheduler.cancelTask @task if @task != 0
  end

end

# Game Countdown helper class.
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
      @game.broadcast "May the games be in your favor!"
      @game.endCountdown
    end
    @time -= 1
  end
end
