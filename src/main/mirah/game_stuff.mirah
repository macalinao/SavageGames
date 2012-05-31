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

  def players; @players; end
  def spectators; @spectators; end

  def type; @type; end
  
  def participants()
    list = ArrayList.new(players)
    list.addAll spectators
    return list
  end

  # Initializes a game.
  def initialize(type:GameType)
    @type = type
    @tasks = HashMap.new

    @players = ArrayList.new
    @spectators = ArrayList.new

    @phase = GamePhase(nil)

    setPhase GamePhases.Lobby
  end

  ##
  # Adds a participant to the game.
  #
  def add_participant(p:Player):boolean
    unless is_full?
      @players.add p
      return true
    end
    return false 
  end

  ##
  # Checks if the game is a full game.
  #
  def is_full?
    @type.capacity <= @players.size
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
    if @phase != nil
      phase.begin self
    else
      end_game
    end
  end

  ##
  # Ends the game.
  #
  def end_game()
    # TODO
  end

  ##
  # Broadcasts a message to all participants of the game.
  #
  def broadcast(message:String)
    participants.each do |p|
      Player(p).sendMessage message
    end
  end

  ###################
  # TASKS
  ###################

  ##
  # Starts a new repeating task.
  #
  def start_repeating_task(name:String, task:GameTask, delay:long, interval:long)
    task.game = self
    task_id = Bukkit.getScheduler.scheduleAsyncRepeatingTask SavageGames.i, task, delay, interval
    
    current = get_task name
    unless current < 0
      return
    end

    @tasks.put name, Integer.valueOf(task_id)
  end

  ##
  # Starts a new delayed task.
  #
  def start_delayed_task(name:String, task:GameTask, delay:long)
    task.game = self
    task_id = Bukkit.getScheduler.scheduleAsyncDelayedTask SavageGames.i, task, delay
    
    current = get_task name
    unless current < 0
      return
    end

    @tasks.put name, Integer.valueOf(task_id)
  end

  ##
  # Cancels a task.
  #
  def cancel_task(name:String)
    task = @tasks.get name

    current = get_task name
    unless current >= 0
      return
    end

    Bukkit.getScheduler.cancelTask current
  end

  ##
  # Gets a task.
  #
  private
  def get_task(name:String)
    task = @tasks.get name
    if task == nil
      return -1
    end

    unless task.kind_of? Integer
      return -1
    end

    return Integer(task).intValue
  end
end

##
# A game task.
#
class GameTask < Runnable
  def game; @game; end  
  def game=(game:Game); @game = game; end 
end
